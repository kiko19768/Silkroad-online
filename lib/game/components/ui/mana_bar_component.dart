import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ManaBarComponent extends PositionComponent {
  final int maxMana;
  int currentMana;
  
  ManaBarComponent({
    required this.maxMana,
    required this.currentMana,
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
    
    // Draw mana
    final manaPaint = Paint()
      ..color = const Color(0xFF0000FF)
      ..style = PaintingStyle.fill;
    
    final manaWidth = (currentMana / maxMana) * size.x;
    
    canvas.drawRect(
      Rect.fromLTWH(0, 0, manaWidth, size.y),
      manaPaint,
    );
  }
  
  void updateMana(int newMana) {
    currentMana = newMana;
  }
}