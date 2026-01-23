# Phase 8: Android Build Preparation Plan

## Phase 8 Requirements (from roadmap)

**Phase 8: Android/Retroid Build and Testing**
- Set up Android export build pipeline
- Configure Android export presets and settings
- Build and test APK on target Android devices (including Retroid Pocket devices)
- Verify touch controls and gamepad support
- Optimize performance for mobile devices
- Address any platform-specific issues

**Android Build Setup Tasks:**
1. Install Android SDK (version specified in `project.godot`)
2. Install OpenJDK (required for Android builds)
3. Download Android export templates for Godot 4.5.1
4. Configure export presets:
   - Set package name (com.yourname.circesgarden)
   - Configure screen orientation: Landscape (for Retroid)
   - Set minimum SDK version: 24 (Android 7.0) or higher
   - Enable USB debugging permissions
   - Configure app icon in export preset
5. Test build and deployment to Android devices

## Current Android Configuration Status

- Export presets configured? **YES**
  - Android Debug preset configured
  - Android Release preset configured
  - Export paths: exports/circes_garden_debug.apk and exports/circes_garden_release.apk

- Android SDK installed? **UNKNOWN**
  - Check required via setup script (tools/setup_android_build.cmd)
  - Need to verify Android SDK command-line tools and platform-tools

- Keystore setup? **NO**
  - No keystore configuration found in export presets
  - Debug builds can use Godot's debug keystore
  - Release builds will need production keystore

- Screen orientation? **PARTIALLY CONFIGURED**
  - Landscape orientation enabled
  - Immersive mode enabled
  - Sensor landscape disabled
  - All other orientations disabled

- Input mappings for touch? **MISSING**
  - No touch input events defined
  - Current input mappings are keyboard and gamepad only
  - Need to add virtual D-pad and button layouts

## Prerequisites Checklist

### Environment Setup
- [ ] Install OpenJDK 17 (Java 17)
  - Verify: `java -version` should show 1.8.x
  - Install via: `winget install Microsoft.OpenJDK.17`
  - Or download from: https://aka.ms/download-jdk/microsoft-jdk-17

- [ ] Install Android SDK
  - Install via: `winget install Google.AndroidSDK`
  - Or download Android Studio from: https://developer.android.com/studio
  - Minimum SDK version: 24 (Android 7.0)
  - Target SDK version: 34 (Android 14)

- [ ] Set environment variables
  - JAVA_HOME = "C:\Program Files\Microsoft\jdk\jdk-17.0.17.10-hotspot"
  - ANDROID_HOME = "C:\Users\%USERNAME%\AppData\Local\Android\Sdk"
  - Add to PATH: %JAVA_HOME%\bin
  - Add to PATH: %ANDROID_HOME%\cmdline-tools\latest\bin
  - Add to PATH: %ANDROID_HOME%\platform-tools

- [ ] Install Godot Android Export Templates
  - Open Godot 4.5.1
  - Go to Editor → Manage Export Templates → Download and Install v4.5.1
  - Or download from: https://github.com/godotengine/godot/releases/download/4.5.1-stable/Godot_v4.5.1-stable_export_templates.tpz

### Export Configuration
- [ ] Configure Android export presets
  - [ ] Add keystore for release builds
  - [ ] Verify app icon (icon.svg - 512x512, present)
  - [ ] Configure VRAM texture compression for mobile
  - [ ] Enable hardware acceleration
  - [ ] Set correct screen orientation (landscape)

- [ ] Configure input mappings for mobile
  - [ ] Add touch events for directional movement
  - [ ] Add touch events for action buttons (interact, inventory)
  - [ ] Configure virtual D-pad area
  - [ ] Add touch button for menu/navigation
  - [ ] Test multi-touch support

- [ ] Optimize build settings
  - [ ] Configure VRAM texture compression for mobile devices
  - [ ] Enable progressive web app settings if needed
  - [ ] Test export filter settings
  - [ ] Configure splash screen for mobile

