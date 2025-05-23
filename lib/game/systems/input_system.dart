import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:arabic_mmorpg/game/game_engine.dart';

class InputSystem extends Component with HasGameRef<GameEngine>, KeyboardHandler {
  // Input state
  bool isMovingUp = false;
  bool isMovingDown = false;
  bool isMovingLeft = false;
  bool isMovingRight = false;
  bool isAttacking = false;
  bool isUsingSkill = false;
  int currentSkillIndex = 0;
  
  // Movement
  Vector2 movementDirection = Vector2.zero();
  
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // Handle movement keys
    isMovingUp = keysPressed.contains(LogicalKeyboardKey.keyW) || 
                 keysPressed.contains(LogicalKeyboardKey.arrowUp);
    
    isMovingDown = keysPressed.contains(LogicalKeyboardKey.keyS) || 
                   keysPressed.contains(LogicalKeyboardKey.arrowDown);
    
    isMovingLeft = keysPressed.contains(LogicalKeyboardKey.keyA) || 
                   keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    
    isMovingRight = keysPressed.contains(LogicalKeyboardKey.keyD) || 
                    keysPressed.contains(LogicalKeyboardKey.arrowRight);
    
    // Handle action keys
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.space) {
        // Basic attack
        isAttacking = true;
      } else if (event.logicalKey == LogicalKeyboardKey.keyQ) {
        // Use skill 1
        isUsingSkill = true;
        currentSkillIndex = 0;
      } else if (event.logicalKey == LogicalKeyboardKey.keyE) {
        // Use skill 2
        isUsingSkill = true;
        currentSkillIndex = 1;
      } else if (event.logicalKey == LogicalKeyboardKey.keyR) {
        // Use skill 3
        isUsingSkill = true;
        currentSkillIndex = 2;
      } else if (event.logicalKey == LogicalKeyboardKey.keyF) {
        // Use skill 4
        isUsingSkill = true;
        currentSkillIndex = 3;
      } else if (event.logicalKey == LogicalKeyboardKey.keyZ) {
        // Use skill 5
        isUsingSkill = true;
        currentSkillIndex = 4;
      } else if (event.logicalKey == LogicalKeyboardKey.keyX) {
        // Use skill 6
        isUsingSkill = true;
        currentSkillIndex = 5;
      } else if (event.logicalKey == LogicalKeyboardKey.keyC) {
        // Use skill 7
        isUsingSkill = true;
        currentSkillIndex = 6;
      } else if (event.logicalKey == LogicalKeyboardKey.keyV) {
        // Use skill 8
        isUsingSkill = true;
        currentSkillIndex = 7;
      } else if (event.logicalKey == LogicalKeyboardKey.keyF1) {
        // Toggle debug mode
        gameRef.toggleDebugMode();
      }
    }
    
    // Update movement direction
    _updateMovementDirection();
    
    return false;
  }
  
  void _updateMovementDirection() {
    movementDirection = Vector2.zero();
    
    if (isMovingUp) movementDirection.y -= 1;
    if (isMovingDown) movementDirection.y += 1;
    if (isMovingLeft) movementDirection.x -= 1;
    if (isMovingRight) movementDirection.x += 1;
    
    // Normalize if moving diagonally
    if (movementDirection.length > 0) {
      movementDirection.normalize();
    }
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Handle movement
    if (movementDirection.length > 0) {
      // Calculate target position
      final playerPosition = gameRef.playerComponent.position;
      final targetPosition = playerPosition + movementDirection * 100;
      
      // Move player
      gameRef.playerComponent.moveTo(targetPosition);
    }
    
    // Handle attack
    if (isAttacking) {
      gameRef.playerComponent.attack();
      isAttacking = false;
    }
    
    // Handle skill use
    if (isUsingSkill) {
      // Get skill from player character
      if (gameRef.playerCharacter.skills.length > currentSkillIndex) {
        final skill = gameRef.playerCharacter.skills[currentSkillIndex];
        gameRef.playerComponent.useSkill(skill);
      }
      
      isUsingSkill = false;
    }
  }
}