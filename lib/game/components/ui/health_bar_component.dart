import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class HealthBarComponent extends PositionComponent {
  final int maxHealth;
  int currentHealth;
  
  HealthBarComponent({
    required this.maxHealth,
    required this.currentHealth,
    required Vector2 position,
    required Vector2 size,
    required Anchor anchor,
  }) : super(
    position: position,
    size: size,
    anchor: anchor,
  );
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw background
    final backgroundPaint = Paint()
      ..color = const Color(0xFF333333)
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      backgroundPaint,
    );
    
    // Draw border
    final borderPaint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      borderPaint,
    );
    
    // Draw health
    final healthPaint = Paint()
      ..color = const Color(0xFFFF0000)
      ..style = PaintingStyle.fill;
    
    final healthWidth = (currentHealth / maxHealth) * size.x;
    
    canvas.drawRect(
      Rect.fromLTWH(0, 0, healthWidth, size.y),
      healthPaint,
    );
  }
  
  void updateHealth(int newHealth) {
    currentHealth = newHealth;
  }
}