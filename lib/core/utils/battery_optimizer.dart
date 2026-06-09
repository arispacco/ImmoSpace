import 'package:flutter/services.dart';

class BatteryOptimizer {
  static final BatteryOptimizer _instance = BatteryOptimizer._internal();
  factory BatteryOptimizer() => _instance;
  BatteryOptimizer._internal();

  static const MethodChannel _channel = MethodChannel('com.immospace.app/battery');

  bool _manualLowPowerMode = false;

  /// Manually override or set low power mode (useful for user toggles)
  void setManualLowPowerMode(bool enabled) {
    _manualLowPowerMode = enabled;
  }

  /// Checks if the device is currently in a low power state.
  /// First queries the native platform via channel; falls back to manual toggles
  /// if not supported or running on simulator/desktop.
  Future<bool> isLowPowerModeActive() async {
    if (_manualLowPowerMode) return true;
    
    try {
      final bool? isLowPower = await _channel.invokeMethod<bool>('isLowPowerMode');
      return isLowPower ?? false;
    } catch (_) {
      // Fallback if platform channels are not registered yet
      return _manualLowPowerMode;
    }
  }

  /// Returns battery level percentage (0 to 100).
  Future<int> getBatteryLevel() async {
    try {
      final int? level = await _channel.invokeMethod<int>('getBatteryLevel');
      return level ?? 100;
    } catch (_) {
      return 100; // Mock full battery if channel fails
    }
  }

  /// Policy helper: suggests whether to disable intensive glassmorphic blur
  /// or disable real-time rendering calculations in AR/VR views.
  Future<bool> shouldReduceEffects() async {
    final isLowPower = await isLowPowerModeActive();
    final batteryLvl = await getBatteryLevel();
    return isLowPower || batteryLvl < 25;
  }
}
