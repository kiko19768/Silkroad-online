import 'dart:math';
import 'package:flame/components.dart';
import 'package:arabic_mmorpg/domain/entities/character_entity.dart';
import 'package:arabic_mmorpg/domain/entities/skill_entity.dart';
import 'package:arabic_mmorpg/game/game_engine.dart';
import 'package:arabic_mmorpg/game/components/monster/monster_component.dart';
import 'package:arabic_mmorpg/game/components/player/player_component.dart';
import 'package:arabic_mmorpg/game/components/player/other_player_component.dart';

class CombatSystem extends Component with HasGameRef<GameEngine> {
  // Random number generator
  final Random random = Random();
  
  // Combat state
  String? currentTargetId;
  Component? currentTarget;
  double attackCooldown = 0.0;
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Update attack cooldown
    if (attackCooldown > 0) {
      attackCooldown -= dt;
    }
    
    // Find target if none selected
    if (currentTarget == null && currentTargetId != null) {
      _findTarget();
    }
    
    // Auto-attack if target is in range
    if (currentTarget != null && attackCooldown <= 0) {
      _autoAttack();
    }
  }
  
  void _findTarget() {
    // Check if target is a monster
    final monsters = gameRef.gameWorld.monsterComponents;
    for (final monster in monsters) {
      if (monster.monsterId == currentTargetId) {
        currentTarget = monster;
        return;
      }
    }
    
    // Check if target is another player
    final players = gameRef.gameWorld.otherPlayerComponents;
    for (final player in players) {
      if (player.characterId == currentTargetId) {
        currentTarget = player;
        return;
      }
    }
    
    // Target not found
    currentTargetId = null;
  }
  
  void _autoAttack() {
    // Check if target is in range
    final playerPosition = gameRef.playerComponent.position;
    final targetPosition = currentTarget!.position;
    final distance = playerPosition.distanceTo(targetPosition);
    
    // Get attack range
    final attackRange = 50.0; // Default melee range
    
    if (distance <= attackRange) {
      // Perform attack
      gameRef.playerComponent.attack();
      
      // Calculate damage
      final damage = _calculateDamage(
        gameRef.playerCharacter,
        null, // No skill for basic attack
      );
      
      // Apply damage to target
      if (currentTarget is MonsterComponent) {
        final monster = currentTarget as MonsterComponent;
        monster.takeDamage(damage, gameRef.playerCharacter.id);
      } else if (currentTarget is OtherPlayerComponent) {
        // PvP damage would be handled by the server
        // Just send attack message
      }
      
      // Set cooldown
      attackCooldown = 1.0 / gameRef.playerCharacter.attackSpeed;
    }
  }
  
  // Set target
  void setTarget(String targetId) {
    currentTargetId = targetId;
    currentTarget = null;
    _findTarget();
  }
  
  // Clear target
  void clearTarget() {
    currentTargetId = null;
    currentTarget = null;
  }
  
  // Use skill on target
  void useSkill(SkillEntity skill, String targetId) {
    // Set target
    setTarget(targetId);
    
    // Check if target exists
    if (currentTarget == null) return;
    
    // Check if skill is on cooldown
    if (skill.currentCooldown > 0) return;
    
    // Check if enough mana
    if (gameRef.playerCharacter.mana < skill.manaCost) return;
    
    // Check if target is in range
    final playerPosition = gameRef.playerComponent.position;
    final targetPosition = currentTarget!.position;
    final distance = playerPosition.distanceTo(targetPosition);
    
    if (distance <= skill.range) {
      // Use skill
      gameRef.playerComponent.useSkill(skill);
      
      // Calculate damage
      final damage = _calculateDamage(
        gameRef.playerCharacter,
        skill,
      );
      
      // Apply damage to target
      if (currentTarget is MonsterComponent) {
        final monster = currentTarget as MonsterComponent;
        monster.takeDamage(damage, gameRef.playerCharacter.id);
      } else if (currentTarget is OtherPlayerComponent) {
        // PvP damage would be handled by the server
        // Just send attack message
      }
      
      // Set skill cooldown
      skill.currentCooldown = skill.cooldown;
    }
  }
  
  // Calculate damage
  int _calculateDamage(CharacterEntity attacker, SkillEntity? skill) {
    // Base damage
    int baseDamage;
    
    if (skill != null) {
      // Skill damage
      if (skill.damageType == DamageType.physical) {
        baseDamage = attacker.physicalAttack;
      } else {
        baseDamage = attacker.magicalAttack;
      }
      
      // Apply skill damage multiplier
      baseDamage = (baseDamage * skill.damageMultiplier).round();
    } else {
      // Basic attack damage
      baseDamage = attacker.physicalAttack;
    }
    
    // Random variation (90% - 110%)
    final variation = 0.9 + random.nextDouble() * 0.2;
    baseDamage = (baseDamage * variation).round();
    
    // Critical hit
    bool isCritical = random.nextDouble() * 100 < attacker.criticalRate;
    if (isCritical) {
      baseDamage = (baseDamage * attacker.criticalDamage / 100).round();
    }
    
    // Ensure minimum damage
    return max(1, baseDamage);
  }
}