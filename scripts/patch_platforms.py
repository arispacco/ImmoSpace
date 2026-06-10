import os
import glob

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

def add_to_android_block(content, patch, marker):
    if marker in content or 'android {' not in content:
        return content

    insert_pos = content.find('android {') + len('android {')
    return content[:insert_pos] + patch + content[insert_pos:]

def align_kotlin_jvm_target(content):
    has_kotlin = (
        'kotlin-android' in content or
        'org.jetbrains.kotlin.android' in content or
        'KotlinCompile' in content
    )
    if not has_kotlin:
        return content

    content = add_to_android_block(content, ANDROID_COMPILE_OPTIONS_PATCH, 'sourceCompatibility JavaVersion.VERSION_11')
    content = add_to_android_block(content, ANDROID_KOTLIN_OPTIONS_PATCH, "jvmTarget = '11'")

    if 'tasks.withType(org.jetbrains.kotlin.gradle.tasks.KotlinCompile)' not in content:
        content += KOTLIN_JVM_TARGET_PATCH

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
        '    <uses-feature android:name="android.hardware.camera.ar" android:required="true" />',
    ]
    missing_entries = [
        entry for entry in manifest_entries
        if entry.split('android:name="', 1)[1].split('"', 1)[0] not in content
    ]
    if missing_entries:
        content = content.replace('<application', '\n'.join(missing_entries) + '\n    <application')
    
    # 2. Add meta-data inside <application>
    meta_data = """
        <meta-data android:name="com.google.ar.core" android:value="required" />
"""
    if 'com.google.ar.core' not in content:
        app_start = content.find('<application')
        closing_bracket = content.find('>', app_start)
        content = content[:closing_bracket + 1] + meta_data + content[closing_bracket + 1:]
        
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
        
        with open(gradle_path, 'w') as f:
            f.write(gradle_content)

    # 4. Patch build.gradle.kts to minSdkVersion 24 (Kotlin DSL)
    kts_path = 'android/app/build.gradle.kts'
    if os.path.exists(kts_path):
        with open(kts_path, 'r') as f:
            kts_content = f.read()
            
        kts_content = kts_content.replace('flutter.minSdkVersion', '24')
        
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
        
        with open(path, 'w') as f:
            f.write(content)

def fix_pub_cache_kotlin_plugins():
    # Flutter 3.44/Gradle now fails when Java and Kotlin tasks target different JVMs.
    # Patch Kotlin-based Android plugins in the pub cache so their Java/Kotlin targets match.
    home_dir = os.path.expanduser('~')
    pub_cache = os.environ.get('PUB_CACHE', os.path.join(home_dir, '.pub-cache'))
    search_pattern = os.path.join(pub_cache, 'hosted', 'pub.dev', '*', 'android', 'build.gradle')
    matches = glob.glob(search_pattern)

    for path in matches:
        with open(path, 'r') as f:
            content = f.read()

        patched = align_kotlin_jvm_target(content)
        if patched != content:
            print(f"Aligning Kotlin JVM target at {path}")
            with open(path, 'w') as f:
                f.write(patched)

if __name__ == '__main__':
    fix_ar_flutter_plugin()
    fix_pub_cache_kotlin_plugins()
    patch_android()
    patch_ios()
