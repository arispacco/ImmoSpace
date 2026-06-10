import os
import glob

def patch_android():
    manifest_path = 'android/app/src/main/AndroidManifest.xml'
    if not os.path.exists(manifest_path):
        print(f"Error: {manifest_path} not found")
        return
    
    with open(manifest_path, 'r') as f:
        content = f.read()
    
    # 1. Add permissions inside <manifest>
    permissions = """
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-feature android:name="android.hardware.camera.ar" android:required="true" />
"""
    if 'android.permission.CAMERA' not in content:
        content = content.replace('<application', permissions + '    <application')
    
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
        
        with open(path, 'w') as f:
            f.write(content)

if __name__ == '__main__':
    fix_ar_flutter_plugin()
    patch_android()
    patch_ios()
