import os
import glob
import re

KOTLIN_JVM_TARGET_PATCH = """

tasks.withType(org.jetbrains.kotlin.gradle.tasks.KotlinCompile).all {
    kotlinOptions {
        jvmTarget = '11'
    }
}
"""

ANDROID_COMPILE_OPTIONS_PATCH = """
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_11
        targetCompatibility JavaVersion.VERSION_11
    }
"""

ANDROID_KOTLIN_OPTIONS_PATCH = """
    kotlinOptions {
        jvmTarget = '11'
    }
"""

LEGACY_SUPPORT_EXCLUDE_GROOVY = """

configurations.all {
    exclude group: 'com.android.support'
}
"""

LEGACY_SUPPORT_EXCLUDE_KTS = """

configurations.all {
    exclude(group = "com.android.support")
}
"""

def add_to_android_block(content, patch, marker):
    if marker in content or 'android {' not in content:
        return content

    insert_pos = content.find('android {') + len('android {')
    return content[:insert_pos] + patch + content[insert_pos:]

def add_top_level_patch(content, patch, marker):
    if marker in content:
        return content
    return content.rstrip() + patch + '\n'

def force_java_11_compile_options(content):
    content = re.sub(
        r'sourceCompatibility\s+JavaVersion\.VERSION_(?:1_)?8',
        'sourceCompatibility JavaVersion.VERSION_11',
        content,
    )
    content = re.sub(
        r'targetCompatibility\s+JavaVersion\.VERSION_(?:1_)?8',
        'targetCompatibility JavaVersion.VERSION_11',
        content,
    )
    content = re.sub(
        r'sourceCompatibility\s*=\s*JavaVersion\.VERSION_(?:1_)?8',
        'sourceCompatibility = JavaVersion.VERSION_11',
        content,
    )
    content = re.sub(
        r'targetCompatibility\s*=\s*JavaVersion\.VERSION_(?:1_)?8',
        'targetCompatibility = JavaVersion.VERSION_11',
        content,
    )
    return content

def force_kotlin_11_options(content):
    content = re.sub(
        r'jvmTarget\s*=\s*["\'](?:1\.)?8["\']',
        "jvmTarget = '11'",
        content,
    )
    return content

def align_kotlin_jvm_target(content):
    has_kotlin = (
        'kotlin-android' in content or
        'org.jetbrains.kotlin.android' in content or
        'KotlinCompile' in content
    )
    if not has_kotlin:
        return content

    content = force_java_11_compile_options(content)
    content = force_kotlin_11_options(content)
    content = add_to_android_block(content, ANDROID_COMPILE_OPTIONS_PATCH, 'sourceCompatibility JavaVersion.VERSION_11')
    content = add_to_android_block(content, ANDROID_KOTLIN_OPTIONS_PATCH, "jvmTarget = '11'")

    if 'tasks.withType(org.jetbrains.kotlin.gradle.tasks.KotlinCompile)' not in content:
        content += KOTLIN_JVM_TARGET_PATCH

    return content

def exclude_legacy_support_dependencies(content):
    return add_top_level_patch(
        content,
        LEGACY_SUPPORT_EXCLUDE_GROOVY,
        "exclude group: 'com.android.support'",
    )

def exclude_legacy_support_dependencies_kts(content):
    return add_top_level_patch(
        content,
        LEGACY_SUPPORT_EXCLUDE_KTS,
        'exclude(group = "com.android.support")',
    )

def remove_java_method(content, signature):
    start = content.find(signature)
    if start == -1:
        return content

    brace_start = content.find('{', start)
    if brace_start == -1:
        return content

    depth = 0
    for index in range(brace_start, len(content)):
        if content[index] == '{':
            depth += 1
        elif content[index] == '}':
            depth -= 1
            if depth == 0:
                end = index + 1
                while end < len(content) and content[end] in '\r\n':
                    end += 1
                line_start = content.rfind('\n', 0, start) + 1
                return content[:line_start] + content[end:]

    return content

