import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:arabic_mmorpg/domain/entities/map_entity.dart';
import 'package:arabic_mmorpg/game/components/environment/day_night_cycle_component.dart';

class NPCComponent extends SpriteAnimationComponent with CollisionCallbacks {
  final MapNPC npc;
  final double rotation;
  
  // Interaction
  bool isInteracting = false;
  
  // Current activity
  String currentActivity = 'idle';
  
  // Lighting
  Color currentLightColor = Colors.white;
  double currentLightIntensity = 1.0;
  
  NPCComponent({
    required this.npc,
    required Vector2 position,
    required this.rotation,
  }) : super(
    position: position,
    size: Vector2(64, 96), // Default size
    anchor: Anchor.center,
  );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Load NPC sprite sheet
    final spriteSheet = SpriteSheet(
      image: await game.images.load(npc.modelPath),
      srcSize: Vector2(64, 96),
    );
    
    // Create idle animation
    animation = SpriteAnimation.spriteList(
      [
        spriteSheet.getSprite(0, 0),
        spriteSheet.getSprite(0, 1),
        spriteSheet.getSprite(0, 2),
        spriteSheet.getSprite(0, 3),
      ],
      stepTime: 0.2,
      loop: true,
    );
    
    // Set rotation
    angle = rotation;
    
    // Add collision hitbox
    add(CircleHitbox(
      radius: 32,
      isSolid: false,
    ));
    
    // Add floating effect for quest NPCs
    if (npc.questIds != null && npc.questIds!.isNotEmpty) {
      add(
        MoveByEffect(
          Vector2(0, -5),
          EffectController(
            duration: 1.0,
            reverseDuration: 1.0,
            infinite: true,
          ),
        ),
      );
    }
    
