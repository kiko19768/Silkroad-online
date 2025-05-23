import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:arabic_mmorpg/domain/entities/monster_entity.dart';
import 'package:arabic_mmorpg/game/components/monster/monster_state.dart';
import 'package:arabic_mmorpg/game/components/ui/health_bar_component.dart';
import 'package:arabic_mmorpg/game/components/ui/player_name_component.dart';
import 'package:arabic_mmorpg/game/components/environment/day_night_cycle_component.dart';

class MonsterComponent extends SpriteAnimationGroupComponent<MonsterState> 
    with HasGameRef, CollisionCallbacks {
  
  final String monsterId;
  final String spawnId;
  final int respawnTime;
  
  // Monster data
  late final MonsterEntity monster;
  
  // Components
  late final PlayerNameComponent nameComponent;
  late final HealthBarComponent healthBarComponent;
  
  // Animation data
  late final Map<MonsterState, SpriteAnimation> animations;
  late final SpriteSheet spriteSheet;
  
  // State
  MonsterState currentState = MonsterState.idle;
  Vector2 initialPosition;
  Vector2 targetPosition = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  double moveSpeed = 0;
  bool isMoving = false;
  bool isAttacking = false;
  bool isDead = false;
  
  // Combat
  int health = 0;
  int maxHealth = 0;
  double attackCooldown = 0;
  double aggroRange = 0;
  double baseAggroRange = 0; // Original aggro range
  double chaseRange = 0;
  String? targetId;
  
  // Behavior
  String currentActivity = 'idle';
  bool isNocturnal = false;
  
  // Lighting
  Color currentLightColor = Colors.white;
  double currentLightIntensity = 1.0;
  
  // Respawn
  double respawnTimer = 0;
  
  MonsterComponent({
    required this.monsterId,
    required this.spawnId,
    required Vector2 position,
    required this.respawnTime,
  }) : initialPosition = position.clone(),
       super(
         position: position,
         size: Vector2(64, 96), // Default size
         anchor: Anchor.center,
       );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // In a real implementation, you would fetch monster data from a repository
    // For now, we'll create a placeholder monster
    monster = MonsterEntity(
      id: monsterId,
      name: 'Monster $monsterId',
      description: 'A placeholder monster',
      type: MonsterType.normal,
      behavior: MonsterBehavior.aggressive,
      level: 1,
      health: 100,
      mana: 50,
      minPhysicalAttack: 10,
      maxPhysicalAttack: 15,
      minMagicalAttack: 5,
      maxMagicalAttack: 10,
      physicalDefense: 5,
      magicalDefense: 5,
      accuracy: 80,
      evasion: 20,
      criticalRate: 5,
      criticalDamage: 150,
      moveSpeed: 50,
      attackSpeed: 1.0,
      aggroRange: 150,
      chaseRange: 200,
      experienceReward: 50,
      goldReward: 10,
      drops: [],
      skills: [],
      modelPath: 'monsters/placeholder.png',
      iconPath: 'icons/monsters/placeholder.png',
      additionalProperties: {},
    );
    
    // Set monster properties
    health = monster.health;
    maxHealth = monster.health;
    moveSpeed = monster.moveSpeed;
    aggroRange = monster.aggroRange;
    baseAggroRange = monster.aggroRange; // Store original value
    chaseRange = monster.chaseRange;
    
    // Determine if monster is nocturnal (50% chance for now)
    isNocturnal = monsterId.hashCode % 2 == 0;
    
    // Load sprite sheet
    spriteSheet = SpriteSheet(
      image: await gameRef.images.load(monster.modelPath),
      srcSize: Vector2(64, 96),
    );
    
    // Create animations
    animations = {
      MonsterState.idle: _createIdleAnimation(),
      MonsterState.walk: _createWalkAnimation(),
      MonsterState.attack: _createAttackAnimation(),
      MonsterState.hurt: _createHurtAnimation(),
      MonsterState.death: _createDeathAnimation(),
    };
    
    // Set initial animation
    current = MonsterState.idle;
    
    // Add collision hitbox
    add(CircleHitbox(
      radius: 32,
      isSolid: true,
    ));
    
    // Add name component
    nameComponent = PlayerNameComponent(
      name: monster.name,
      position: Vector2(0, -60), // Above monster
      anchor: Anchor.bottomCenter,
    );
    add(nameComponent);
    
    // Add health bar component
    healthBarComponent = HealthBarComponent(
      maxHealth: maxHealth,
      currentHealth: health,
      position: Vector2(0, -50), // Above name
      size: Vector2(60, 8),
      anchor: Anchor.bottomCenter,
    );
    add(healthBarComponent);
    
    // Add special effects for elite and boss monsters
    if (monster.type == MonsterType.elite) {
      add(
        ColorEffect(
          Colors.blue,
          const Offset(0.0, 0.3),
          EffectController(
            duration: 1.0,
            reverseDuration: 1.0,
            infinite: true,
          ),
        ),
      );
    } else if (monster.type == MonsterType.boss) {
      add(
        ColorEffect(
          Colors.red,
          const Offset(0.0, 0.3),
          EffectController(
            duration: 1.0,
            reverseDuration: 1.0,
            infinite: true,
          ),
        ),
      );
      
      // Bosses are larger
      scale = Vector2.all(1.5);
    }
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
  
  SpriteAnimation _createHurtAnimation() {
    // In a real implementation, you would create proper animations
    // For now, we'll create a placeholder
    return SpriteAnimation.spriteList(
      [
        spriteSheet.getSprite(3, 0),
        spriteSheet.getSprite(3, 1),
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
        spriteSheet.getSprite(4, 0),
        spriteSheet.getSprite(4, 1),
        spriteSheet.getSprite(4, 2),
        spriteSheet.getSprite(4, 3),
      ],
      stepTime: 0.2,
      loop: false,
    );
  }
  
  // Move to position
  void moveTo(Vector2 target) {
    if (isDead) return;
    
    targetPosition = target;
    isMoving = true;
    
    // Update state
    if (current != MonsterState.walk) {
      current = MonsterState.walk;
    }
    
    // Update flip based on direction
    flipHorizontally = target.x < position.x;
  }
  
  // Stop movement
  void stopMovement() {
    isMoving = false;
    velocity = Vector2.zero();
    
    // Update state if not in combat
    if (!isAttacking && current != MonsterState.idle) {
      current = MonsterState.idle;
    }
  }
  
  // Attack target
  void attack() {
    if (isDead || isAttacking) return;
    
    isAttacking = true;
    current = MonsterState.attack;
    
    // Reset animation
    animation?.reset();
    
    // Set cooldown
    attackCooldown = 1.0 / monster.attackSpeed;
  }
  
  // Take damage
  void takeDamage(int damage, String attackerId) {
    if (isDead) return;
    
    // Calculate actual damage (considering defense)
    final actualDamage = damage;
    
    // Update health
    health -= actualDamage;
    healthBarComponent.updateHealth(health);
    
    // Show damage number
    _showDamageNumber(actualDamage);
    
    // Set target if not already set
    if (targetId == null) {
      targetId = attackerId;
    }
    
    // Play hurt animation if not dead
    if (health > 0) {
      current = MonsterState.hurt;
      animation?.reset();
    } else {
      // Monster died
      die();
    }
  }
  
  // Die
  void die() {
    isDead = true;
    current = MonsterState.death;
    animation?.reset();
    
    // Remove collision
    removeAll(children.whereType<CircleHitbox>());
    
    // Add fade out effect
    add(OpacityEffect.fadeOut(
      EffectController(duration: 2.0),
      onComplete: () {
        // Start respawn timer
        respawnTimer = respawnTime.toDouble();
        
        // Hide monster
        opacity = 0;
      },
    ));
  }
  
  // Respawn
  void respawn() {
    // Reset position
    position = initialPosition.clone();
    
    // Reset health
    health = maxHealth;
    healthBarComponent.updateHealth(health);
    
    // Reset state
    isDead = false;
    isMoving = false;
    isAttacking = false;
    targetId = null;
    current = MonsterState.idle;
    
    // Add collision back
    add(CircleHitbox(
      radius: 32,
      isSolid: true,
    ));
    
    // Show monster
    opacity = 1;
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
    
    // If dead and respawn timer is active
    if (isDead && respawnTimer > 0) {
      respawnTimer -= dt;
      
      if (respawnTimer <= 0) {
        respawn();
      }
      
      return;
    }
    
    // If dead, don't update
    if (isDead) return;
    
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
        current = MonsterState.idle;
      } else {
        current = MonsterState.walk;
      }
    }
    
    // AI behavior
    _updateAI(dt);
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
  
  void _updateAI(double dt) {
    // If has target, chase and attack
    if (targetId != null) {
      // In a real implementation, you would get the target position from the game world
      // For now, we'll just return to idle after a while
      if (attackCooldown <= 0 && !isAttacking) {
        attack();
      }
    } else {
      // No target, return to initial position if far away
      final distanceToInitial = position.distanceTo(initialPosition);
      if (distanceToInitial > 10) {
        moveTo(initialPosition);
      } else if (isMoving) {
        stopMovement();
      }
    }
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw monster level
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
      'Lv. ${monster.level}',
      Vector2(0, -70),
      anchor: Anchor.bottomCenter,
    );
    
    // Draw nocturnal indicator if in debug mode
    if (gameRef.isDebugMode && isNocturnal) {
      final nocturnalPaint = TextPaint(
        style: const TextStyle(
          color: Colors.purple,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      );
      
      nocturnalPaint.render(
        canvas,
        'Nocturnal',
        Vector2(0, -85),
        anchor: Anchor.bottomCenter,
      );
    }
  }
  
  // Set monster activity
  void setActivity(String activity) {
    if (currentActivity == activity) return;
    
    currentActivity = activity;
    
    // Update behavior based on activity
    switch (activity) {
      case 'idle':
        // Default idle behavior
        if (current != MonsterState.idle && !isAttacking && !isMoving) {
          current = MonsterState.idle;
        }
        break;
      case 'hunting':
        // Increase aggression
        moveSpeed = monster.moveSpeed * 1.2; // 20% faster
        break;
      case 'feeding':
        // Temporarily stop movement
        if (isMoving) {
          stopMovement();
        }
        break;
      case 'sleeping':
        // Reduce aggression
        if (isMoving && targetId == null) {
          stopMovement();
        }
        moveSpeed = monster.moveSpeed * 0.8; // 20% slower
        break;
      case 'waking_up':
        // Transition state
        moveSpeed = monster.moveSpeed;
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
        // Nocturnal monsters glow at night
        if (isNocturnal) {
          currentLightColor = const Color(0xFF9C27B0); // Purple
          currentLightIntensity = 1.2; // Brighter
        } else {
          currentLightColor = const Color(0xFF3F51B5); // Deep blue
          currentLightIntensity = 0.3;
        }
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
  
  // Increase aggro range by multiplier
  void increaseAggroRange(double multiplier) {
    aggroRange = baseAggroRange * multiplier;
  }
  
  // Decrease aggro range by multiplier
  void decreaseAggroRange(double multiplier) {
    aggroRange = baseAggroRange * multiplier;
  }
}