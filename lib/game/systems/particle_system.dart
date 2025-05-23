import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:arabic_mmorpg/game/game_engine.dart';

class ParticleSystem extends Component with HasGameRef<GameEngine> {
  // Random number generator
  final Random random = Random();
  
  // Particle pools
  final Map<String, List<Component>> _particlePools = {};
  
  // Particle settings
  static const int maxPoolSize = 50;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Initialize particle pools
    _initializeParticlePools();
  }
  
  void _initializeParticlePools() {
    // Create pools for common particles
    _particlePools['fire'] = [];
    _particlePools['water'] = [];
    _particlePools['earth'] = [];
    _particlePools['wind'] = [];
    _particlePools['light'] = [];
    _particlePools['dark'] = [];
    _particlePools['blood'] = [];
    _particlePools['gold'] = [];
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Update particle pools
    _updateParticlePools();
  }
  
  void _updateParticlePools() {
    // Remove inactive particles from pools
    for (final type in _particlePools.keys) {
      _particlePools[type]!.removeWhere((particle) => !particle.isActive);
    }
  }
  
  // Create fire particles
  void createFireParticles(Vector2 position, {int count = 10, double scale = 1.0}) {
    for (int i = 0; i < count; i++) {
      final particle = _createFireParticle(position, scale);
      gameRef.add(particle);
    }
  }
  
  // Create water particles
  void createWaterParticles(Vector2 position, {int count = 10, double scale = 1.0}) {
    for (int i = 0; i < count; i++) {
      final particle = _createWaterParticle(position, scale);
      gameRef.add(particle);
    }
  }
  
  // Create earth particles
  void createEarthParticles(Vector2 position, {int count = 10, double scale = 1.0}) {
    for (int i = 0; i < count; i++) {
      final particle = _createEarthParticle(position, scale);
      gameRef.add(particle);
    }
  }
  
  // Create wind particles
  void createWindParticles(Vector2 position, {int count = 10, double scale = 1.0}) {
    for (int i = 0; i < count; i++) {
      final particle = _createWindParticle(position, scale);
      gameRef.add(particle);
    }
  }
  
  // Create light particles
  void createLightParticles(Vector2 position, {int count = 10, double scale = 1.0}) {
    for (int i = 0; i < count; i++) {
      final particle = _createLightParticle(position, scale);
      gameRef.add(particle);
    }
  }
  
  // Create dark particles
  void createDarkParticles(Vector2 position, {int count = 10, double scale = 1.0}) {
    for (int i = 0; i < count; i++) {
      final particle = _createDarkParticle(position, scale);
      gameRef.add(particle);
    }
  }
  
  // Create blood particles
  void createBloodParticles(Vector2 position, {int count = 10, double scale = 1.0}) {
    for (int i = 0; i < count; i++) {
      final particle = _createBloodParticle(position, scale);
      gameRef.add(particle);
    }
  }
  
  // Create gold particles
  void createGoldParticles(Vector2 position, {int count = 10, double scale = 1.0}) {
    for (int i = 0; i < count; i++) {
      final particle = _createGoldParticle(position, scale);
      gameRef.add(particle);
    }
  }
  
  // Create custom particles
  void createCustomParticles(
    Vector2 position,
    Color color,
    {
      int count = 10,
      double scale = 1.0,
      double minSpeed = 50,
      double maxSpeed = 150,
      double minSize = 2,
      double maxSize = 5,
      double lifespan = 1.0,
    }
  ) {
    for (int i = 0; i < count; i++) {
      final particle = _createCustomParticle(
        position,
        color,
        scale: scale,
        minSpeed: minSpeed,
        maxSpeed: maxSpeed,
        minSize: minSize,
        maxSize: maxSize,
        lifespan: lifespan,
      );
      gameRef.add(particle);
    }
  }
  
  // Create fire particle
  Component _createFireParticle(Vector2 position, double scale) {
    // Random direction
    final double angle = random.nextDouble() * 2 * pi;
    final double speed = random.nextDouble() * 100 + 50;
    final Vector2 velocity = Vector2(cos(angle), sin(angle)) * speed;
    
    // Random size
    final double size = (random.nextDouble() * 3 + 2) * scale;
    
    // Create particle
    return ParticleComponent(
      particle: Particle.generate(
        count: 1,
        lifespan: 1.0,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, -50),
          position: position.clone(),
          speed: velocity,
          child: ComposedParticle(
            children: [
              CircleParticle(
                radius: size,
                paint: Paint()
                  ..color = Colors.red.withOpacity(0.8),
              ),
              CircleParticle(
                radius: size * 0.6,
                paint: Paint()
                  ..color = Colors.orange.withOpacity(0.8),
              ),
              CircleParticle(
                radius: size * 0.3,
                paint: Paint()
                  ..color = Colors.yellow.withOpacity(0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Create water particle
  Component _createWaterParticle(Vector2 position, double scale) {
    // Random direction
    final double angle = random.nextDouble() * 2 * pi;
    final double speed = random.nextDouble() * 80 + 40;
    final Vector2 velocity = Vector2(cos(angle), sin(angle)) * speed;
    
    // Random size
    final double size = (random.nextDouble() * 3 + 2) * scale;
    
    // Create particle
    return ParticleComponent(
      particle: Particle.generate(
        count: 1,
        lifespan: 1.0,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 50),
          position: position.clone(),
          speed: velocity,
          child: CircleParticle(
            radius: size,
            paint: Paint()
              ..color = Colors.blue.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
  
  // Create earth particle
  Component _createEarthParticle(Vector2 position, double scale) {
    // Random direction
    final double angle = random.nextDouble() * 2 * pi;
    final double speed = random.nextDouble() * 60 + 30;
    final Vector2 velocity = Vector2(cos(angle), sin(angle)) * speed;
    
    // Random size
    final double size = (random.nextDouble() * 3 + 2) * scale;
    
    // Create particle
    return ParticleComponent(
      particle: Particle.generate(
        count: 1,
        lifespan: 1.0,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 100),
          position: position.clone(),
          speed: velocity,
          child: CircleParticle(
            radius: size,
            paint: Paint()
              ..color = Colors.brown.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
  
  // Create wind particle
  Component _createWindParticle(Vector2 position, double scale) {
    // Random direction
    final double angle = random.nextDouble() * 2 * pi;
    final double speed = random.nextDouble() * 150 + 100;
    final Vector2 velocity = Vector2(cos(angle), sin(angle)) * speed;
    
    // Random size
    final double size = (random.nextDouble() * 2 + 1) * scale;
    
    // Create particle
    return ParticleComponent(
      particle: Particle.generate(
        count: 1,
        lifespan: 0.8,
        generator: (i) => MovingParticle(
          from: position.clone(),
          to: position.clone() + velocity * 0.8,
          child: CircleParticle(
            radius: size,
            paint: Paint()
              ..color = Colors.white.withOpacity(0.4),
          ),
        ),
      ),
    );
  }
  
  // Create light particle
  Component _createLightParticle(Vector2 position, double scale) {
    // Random direction
    final double angle = random.nextDouble() * 2 * pi;
    final double speed = random.nextDouble() * 80 + 40;
    final Vector2 velocity = Vector2(cos(angle), sin(angle)) * speed;
    
    // Random size
    final double size = (random.nextDouble() * 3 + 2) * scale;
    
    // Create particle
    return ParticleComponent(
      particle: Particle.generate(
        count: 1,
        lifespan: 1.2,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, -20),
          position: position.clone(),
          speed: velocity,
          child: CircleParticle(
            radius: size,
            paint: Paint()
              ..color = Colors.yellow.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
  
  // Create dark particle
  Component _createDarkParticle(Vector2 position, double scale) {
    // Random direction
    final double angle = random.nextDouble() * 2 * pi;
    final double speed = random.nextDouble() * 70 + 30;
    final Vector2 velocity = Vector2(cos(angle), sin(angle)) * speed;
    
    // Random size
    final double size = (random.nextDouble() * 3 + 2) * scale;
    
    // Create particle
    return ParticleComponent(
      particle: Particle.generate(
        count: 1,
        lifespan: 1.0,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 20),
          position: position.clone(),
          speed: velocity,
          child: CircleParticle(
            radius: size,
            paint: Paint()
              ..color = Colors.purple.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
  
  // Create blood particle
  Component _createBloodParticle(Vector2 position, double scale) {
    // Random direction
    final double angle = random.nextDouble() * 2 * pi;
    final double speed = random.nextDouble() * 100 + 50;
    final Vector2 velocity = Vector2(cos(angle), sin(angle)) * speed;
    
    // Random size
    final double size = (random.nextDouble() * 2 + 1) * scale;
    
    // Create particle
    return ParticleComponent(
      particle: Particle.generate(
        count: 1,
        lifespan: 0.8,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 100),
          position: position.clone(),
          speed: velocity,
          child: CircleParticle(
            radius: size,
            paint: Paint()
              ..color = Colors.red.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
  
  // Create gold particle
  Component _createGoldParticle(Vector2 position, double scale) {
    // Random direction
    final double angle = random.nextDouble() * 2 * pi;
    final double speed = random.nextDouble() * 80 + 40;
    final Vector2 velocity = Vector2(cos(angle), sin(angle)) * speed;
    
    // Random size
    final double size = (random.nextDouble() * 2 + 1) * scale;
    
    // Create particle
    return ParticleComponent(
      particle: Particle.generate(
        count: 1,
        lifespan: 1.5,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 50),
          position: position.clone(),
          speed: velocity,
          child: CircleParticle(
            radius: size,
            paint: Paint()
              ..color = Colors.amber.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
  
  // Create custom particle
  Component _createCustomParticle(
    Vector2 position,
    Color color,
    {
      double scale = 1.0,
      double minSpeed = 50,
      double maxSpeed = 150,
      double minSize = 2,
      double maxSize = 5,
      double lifespan = 1.0,
    }
  ) {
    // Random direction
    final double angle = random.nextDouble() * 2 * pi;
    final double speed = random.nextDouble() * (maxSpeed - minSpeed) + minSpeed;
    final Vector2 velocity = Vector2(cos(angle), sin(angle)) * speed;
    
    // Random size
    final double size = (random.nextDouble() * (maxSize - minSize) + minSize) * scale;
    
    // Create particle
    return ParticleComponent(
      particle: Particle.generate(
        count: 1,
        lifespan: lifespan,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 50),
          position: position.clone(),
          speed: velocity,
          child: CircleParticle(
            radius: size,
            paint: Paint()
              ..color = color.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}