    // Add glow effect for shop NPCs
    if (npc.shopIds != null && npc.shopIds!.isNotEmpty) {
      add(
        ColorEffect(
          Colors.yellow,
          const Offset(0.0, 0.3),
          EffectController(
            duration: 1.0,
            reverseDuration: 1.0,
            infinite: true,
          ),
        ),
      );
    }
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw NPC name
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
      npc.name,
      Vector2(0, -60),
      anchor: Anchor.bottomCenter,
    );
    
    // Draw NPC type
    final typePaint = TextPaint(
      style: TextStyle(
        color: _getNPCTypeColor(),
        fontSize: 12,
        fontWeight: FontWeight.bold,
        shadows: const [
          Shadow(
            color: Colors.black,
            offset: Offset(1, 1),
            blurRadius: 2,
          ),
        ],
      ),
    );
    
    typePaint.render(
      canvas,
      npc.type,
      Vector2(0, -45),
      anchor: Anchor.bottomCenter,
    );
    
    // Draw interaction indicator if interactable
    if (npc.isInteractable) {
      final indicatorPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      
      canvas.drawCircle(
        Offset(0, -80),
        10,
        indicatorPaint,
      );
      
      // Draw exclamation mark for quest NPCs
      if (npc.questIds != null && npc.questIds!.isNotEmpty) {
        final questPaint = TextPaint(
          style: const TextStyle(
            color: Colors.yellow,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        );
        
        questPaint.render(
          canvas,
          '!',
          Vector2(0, -80),
          anchor: Anchor.center,
        );
      }
      
      // Draw shop icon for shop NPCs
      if (npc.shopIds != null && npc.shopIds!.isNotEmpty) {
        final shopPaint = TextPaint(
          style: const TextStyle(
            color: Colors.green,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        );
        
        shopPaint.render(
          canvas,
          '\$',
          Vector2(0, -80),
          anchor: Anchor.center,
        );
      }
    }
  }
  
  Color _getNPCTypeColor() {
    switch (npc.type) {
      case 'Merchant':
        return Colors.green;
      case 'Quest':
        return Colors.yellow;
      case 'Trainer':
        return Colors.blue;
      case 'Guard':
        return Colors.red;
      default:
        return Colors.white;
    }
  }
  
  // Start interaction
  void startInteraction() {
    if (!npc.isInteractable) return;
    
    isInteracting = true;
    
    // Add highlight effect
    add(
      ColorEffect(
        Colors.white,
        const Offset(0.0, 0.5),
        EffectController(
          duration: 0.3,
        ),
      ),
    );
  }
  
  // End interaction
  void endInteraction() {
    isInteracting = false;
  }
  
  // Set NPC activity
  void setActivity(String activity) {
    if (currentActivity == activity) return;
    
    currentActivity = activity;
    
    // Update animation based on activity
    switch (activity) {
      case 'idle':
        // Default idle animation already set
        break;
      case 'working':
        // Load working animation if available
        game.images.load('${npc.modelPath}_working').then((image) {
          final spriteSheet = SpriteSheet(
            image: image,
            srcSize: Vector2(64, 96),
          );
          
          animation = SpriteAnimation.spriteList(
            [
              spriteSheet.getSprite(0, 0),
              spriteSheet.getSprite(0, 1),
              spriteSheet.getSprite(0, 2),
              spriteSheet.getSprite(0, 3),
            ],
            stepTime: 0.2,
            loop: true,
          );
        }).catchError((_) {
          // If working animation not available, use default
        });
        break;
      case 'sleeping':
        // Load sleeping animation if available
        game.images.load('${npc.modelPath}_sleeping').then((image) {
          final spriteSheet = SpriteSheet(
            image: image,
            srcSize: Vector2(64, 96),
          );
          
          animation = SpriteAnimation.spriteList(
            [
              spriteSheet.getSprite(0, 0),
              spriteSheet.getSprite(0, 1),
            ],
            stepTime: 0.5,
            loop: true,
          );
        }).catchError((_) {
          // If sleeping animation not available, use default
        });
        break;
      case 'waking_up':
        // Load waking up animation if available
        game.images.load('${npc.modelPath}_waking').then((image) {
          final spriteSheet = SpriteSheet(
            image: image,
            srcSize: Vector2(64, 96),
          );
          
          animation = SpriteAnimation.spriteList(
            [
              spriteSheet.getSprite(0, 0),
              spriteSheet.getSprite(0, 1),
              spriteSheet.getSprite(0, 2),
              spriteSheet.getSprite(0, 3),
            ],
            stepTime: 0.2,
            loop: false,
          );
        }).catchError((_) {
          // If waking animation not available, use default
        });
        break;
      case 'closing_shop':
        // Load closing shop animation if available
        game.images.load('${npc.modelPath}_closing').then((image) {
          final spriteSheet = SpriteSheet(
            image: image,
            srcSize: Vector2(64, 96),
          );
          
          animation = SpriteAnimation.spriteList(
            [
              spriteSheet.getSprite(0, 0),
              spriteSheet.getSprite(0, 1),
              spriteSheet.getSprite(0, 2),
              spriteSheet.getSprite(0, 3),
            ],
            stepTime: 0.2,
            loop: false,
          );
        }).catchError((_) {
          // If closing animation not available, use default
        });
        break;
    }
  }
  
  // Update lighting based on time of day
  void updateLighting(TimeOfDay timeOfDay) {
    switch (timeOfDay) {
      case TimeOfDay.dawn:
        currentLightColor = const Color(0xFFE6B89C); // Soft orange-pink
        currentLightIntensity = 0.7;
        break;
      case TimeOfDay.morning:
      case TimeOfDay.noon:
      case TimeOfDay.afternoon:
        currentLightColor = Colors.white; // Pure white
        currentLightIntensity = 1.0;
        break;
      case TimeOfDay.dusk:
        currentLightColor = const Color(0xFFE6B89C); // Soft orange-pink
        currentLightIntensity = 0.7;
        break;
      case TimeOfDay.evening:
        currentLightColor = const Color(0xFF7986CB); // Indigo blue
        currentLightIntensity = 0.5;
        break;
      case TimeOfDay.night:
      case TimeOfDay.midnight:
        currentLightColor = const Color(0xFF3F51B5); // Deep blue
        currentLightIntensity = 0.3;
        break;
    }
    
    // Apply lighting effect
    add(
      ColorEffect(
        currentLightColor,
        const Offset(0.0, 0.2),
        EffectController(
          duration: 1.0,
        ),
      ),
    );
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Update NPC behavior based on activity
    switch (currentActivity) {
      case 'idle':
        // Default idle behavior
        break;
      case 'working':
        // Working behavior
        break;
      case 'sleeping':
        // Sleeping behavior
        break;
      case 'waking_up':
        // Waking up behavior
        break;
      case 'closing_shop':
        // Closing shop behavior
        break;
    }
  }
}