import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PlayerNameComponent extends TextComponent {
  final String name;
  
  PlayerNameComponent({
    required this.name,
    required Vector2 position,
    required Anchor anchor,
  }) : super(
    text: name,
    textRenderer: TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            color: Colors.black,
            offset: Offset(1, 1),
            blurRadius: 2,
          ),
        ],
      ),
    ),
    position: position,
    anchor: anchor,
  );
}