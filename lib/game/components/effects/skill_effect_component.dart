import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:arabic_mmorpg/domain/entities/skill_entity.dart';

class SkillEffectComponent extends SpriteAnimationComponent {
  final SkillEntity skill;
  
  SkillEffectComponent({
    required this.skill,
    required Vector2 position,
    required Vector2 size,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.center,
  );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Load skill effect animation
    final spriteSheet = SpriteSheet(
      image: await game.images.load(skill.effectPath),
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
      loop: false,
    );
    
    // Add effects based on skill type
    _addEffectsBasedOnSkillType();
    
    // Remove component when animation is done
    add(
      RemoveEffect(
        delay: 0.8, // Animation duration
      ),
    );
  }
  
  void _addEffectsBasedOnSkillType() {
    switch (skill.type) {
      case SkillType.active:
        _addActiveSkillEffects();
        break;
      case SkillType.ultimate:
        _addUltimateSkillEffects();
        break;
      case SkillType.combo:
        _addComboSkillEffects();
        break;
      case SkillType.awakening:
        _addAwakeningSkillEffects();
        break;
      default:
        // No special effects for other skill types
        break;
    }
  }
  
  void _addActiveSkillEffects() {
    // Add scale effect
    add(
      ScaleEffect.by(
        Vector2.all(1.5),
        EffectController(
          duration: 0.3,
          reverseDuration: 0.5,
        ),
      ),
    );
    
    // Add rotation effect if it's a spinning skill
    if (skill.additionalEffects['isSpinning'] == true) {
      add(
        RotateEffect.by(
          2 * 3.14159, // Full rotation
          EffectController(
            duration: 0.8,
          ),
        ),
      );
    }
  }
  
  void _addUltimateSkillEffects() {
    // Add scale effect
    add(
      ScaleEffect.by(
        Vector2.all(2.0),
        EffectController(
          duration: 0.4,
          reverseDuration: 0.4,
        ),
      ),
    );
    
    // Add color effect
    add(
      ColorEffect(
        Colors.red,
        const Offset(0.0, 0.8),
        EffectController(
          duration: 0.2,
          reverseDuration: 0.2,
          repeatCount: 3,
        ),
      ),
    );
  }
  
  void _addComboSkillEffects() {
    // Add movement effect
    add(
      MoveEffect.by(
        Vector2(100, 0),
        EffectController(
          duration: 0.4,
          reverseDuration: 0.4,
        ),
      ),
    );
  }
  
  void _addAwakeningSkillEffects() {
    // Add glow effect
    add(
      OpacityEffect.fadeIn(
        EffectController(
          duration: 0.3,
        ),
      ),
    );
    
    // Add scale effect
    add(
      ScaleEffect.by(
        Vector2.all(3.0),
        EffectController(
          duration: 0.8,
        ),
      ),
    );
  }
}