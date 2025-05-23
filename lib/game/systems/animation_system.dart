import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:arabic_mmorpg/game/game_engine.dart';

class AnimationSystem extends Component with HasGameRef<GameEngine> {
  // Animation pools
  final Map<String, List<Component>> _effectPools = {};
  
  // Animation settings
  static const int maxPoolSize = 20;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Initialize effect pools
    _initializeEffectPools();
  }
  
  void _initializeEffectPools() {
    // Create pools for common effects
    _effectPools['hit'] = [];
    _effectPools['critical'] = [];
    _effectPools['heal'] = [];
    _effectPools['levelUp'] = [];
    _effectPools['teleport'] = [];
    _effectPools['death'] = [];
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Update animation pools
    _updateEffectPools();
  }
  
  void _updateEffectPools() {
    // Remove inactive effects from pools
    for (final type in _effectPools.keys) {
      _effectPools[type]!.removeWhere((effect) => !effect.isActive);
    }
  }
  
  // Play hit effect
  void playHitEffect(Vector2 position, {bool isCritical = false}) {
    if (isCritical) {
      _playEffect('critical', position);
    } else {
      _playEffect('hit', position);
    }
  }
  
  // Play heal effect
  void playHealEffect(Vector2 position) {
    _playEffect('heal', position);
  }
  
  // Play level up effect
  void playLevelUpEffect(Vector2 position) {
    _playEffect('levelUp', position);
  }
  
  // Play teleport effect
  void playTeleportEffect(Vector2 position) {
    _playEffect('teleport', position);
  }
  
  // Play death effect
  void playDeathEffect(Vector2 position) {
    _playEffect('death', position);
  }
  
  // Play custom effect
  void playCustomEffect(String effectPath, Vector2 position, Vector2 size) {
    // Create sprite animation component
    final effect = SpriteAnimationComponent(
      position: position,
      size: size,
      anchor: Anchor.center,
    );
    
    // Load animation
    gameRef.images.load(effectPath).then((image) {
      final spriteSheet = SpriteSheet(
        image: image,
        srcSize: Vector2(64, 64),
      );
      
      effect.animation = SpriteAnimation.spriteList(
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
      
      // Add remove effect when animation is done
      effect.add(
        RemoveEffect(
          delay: 0.8, // Animation duration
        ),
      );
    });
    
    // Add effect to game
    gameRef.add(effect);
  }
  
  // Play effect from pool
  void _playEffect(String type, Vector2 position) {
    // Check if pool exists
    if (!_effectPools.containsKey(type)) {
      return;
    }
    
    // Get effect from pool or create new one
    Component? effect;
    
    if (_effectPools[type]!.isNotEmpty) {
      // Get effect from pool
      effect = _effectPools[type]!.removeLast();
      
      // Reset effect
      effect.position = position;
      effect.opacity = 1.0;
      
      // Reset animation if it's a sprite animation component
      if (effect is SpriteAnimationComponent) {
        effect.animation?.reset();
      }
    } else {
      // Create new effect
      effect = _createEffect(type, position);
    }
    
    // Add effect to game
    gameRef.add(effect);
  }
  
  // Create new effect
  Component _createEffect(String type, Vector2 position) {
    switch (type) {
      case 'hit':
        return _createHitEffect(position);
      case 'critical':
        return _createCriticalEffect(position);
      case 'heal':
        return _createHealEffect(position);
      case 'levelUp':
        return _createLevelUpEffect(position);
      case 'teleport':
        return _createTeleportEffect(position);
      case 'death':
        return _createDeathEffect(position);
      default:
        return _createHitEffect(position);
    }
  }
  
  // Create hit effect
  Component _createHitEffect(Vector2 position) {
    final effect = SpriteAnimationComponent(
      position: position,
      size: Vector2(64, 64),
      anchor: Anchor.center,
    );
    
    // Load animation
    gameRef.images.load('effects/hit.png').then((image) {
      final spriteSheet = SpriteSheet(
        image: image,
        srcSize: Vector2(64, 64),
      );
      
      effect.animation = SpriteAnimation.spriteList(
        [
          spriteSheet.getSprite(0, 0),
          spriteSheet.getSprite(0, 1),
          spriteSheet.getSprite(0, 2),
          spriteSheet.getSprite(0, 3),
        ],
        stepTime: 0.1,
        loop: false,
      );
    });
    
    // Add effects
    effect.add(
      ScaleEffect.by(
        Vector2.all(1.5),
        EffectController(
          duration: 0.4,
        ),
      ),
    );
    
    effect.add(
      OpacityEffect.fadeOut(
        EffectController(
          duration: 0.4,
        ),
        onComplete: () {
          // Return to pool
          if (_effectPools['hit']!.length < maxPoolSize) {
            _effectPools['hit']!.add(effect);
          }
        },
      ),
    );
    
    return effect;
  }
  
  // Create critical effect
  Component _createCriticalEffect(Vector2 position) {
    final effect = SpriteAnimationComponent(
      position: position,
      size: Vector2(96, 96),
      anchor: Anchor.center,
    );
    
    // Load animation
    gameRef.images.load('effects/critical.png').then((image) {
      final spriteSheet = SpriteSheet(
        image: image,
        srcSize: Vector2(96, 96),
      );
      
      effect.animation = SpriteAnimation.spriteList(
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
    });
    
    // Add effects
    effect.add(
      ScaleEffect.by(
        Vector2.all(2.0),
        EffectController(
          duration: 0.6,
        ),
      ),
    );
    
    effect.add(
      OpacityEffect.fadeOut(
        EffectController(
          duration: 0.6,
        ),
        onComplete: () {
          // Return to pool
          if (_effectPools['critical']!.length < maxPoolSize) {
            _effectPools['critical']!.add(effect);
          }
        },
      ),
    );
    
    return effect;
  }
  
  // Create heal effect
  Component _createHealEffect(Vector2 position) {
    final effect = SpriteAnimationComponent(
      position: position,
      size: Vector2(64, 64),
      anchor: Anchor.center,
    );
    
    // Load animation
    gameRef.images.load('effects/heal.png').then((image) {
      final spriteSheet = SpriteSheet(
        image: image,
        srcSize: Vector2(64, 64),
      );
      
      effect.animation = SpriteAnimation.spriteList(
        [
          spriteSheet.getSprite(0, 0),
          spriteSheet.getSprite(0, 1),
          spriteSheet.getSprite(0, 2),
          spriteSheet.getSprite(0, 3),
        ],
        stepTime: 0.1,
        loop: false,
      );
    });
    
    // Add effects
    effect.add(
      MoveByEffect(
        Vector2(0, -50),
        EffectController(
          duration: 0.5,
        ),
      ),
    );
    
    effect.add(
      OpacityEffect.fadeOut(
        EffectController(
          duration: 0.5,
        ),
        onComplete: () {
          // Return to pool
          if (_effectPools['heal']!.length < maxPoolSize) {
            _effectPools['heal']!.add(effect);
          }
        },
      ),
    );
    
    return effect;
  }
  
  // Create level up effect
  Component _createLevelUpEffect(Vector2 position) {
    final effect = SpriteAnimationComponent(
      position: position,
      size: Vector2(128, 128),
      anchor: Anchor.center,
    );
    
    // Load animation
    gameRef.images.load('effects/level_up.png').then((image) {
      final spriteSheet = SpriteSheet(
        image: image,
        srcSize: Vector2(128, 128),
      );
      
      effect.animation = SpriteAnimation.spriteList(
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
    });
    
    // Add effects
    effect.add(
      ScaleEffect.by(
        Vector2.all(2.0),
        EffectController(
          duration: 1.0,
        ),
      ),
    );
    
    effect.add(
      OpacityEffect.fadeOut(
        EffectController(
          duration: 1.0,
        ),
        onComplete: () {
          // Return to pool
          if (_effectPools['levelUp']!.length < maxPoolSize) {
            _effectPools['levelUp']!.add(effect);
          }
        },
      ),
    );
    
    return effect;
  }
  
  // Create teleport effect
  Component _createTeleportEffect(Vector2 position) {
    final effect = SpriteAnimationComponent(
      position: position,
      size: Vector2(96, 96),
      anchor: Anchor.center,
    );
    
    // Load animation
    gameRef.images.load('effects/teleport.png').then((image) {
      final spriteSheet = SpriteSheet(
        image: image,
        srcSize: Vector2(96, 96),
      );
      
      effect.animation = SpriteAnimation.spriteList(
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
    });
    
    // Add effects
    effect.add(
      RotateEffect.by(
        2 * 3.14159, // Full rotation
        EffectController(
          duration: 0.8,
        ),
      ),
    );
    
    effect.add(
      OpacityEffect.fadeOut(
        EffectController(
          duration: 0.8,
        ),
        onComplete: () {
          // Return to pool
          if (_effectPools['teleport']!.length < maxPoolSize) {
            _effectPools['teleport']!.add(effect);
          }
        },
      ),
    );
    
    return effect;
  }
  
  // Create death effect
  Component _createDeathEffect(Vector2 position) {
    final effect = SpriteAnimationComponent(
      position: position,
      size: Vector2(128, 128),
      anchor: Anchor.center,
    );
    
    // Load animation
    gameRef.images.load('effects/death.png').then((image) {
      final spriteSheet = SpriteSheet(
        image: image,
        srcSize: Vector2(128, 128),
      );
      
      effect.animation = SpriteAnimation.spriteList(
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
    });
    
    // Add effects
    effect.add(
      ScaleEffect.by(
        Vector2.all(1.5),
        EffectController(
          duration: 0.8,
        ),
      ),
    );
    
    effect.add(
      OpacityEffect.fadeOut(
        EffectController(
          duration: 0.8,
        ),
        onComplete: () {
          // Return to pool
          if (_effectPools['death']!.length < maxPoolSize) {
            _effectPools['death']!.add(effect);
          }
        },
      ),
    );
    
    return effect;
  }
}