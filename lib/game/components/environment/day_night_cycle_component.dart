import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class DayNightCycleComponent extends Component with HasGameRef {
  // Time constants
  static const double dayDuration = 1200.0; // 20 minutes for a full day
  static const double hourDuration = dayDuration / 24.0;
  
  // Time
  double currentTime = 6.0; // Start at 6 AM
  
  // Lighting
  Color currentLightColor = Colors.white;
  double currentLightIntensity = 1.0;
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Update time
    currentTime = (currentTime + dt / hourDuration) % 24.0;
    
    // Update lighting
    _updateLighting();
  }
  
  void _updateLighting() {
    // Calculate light intensity based on time of day
    if (currentTime >= 6.0 && currentTime < 8.0) {
      // Sunrise (6 AM - 8 AM)
      final progress = (currentTime - 6.0) / 2.0;
      currentLightIntensity = 0.7 + progress * 0.3;
      currentLightColor = _lerpColor(
        const Color(0xFFFF9E80), // Orange sunrise
        Colors.white, // Daylight
        progress,
      );
    } else if (currentTime >= 8.0 && currentTime < 18.0) {
      // Daytime (8 AM - 6 PM)
      currentLightIntensity = 1.0;
      currentLightColor = Colors.white;
    } else if (currentTime >= 18.0 && currentTime < 20.0) {
      // Sunset (6 PM - 8 PM)
      final progress = (currentTime - 18.0) / 2.0;
      currentLightIntensity = 1.0 - progress * 0.3;
      currentLightColor = _lerpColor(
        Colors.white, // Daylight
        const Color(0xFFFF9E80), // Orange sunset
        progress,
      );
    } else if (currentTime >= 20.0 && currentTime < 22.0) {
      // Dusk (8 PM - 10 PM)
      final progress = (currentTime - 20.0) / 2.0;
      currentLightIntensity = 0.7 - progress * 0.4;
      currentLightColor = _lerpColor(
        const Color(0xFFFF9E80), // Orange sunset
        const Color(0xFF3F51B5), // Night blue
        progress,
      );
    } else {
      // Night (10 PM - 6 AM)
      if (currentTime >= 22.0) {
        final progress = (currentTime - 22.0) / 8.0;
        currentLightIntensity = 0.3 - progress * 0.1;
      } else {
        final progress = (currentTime + 2.0) / 8.0;
        currentLightIntensity = 0.2 + progress * 0.5;
      }
      currentLightColor = const Color(0xFF3F51B5); // Night blue
    }
  }
  
  Color _lerpColor(Color a, Color b, double t) {
    return Color.lerp(a, b, t)!;
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Apply lighting overlay
    final paint = Paint()
      ..color = currentLightColor.withOpacity(1.0 - currentLightIntensity)
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(
      Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
      paint,
    );
  }
  
  // Get current time as string (HH:MM)
  String getCurrentTimeString() {
    final int hours = currentTime.floor();
    final int minutes = ((currentTime - hours) * 60).floor();
    
    final String hoursStr = hours.toString().padLeft(2, '0');
    final String minutesStr = minutes.toString().padLeft(2, '0');
    
    return '$hoursStr:$minutesStr';
  }
  
  // Get current time period (Morning, Afternoon, Evening, Night)
  String getCurrentTimePeriod() {
    if (currentTime >= 5.0 && currentTime < 12.0) {
      return 'Morning';
    } else if (currentTime >= 12.0 && currentTime < 17.0) {
      return 'Afternoon';
    } else if (currentTime >= 17.0 && currentTime < 21.0) {
      return 'Evening';
    } else {
      return 'Night';
    }
  }
}