def remove_permission_handler_registrar_branches(content):
    content = re.sub(
        r'\s*if\s*\(\s*this\.pluginRegistrar\s*!=\s*null\s*\)\s*\{\s*'
        r'this\.pluginRegistrar\.addActivityResultListener\(this\.permissionManager\);\s*'
        r'this\.pluginRegistrar\.addRequestPermissionsResultListener\(this\.permissionManager\);\s*'
        r'\}\s*else\s*',
        '\n        ',
        content,
    )
    content = re.sub(
        r'\s*if\s*\(\s*this\.pluginRegistrar\s*!=\s*null\s*\)\s*\{\s*'
        r'this\.pluginRegistrar\.removeActivityResultListener\(this\.permissionManager\);\s*'
        r'this\.pluginRegistrar\.removeRequestPermissionsResultListener\(this\.permissionManager\);\s*'
        r'\}\s*else\s*',
        '\n        ',
        content,
    )
    return content

def patch_android():
    manifest_path = 'android/app/src/main/AndroidManifest.xml'
    if not os.path.exists(manifest_path):
        print(f"Error: {manifest_path} not found")
        return
    
    with open(manifest_path, 'r') as f:
        content = f.read()
    
    # 1. Add permissions/features inside <manifest>
    manifest_entries = [
        '    <uses-permission android:name="android.permission.CAMERA" />',
        '    <uses-permission android:name="android.permission.INTERNET" />',
        '    <uses-feature android:name="android.hardware.camera.ar" android:required="false" />',
    ]
    missing_entries = [
        entry for entry in manifest_entries
        if entry.split('android:name="', 1)[1].split('"', 1)[0] not in content
    ]
    if missing_entries:
        content = content.replace('<application', '\n'.join(missing_entries) + '\n    <application')
    content = content.replace(
        '<uses-feature android:name="android.hardware.camera.ar" android:required="true" />',
        '<uses-feature android:name="android.hardware.camera.ar" android:required="false" />',
    )
    
    # 2. Add meta-data inside <application>
    meta_data = """
        <meta-data android:name="com.google.ar.core" android:value="optional" />
"""
    if 'com.google.ar.core' not in content:
        app_start = content.find('<application')
        closing_bracket = content.find('>', app_start)
        content = content[:closing_bracket + 1] + meta_data + content[closing_bracket + 1:]
    content = content.replace(
        '<meta-data android:name="com.google.ar.core" android:value="required" />',
        '<meta-data android:name="com.google.ar.core" android:value="optional" />',
    )
        
    with open(manifest_path, 'w') as f:
        f.write(content)
        
    # 3. Patch build.gradle to minSdkVersion 24 (Groovy)
    gradle_path = 'android/app/build.gradle'
    if os.path.exists(gradle_path):
        with open(gradle_path, 'r') as f:
            gradle_content = f.read()
        
        gradle_content = gradle_content.replace('flutter.minSdkVersion', '24')
        gradle_content = gradle_content.replace('minSdkVersion 16', 'minSdkVersion 24')
        gradle_content = gradle_content.replace('minSdkVersion 19', 'minSdkVersion 24')
        gradle_content = gradle_content.replace('minSdkVersion 20', 'minSdkVersion 24')
        gradle_content = gradle_content.replace('minSdkVersion 21', 'minSdkVersion 24')
        gradle_content = exclude_legacy_support_dependencies(gradle_content)
        
        with open(gradle_path, 'w') as f:
            f.write(gradle_content)

    # 4. Patch build.gradle.kts to minSdkVersion 24 (Kotlin DSL)
    kts_path = 'android/app/build.gradle.kts'
    if os.path.exists(kts_path):
        with open(kts_path, 'r') as f:
            kts_content = f.read()
            
        kts_content = kts_content.replace('flutter.minSdkVersion', '24')
        kts_content = exclude_legacy_support_dependencies_kts(kts_content)
        
        with open(kts_path, 'w') as f:
            f.write(kts_content)
            
    print("Android platform files patched successfully.")

def patch_ios():
    plist_path = 'ios/Runner/Info.plist'
    if not os.path.exists(plist_path):
        print(f"Error: {plist_path} not found")
        return
        
    with open(plist_path, 'r') as f:
        content = f.read()
        
    keys = """
	<key>NSCameraUsageDescription</key>
	<string>ImmoSpace requires camera access to scan your floor surface and project 3D models in real space.</string>
	<key>UIRequiredDeviceCapabilities</key>
	<array>
		<string>armv7</string>
		<string>arkit</string>
	</array>
"""
    if 'NSCameraUsageDescription' not in content:
        last_dict_index = content.rfind('</dict>')
        if last_dict_index != -1:
            content = content[:last_dict_index] + keys + content[last_dict_index:]
            
    with open(plist_path, 'w') as f:
        f.write(content)
        
    print("iOS platform files patched successfully.")

