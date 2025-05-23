import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:arabic_mmorpg/domain/entities/character_entity.dart';
import 'package:arabic_mmorpg/domain/entities/skill_entity.dart';
import 'package:arabic_mmorpg/game/components/player/player_state.dart';
import 'package:arabic_mmorpg/game/components/effects/skill_effect_component.dart';
import 'package:arabic_mmorpg/game/components/ui/player_name_component.dart';
import 'package:arabic_mmorpg/game/components/ui/health_bar_component.dart';
import 'package:arabic_mmorpg/game/components/ui/mana_bar_component.dart';

class PlayerComponent extends SpriteAnimationGroupComponent<PlayerState> 
    with HasGameRef, CollisionCallbacks {
  
  // Character data
  final CharacterEntity character;
  
  // Components
  late final PlayerNameComponent nameComponent;
  late final HealthBarComponent healthBarComponent;
  late final ManaBarComponent manaBarComponent;
  
  // Animation data
  late final Map<PlayerState, SpriteAnimation> animations;
  late final SpriteSheet spriteSheet;
  
  // Movement
  Vector2 targetPosition = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  double moveSpeed = 0;
  bool isMoving = false;
  
  // Combat
  bool isAttacking = false;
  bool isUsingSkill = false;
  SkillEntity? currentSkill;
  double attackCooldown = 0;
  
  // State
  PlayerState currentState = PlayerState.idle;
  Direction direction = Direction.down;
  
  // Debug mode
  bool isDebugMode = false;
  
  // Constructor
  PlayerComponent({
    required this.character,
    required Vector2 position,
  }) : super(
    position: position,
    size: Vector2(64, 96), // Default size
    anchor: Anchor.center,
  );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Set move speed from character
    moveSpeed = character.moveSpeed;
    
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
    
    // Add mana bar component
    manaBarComponent = ManaBarComponent(
      maxMana: character.maxMana,
      currentMana: character.mana,
      position: Vector2(0, -45), // Above health bar
      size: Vector2(60, 6),
      anchor: Anchor.bottomCenter,
    );
    add(manaBarComponent);
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
  
  // Move to position
  void moveTo(Vector2 target) {
    targetPosition = target;
    isMoving = true;
    
    // Calculate direction
    final Vector2 direction = target - position;
    
    // Update facing direction
    if (direction.x.abs() > direction.y.abs()) {
      // Horizontal movement is dominant
      this.direction = direction.x > 0 ? Direction.right : Direction.left;
    } else {
      // Vertical movement is dominant
      this.direction = direction.y > 0 ? Direction.down : Direction.up;
    }
    
    // Update flip based on direction
    flipHorizontally = this.direction == Direction.left;
    
    // Update state
    if (current != PlayerState.walk) {
      current = PlayerState.walk;
    }
  }
  
  // Stop movement
  void stopMovement() {
    isMoving = false;
    velocity = Vector2.zero();
    
    // Update state if not in combat
    if (!isAttacking && !isUsingSkill && current != PlayerState.idle) {
      current = PlayerState.idle;
    }
  }
  
  // Perform basic attack
  void attack() {
    if (isAttacking || isUsingSkill) return;
    
    isAttacking = true;
    current = PlayerState.attack;
    
    // Reset animation
    animation?.reset();
    
    // Set cooldown
    attackCooldown = 1.0 / character.attackSpeed;
  }
  
  // Use skill
  void useSkill(SkillEntity skill) {
    if (isAttacking || isUsingSkill) return;
    
    // Check if enough mana
    if (character.mana < skill.manaCost) return;
    
    isUsingSkill = true;
    currentSkill = skill;
    current = PlayerState.skill;
    
    // Reset animation
    animation?.reset();
    
    // Create skill effect
    final skillEffect = SkillEffectComponent(
      skill: skill,
      position: Vector2(0, 0), // Relative to player
      size: Vector2(128, 128),
    );
    add(skillEffect);
    
    // Consume mana
    updateMana(character.mana - skill.manaCost);
  }
  
  // Take damage
  void takeDamage(int damage) {
    // Calculate actual damage (considering defense)
    final actualDamage = damage;
    
    // Update health
    updateHealth(character.health - actualDamage);
    
    // Show damage number
    _showDamageNumber(actualDamage);
    
    // Play hurt animation if not dead
    if (character.health > 0) {
      current = PlayerState.hurt;
      animation?.reset();
    } else {
      // Player died
      die();
    }
  }
  
  // Die
  void die() {
    current = PlayerState.death;
    animation?.reset();
    
    // Add fade out effect
    add(OpacityEffect.fadeOut(
      EffectController(duration: 2.0),
    ));
  }
  
  // Update health
  void updateHealth(int newHealth) {
    final clampedHealth = newHealth.clamp(0, character.maxHealth);
    healthBarComponent.updateHealth(clampedHealth);
  }
  
  // Update mana
  void updateMana(int newMana) {
    final clampedMana = newMana.clamp(0, character.maxMana);
    manaBarComponent.updateMana(clampedMana);
  }
  
  // Show damage number
  void _showDamageNumber(int damage) {
    final textComponent = TextComponent(
      text: damage.toString(),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.red,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(0, -40),
      anchor: Anchor.center,
    );
    
    // Add effects
    textComponent.add(MoveByEffect(
      Vector2(0, -30),
      EffectController(duration: 1.0),
    ));
    
    textComponent.add(OpacityEffect.fadeOut(
      EffectController(duration: 1.0),
      onComplete: () => remove(textComponent),
    ));
    
    add(textComponent);
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Update movement
    if (isMoving) {
      _updateMovement(dt);
    }
    
    // Update attack cooldown
    if (attackCooldown > 0) {
      attackCooldown -= dt;
    }
    
    // Check if attack animation finished
    if (isAttacking && animation?.done() == true) {
      isAttacking = false;
      
      // Return to idle if not moving
      if (!isMoving) {
        current = PlayerState.idle;
      } else {
        current = PlayerState.walk;
      }
    }
    
    // Check if skill animation finished
    if (isUsingSkill && animation?.done() == true) {
      isUsingSkill = false;
      currentSkill = null;
      
      // Return to idle if not moving
      if (!isMoving) {
        current = PlayerState.idle;
      } else {
        current = PlayerState.walk;
      }
    }
  }
  
  void _updateMovement(double dt) {
    // Calculate direction to target
    final Vector2 direction = targetPosition - position;
    
    // Check if close enough to target
    if (direction.length < 5) {
      stopMovement();
      return;
    }
    
    // Normalize direction and apply speed
    direction.normalize();
    velocity = direction * moveSpeed;
    
    // Update position
    position += velocity * dt;
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Render debug information if enabled
    if (isDebugMode) {
      _renderDebugInfo(canvas);
    }
  }
  
  void _renderDebugInfo(Canvas canvas) {
    // Draw target position
    if (isMoving) {
      final paint = Paint()
        ..color = const Color(0xFFFF0000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      
      canvas.drawCircle(
        Offset(targetPosition.x, targetPosition.y),
        10,
        paint,
      );
      
      // Draw line to target
      canvas.drawLine(
        Offset(position.x, position.y),
        Offset(targetPosition.x, targetPosition.y),
        paint,
      );
    }
    
    // Draw hitbox
    final hitboxPaint = Paint()
      ..color = const Color(0x4400FF00)
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(
      Rect.fromLTWH(
        position.x - size.x / 2 + 16,
        position.y - size.y / 2 + 48,
        32,
        32,
      ),
      hitboxPaint,
    );
    
    // Draw character info
    final textPaint = TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        backgroundColor: Color(0x88000000),
      ),
    );
    
    textPaint.render(
      canvas,
      'HP: ${character.health}/${character.maxHealth}',
      Vector2(position.x, position.y - 70),
      anchor: Anchor.bottomCenter,
    );
    
    textPaint.render(
      canvas,
      'MP: ${character.mana}/${character.maxMana}',
      Vector2(position.x, position.y - 85),
      anchor: Anchor.bottomCenter,
    );
    
    textPaint.render(
      canvas,
      'State: $currentState',
      Vector2(position.x, position.y - 100),
      anchor: Anchor.bottomCenter,
    );
  }
}