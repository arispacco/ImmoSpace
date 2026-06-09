import os

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
        
    # 3. Patch build.gradle to minSdkVersion 24
    gradle_path = 'android/app/build.gradle'
    if os.path.exists(gradle_path):
        with open(gradle_path, 'r') as f:
            gradle_content = f.read()
        
        # Replace default flutter.minSdkVersion with 24
        gradle_content = gradle_content.replace('flutter.minSdkVersion', '24')
        gradle_content = gradle_content.replace('minSdkVersion 16', 'minSdkVersion 24')
        gradle_content = gradle_content.replace('minSdkVersion 19', 'minSdkVersion 24')
        gradle_content = gradle_content.replace('minSdkVersion 20', 'minSdkVersion 24')
        gradle_content = gradle_content.replace('minSdkVersion 21', 'minSdkVersion 24')
        
        with open(gradle_path, 'w') as f:
            f.write(gradle_content)
            
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

if __name__ == '__main__':
    patch_android()
    patch_ios()