def fix_ar_flutter_plugin():
    # Find the ar_flutter_plugin in pub cache and patch its gradle file to fix build errors
    home_dir = os.path.expanduser('~')
    # Can be in PUB_CACHE environment variable or ~/.pub-cache
    pub_cache = os.environ.get('PUB_CACHE', os.path.join(home_dir, '.pub-cache'))
    
    search_pattern = os.path.join(pub_cache, 'hosted', 'pub.dev', 'ar_flutter_plugin-*', 'android', 'build.gradle')
    matches = glob.glob(search_pattern)
    
    if not matches:
        print(f"Could not find ar_flutter_plugin in {search_pattern}")
        return
        
    for path in matches:
        print(f"Patching plugin at {path}")
        with open(path, 'r') as f:
            content = f.read()
            
        # Fix jcenter() removal
        content = content.replace('jcenter()', 'mavenCentral()')
        
        # Fix NullPointerException caused by missing ext.kotlin_version in root project
        content = content.replace('$ext.kotlin_version', '1.8.0')
        content = content.replace('${project.ext.kotlin_version}', '1.8.0')
        content = content.replace('project.ext.kotlin_version', '"1.8.0"')
        content = content.replace('$kotlin_version', '1.8.0')
        
        # Add namespace to android block
        if 'namespace' not in content:
            content = content.replace('android {', 'android {\n    namespace "io.carius.lars.ar_flutter_plugin"')
            
        # Remove obsolete afterEvaluate block that causes 'configurations.all' error in Gradle 8+
        after_eval_start = content.find('afterEvaluate {')
        if after_eval_start != -1:
            content = content[:after_eval_start]

        content = align_kotlin_jvm_target(content)
        content = exclude_legacy_support_dependencies(content)
        
        with open(path, 'w') as f:
            f.write(content)

def fix_permission_handler_android():
    # permission_handler_android 10.3.6 still contains the removed Flutter v1
    # embedding registerWith(Registrar) hook. Flutter 3.44 no longer exposes
    # PluginRegistry.Registrar, so keep only the v2 embedding implementation.
    home_dir = os.path.expanduser('~')
    pub_cache = os.environ.get('PUB_CACHE', os.path.join(home_dir, '.pub-cache'))
    search_pattern = os.path.join(
        pub_cache,
        'hosted',
        'pub.dev',
        'permission_handler_android-*',
        'android',
        'src',
        'main',
        'java',
        'com',
        'baseflow',
        'permissionhandler',
        'PermissionHandlerPlugin.java',
    )
    matches = glob.glob(search_pattern)

    if not matches:
        print(f"Could not find permission_handler_android in {search_pattern}")
        return

    for path in matches:
        with open(path, 'r') as f:
            content = f.read()

        patched = remove_java_method(
            content,
            'public static void registerWith(io.flutter.plugin.common.PluginRegistry.Registrar registrar)',
        )
        patched = remove_permission_handler_registrar_branches(patched)
        patched = patched.replace(
            'io.flutter.plugin.common.PluginRegistry.Registrar',
            'Object',
        )

        if patched != content:
            print(f"Removing Flutter v1 embedding hook from {path}")
            with open(path, 'w') as f:
                f.write(patched)

def fix_pub_cache_android_plugins():
    # Flutter 3.44/Gradle now fails when Java and Kotlin tasks target different JVMs.
    # Patch Android plugins in the pub cache so their Java/Kotlin targets match and old
    # support-library artifacts do not conflict with AndroidX.
    home_dir = os.path.expanduser('~')
    pub_cache = os.environ.get('PUB_CACHE', os.path.join(home_dir, '.pub-cache'))
    search_pattern = os.path.join(pub_cache, 'hosted', 'pub.dev', '*', 'android', 'build.gradle')
    matches = glob.glob(search_pattern)

    for path in matches:
        with open(path, 'r') as f:
            content = f.read()

        patched = align_kotlin_jvm_target(content)
        patched = exclude_legacy_support_dependencies(patched)
        if patched != content:
            print(f"Patching Android plugin Gradle config at {path}")
            with open(path, 'w') as f:
                f.write(patched)

if __name__ == '__main__':
    fix_ar_flutter_plugin()
    fix_permission_handler_android()
    fix_pub_cache_android_plugins()
    patch_android()
    patch_ios()
