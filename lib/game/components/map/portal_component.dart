import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:arabic_mmorpg/domain/entities/map_entity.dart';

class PortalComponent extends SpriteAnimationComponent with CollisionCallbacks {
  final MapPortal portal;
  final double radius;
  
  PortalComponent({
    required this.portal,
    required Vector2 position,
  }) : radius = portal.radius,
       super(
         position: position,
         size: Vector2.all(portal.radius * 2),
         anchor: Anchor.center,
       );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Load portal animation
    final spriteSheet = SpriteSheet(
      image: await game.images.load('maps/portals/portal_spritesheet.png'),
      srcSize: Vector2(64, 64),
    );
    
    // Create animation
    animation = SpriteAnimation.spriteList(
      [
        spriteSheet.getSprite(0, 0),
        spriteSheet.getSprite(0, 1),
        spriteSheet.getSprite(0, 2),
        spriteSheet.getSprite(0, 3),
        spriteSheet.getSprite(1, 0),
        spriteSheet.getSprite(1, 1),
        spriteSheet.getSprite(1, 2),
        spriteSheet.getSprite(1, 3),
      ],
      stepTime: 0.1,
      loop: true,
    );
    
    // Add circular hitbox
    add(CircleHitbox(
      radius: radius,
      isSolid: false,
    ));
    
    // Add effects
    add(
      RotateEffect.by(
        2 * 3.14159, // Full rotation
        EffectController(
          duration: 10,
          infinite: true,
        ),
      ),
    );
    
    // Add pulsating effect
    add(
      ScaleEffect.by(
        Vector2.all(1.2),
        EffectController(
          duration: 1.0,
          reverseDuration: 1.0,
          infinite: true,
        ),
      ),
    );
    
    // Add glow effect if portal is active
    if (portal.isActive) {
      add(
        ColorEffect(
          Colors.blue,
          const Offset(0.0, 0.5),
          EffectController(
            duration: 1.0,
            reverseDuration: 1.0,
            infinite: true,
          ),
        ),
      );
    } else {
      // Inactive portal has reduced opacity
      opacity = 0.5;
    }
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw portal name
    final textPaint = TextPaint(
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
    );
    
    textPaint.render(
      canvas,
      portal.name,
      Vector2(0, -radius - 10),
      anchor: Anchor.bottomCenter,
    );
  }
}