### Performance Optimization
- [ ] Profile and optimize game performance
  - [ ] Reduce draw calls
  - [ ] Optimize particle effects
  - [ ] Compress textures appropriately
  - [ ] Test on lower-end Android devices
  - [ ] Implement frame rate limiting if needed

- [ ] Test on various screen sizes
  - [ ] Small screens (480p-720p)
  - [ ] Medium screens (720p-1080p)
  - [ ] Large screens (1080p+)
  - [ ] Retina/HD displays

### Content Validation
- [ ] Test game features on Android
  - [ ] Verify all gameplay mechanics work with touch
  - [ ] Test save/load functionality
  - [ ] Verify audio plays correctly
  - [ ] Test cutscenes and dialogue
  - [ ] Validate quest progression
  - [ ] Test inventory and UI interactions

## Known Android-Specific Issues

### Performance Concerns
- No known Android-specific issues identified yet
- Will need to test on actual Android devices
- Consider reducing particle effects for mobile devices
- May need to reduce texture sizes for lower-end devices

### Input Handling
- Current input mappings lack touch support
- Need to implement virtual D-pad and touch buttons
- Gamepad support should work via Android's gamepad APIs
- May need to handle multi-touch properly

### Memory Management
- VRAM texture compression settings need optimization
- Large scenes may need to be split for mobile
- Asset loading may need to be optimized

### Testing Challenges
- Need physical Android devices for thorough testing
- Emulator testing may not reflect real-world performance
- Different Android versions and screen sizes need testing

## Build Verification Steps

### Pre-Build Checks
1. Verify Java installation: `java -version`
2. Verify Android SDK: `sdkmanager --version`
3. Check Android devices connected: `adb devices`
4. Verify Godot Android templates installed

### Build Process
1. Open Godot project
2. Go to Export → Android Debug/Release preset
3. Click Export button
4. Wait for build completion (may take 5-10 minutes)
5. Verify APK generated in exports/ directory

### Post-Build Testing
1. Install APK on Android device/emulator
2. Launch app and verify it starts
3. Test main menu functionality
4. Test movement controls
5. Test interaction system
6. Test save/load system
7. Test audio playback
8. Test performance (FPS, memory usage)

### Release Build Verification
1. Configure keystore for release builds
2. Build release APK
3. Verify APK size is reasonable (< 100MB preferred)
4. Test on target devices
5. Consider Google Play Store requirements

## Platform-Specific Considerations

### Touch Controls
- Implement virtual D-pad for movement
- Add action buttons for interact and inventory
- Support swipe gestures for menus
- Ensure touch targets are large enough
- Support optional on-screen controls toggle

### Screen Sizes and Aspect Ratios
- Fixed 1280x720 viewport (current configuration)
- Handles different screen sizes via viewport stretch
- Landscape orientation enforced
- May need letterboxing on non-16:9 screens

### Performance Considerations
- Reduce particle effects for mobile
- Optimize texture sizes for mobile VRAM
- Consider reducing draw calls
- Implement object pooling for frequently created/destroyed objects
- Use compressed texture formats (ETC2/ASTC)

### Android-Specific Features
- Immersive mode enabled for full-screen experience
- Keep screen on enabled for gaming
- Touchscreen hardware feature declared
- Internet permission declared (for future updates/features)

### Retroid Pocket Specific
- Landscape orientation required
- Gamepad support via Android gamepad APIs
- May need specific button mapping for Retroid layout
- Performance optimization for low-end devices

### Battery Optimization
- Don't keep activities should be disabled
- Optimized for longer gaming sessions
- Consider battery usage optimizations

## Next Steps
1. Run Android environment setup script (admin required)
2. Verify Java and Android SDK installations
3. Download Godot Android export templates
4. Implement touch controls
5. Test build on Android device
6. Optimize performance for mobile
7. Create release build with keystore