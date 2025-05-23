import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/sprite.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:arabic_mmorpg/domain/entities/character_entity.dart';
import 'package:arabic_mmorpg/game/components/player/player_state.dart';
import 'package:arabic_mmorpg/game/components/ui/player_name_component.dart';
import 'package:arabic_mmorpg/game/components/ui/health_bar_component.dart';
import 'package:arabic_mmorpg/game/components/environment/day_night_cycle_component.dart';

class OtherPlayerComponent extends SpriteAnimationGroupComponent<PlayerState> 
    with HasGameRef, CollisionCallbacks {
  
  final CharacterEntity character;
  final String characterId;
  
  // Components
  late final PlayerNameComponent nameComponent;
  late final HealthBarComponent healthBarComponent;
  
  // Animation data
  late final Map<PlayerState, SpriteAnimation> animations;
  late final SpriteSheet spriteSheet;
  
  // State
  PlayerState currentState = PlayerState.idle;
  Direction direction = Direction.down;
  
  // Lighting
  Color currentLightColor = Colors.white;
  double currentLightIntensity = 1.0;
  
  OtherPlayerComponent({
    required this.character,
    required Vector2 position,
  }) : characterId = character.id,
       super(
         position: position,
         size: Vector2(64, 96), // Default size
         anchor: Anchor.center,
       );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Load sprite sheet
    final String characterClass = character.characterClass.toString().split('.').last;
    final String gender = character.gender.toString().split('.').last;
    final String spritePath = 'characters/$characterClass/$gender/spritesheet.png';
    
    // In a real implementation, you would load the actual sprite sheet
    // For now, we'll create a placeholder
    spriteSheet = SpriteSheet(
      image: await gameRef.images.load(spritePath),
      srcSize: Vector2(64, 96),
    );
    
    // Create animations
    animations = {
      PlayerState.idle: _createIdleAnimation(),
      PlayerState.walk: _createWalkAnimation(),
      PlayerState.attack: _createAttackAnimation(),
      PlayerState.skill: _createSkillAnimation(),
      PlayerState.hurt: _createHurtAnimation(),
      PlayerState.death: _createDeathAnimation(),
    };
    
    // Set initial animation
    current = PlayerState.idle;
    
    // Add collision hitbox
    add(RectangleHitbox(
      size: Vector2(32, 32),
      position: Vector2(16, 48), // Offset to center at feet
      isSolid: true,
    ));
    
    // Add name component
    nameComponent = PlayerNameComponent(
      name: character.name,
      position: Vector2(0, -60), // Above character
      anchor: Anchor.bottomCenter,
    );
    add(nameComponent);
    
    // Add health bar component
    healthBarComponent = HealthBarComponent(
      maxHealth: character.maxHealth,
      currentHealth: character.health,
      position: Vector2(0, -50), // Above name
      size: Vector2(60, 8),
      anchor: Anchor.bottomCenter,
    );
    add(healthBarComponent);
  }
  
  SpriteAnimation _createIdleAnimation() {
    // In a real implementation, you would create proper animations
    // For now, we'll create a placeholder
    return SpriteAnimation.spriteList(
      [spriteSheet.getSprite(0, 0)],
      stepTime: 1,
    );
  }
  
  SpriteAnimation _createWalkAnimation() {
    // In a real implementation, you would create proper animations
    // For now, we'll create a placeholder
    return SpriteAnimation.spriteList(
      [
        spriteSheet.getSprite(1, 0),
        spriteSheet.getSprite(1, 1),
        spriteSheet.getSprite(1, 2),
        spriteSheet.getSprite(1, 3),
      ],
      stepTime: 0.1,
    );
  }
  
  SpriteAnimation _createAttackAnimation() {
    // In a real implementation, you would create proper animations
    // For now, we'll create a placeholder
    return SpriteAnimation.spriteList(
      [
        spriteSheet.getSprite(2, 0),
        spriteSheet.getSprite(2, 1),
        spriteSheet.getSprite(2, 2),
        spriteSheet.getSprite(2, 3),
      ],
      stepTime: 0.1,
      loop: false,
    );
  }
  
  SpriteAnimation _createSkillAnimation() {
    // In a real implementation, you would create proper animations
    // For now, we'll create a placeholder
    return SpriteAnimation.spriteList(
      [
        spriteSheet.getSprite(3, 0),
        spriteSheet.getSprite(3, 1),
        spriteSheet.getSprite(3, 2),
        spriteSheet.getSprite(3, 3),
      ],
      stepTime: 0.1,
      loop: false,
    );
  }
  
  SpriteAnimation _createHurtAnimation() {
    // In a real implementation, you would create proper animations
    // For now, we'll create a placeholder
    return SpriteAnimation.spriteList(
      [
        spriteSheet.getSprite(4, 0),
        spriteSheet.getSprite(4, 1),
      ],
      stepTime: 0.1,
      loop: false,
    );
  }
  
  SpriteAnimation _createDeathAnimation() {
    // In a real implementation, you would create proper animations
    // For now, we'll create a placeholder
    return SpriteAnimation.spriteList(
      [
        spriteSheet.getSprite(5, 0),
        spriteSheet.getSprite(5, 1),
        spriteSheet.getSprite(5, 2),
        spriteSheet.getSprite(5, 3),
      ],
      stepTime: 0.2,
      loop: false,
    );
  }
  
  // Update character data
  void updateCharacter(CharacterEntity newCharacter) {
    // Update position
    position = Vector2(newCharacter.positionX, newCharacter.positionY);
    
    // Update health
    healthBarComponent.updateHealth(newCharacter.health);
    
    // Update state
    if (newCharacter.state != character.state) {
      switch (newCharacter.state) {
        case 'idle':
          current = PlayerState.idle;
          break;
        case 'walk':
          current = PlayerState.walk;
          break;
        case 'attack':
          current = PlayerState.attack;
          animation?.reset();
          break;
        case 'skill':
          current = PlayerState.skill;
          animation?.reset();
          break;
        case 'hurt':
          current = PlayerState.hurt;
          animation?.reset();
          break;
        case 'death':
          current = PlayerState.death;
          animation?.reset();
          break;
      }
    }
    
    // Update direction
    if (newCharacter.direction != character.direction) {
      switch (newCharacter.direction) {
        case 'up':
          direction = Direction.up;
          break;
        case 'down':
          direction = Direction.down;
          break;
        case 'left':
          direction = Direction.left;
          flipHorizontally = true;
          break;
        case 'right':
          direction = Direction.right;
          flipHorizontally = false;
          break;
      }
    }
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw player level
    final levelPaint = TextPaint(
      style: const TextStyle(
        color: Colors.yellow,
        fontSize: 12,
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
    
    levelPaint.render(
      canvas,
      'Lv. ${character.level}',
      Vector2(0, -70),
      anchor: Anchor.bottomCenter,
    );
    
    // Draw guild name if in a guild
    if (character.guildId != null && character.guildName != null) {
      final guildPaint = TextPaint(
        style: const TextStyle(
          color: Colors.green,
          fontSize: 12,
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
      
      guildPaint.render(
        canvas,
        '<${character.guildName}>',
        Vector2(0, -85),
        anchor: Anchor.bottomCenter,
      );
    }
  }
}