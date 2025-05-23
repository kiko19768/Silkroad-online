import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:arabic_mmorpg/domain/entities/map_entity.dart';

enum WeatherType {
  clear,
  rain,
  snow,
  fog,
  sandstorm,
  thunderstorm,
}

class WeatherComponent extends Component with HasGameRef {
  final MapType mapType;
  final List<WeatherType> possibleWeather;
  
  WeatherType currentWeather = WeatherType.clear;
  double weatherIntensity = 0.0;
  double weatherTimer = 0.0;
  double weatherDuration = 300.0; // 5 minutes
  double weatherTransitionTime = 30.0; // 30 seconds
  
  final Random random = Random();
  
  WeatherComponent({
    required this.mapType,
    required this.possibleWeather,
  });
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Set initial weather
    _changeWeather();
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Update weather timer
    weatherTimer -= dt;
    
    // Change weather if timer expires
    if (weatherTimer <= 0) {
      _changeWeather();
    }
    
    // Update weather effects
    _updateWeatherEffects(dt);
  }
  
  void _changeWeather() {
    // Select random weather from possible weather types
    final WeatherType newWeather = possibleWeather[random.nextInt(possibleWeather.length)];
    
    // Set current weather
    currentWeather = newWeather;
    
    // Set weather intensity
    weatherIntensity = random.nextDouble() * 0.7 + 0.3; // 0.3 to 1.0
    
    // Set weather duration
    weatherDuration = random.nextDouble() * 300 + 300; // 5-10 minutes
    
    // Reset timer
    weatherTimer = weatherDuration;
  }
  
  void _updateWeatherEffects(double dt) {
    switch (currentWeather) {
      case WeatherType.rain:
        _updateRainEffect(dt);
        break;
      case WeatherType.snow:
        _updateSnowEffect(dt);
        break;
      case WeatherType.fog:
        _updateFogEffect(dt);
        break;
      case WeatherType.sandstorm:
        _updateSandstormEffect(dt);
        break;
      case WeatherType.thunderstorm:
        _updateThunderstormEffect(dt);
        break;
      case WeatherType.clear:
        // No effects for clear weather
        break;
    }
  }
  
  void _updateRainEffect(double dt) {
    // Calculate number of raindrops based on intensity
    final int raindropsCount = (weatherIntensity * 5).ceil();
    
    // Create raindrops
    for (int i = 0; i < raindropsCount; i++) {
      // Random position at top of screen
      final double x = random.nextDouble() * gameRef.size.x;
      
      // Create raindrop particle
      final raindrop = ParticleComponent(
        particle: Particle.generate(
          count: 1,
          lifespan: 1.0,
          generator: (i) => AcceleratedParticle(
            acceleration: Vector2(0, 500),
            position: Vector2(x, -10),
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final paint = Paint()
                  ..color = Colors.lightBlue.withOpacity(0.6)
                  ..style = PaintingStyle.fill;
                
                canvas.drawLine(
                  Offset.zero,
                  Offset(0, 10),
                  paint,
                );
              },
            ),
          ),
        ),
      );
      
      gameRef.add(raindrop);
    }
  }
  
  void _updateSnowEffect(double dt) {
    // Calculate number of snowflakes based on intensity
    final int snowflakesCount = (weatherIntensity * 3).ceil();
    
    // Create snowflakes
    for (int i = 0; i < snowflakesCount; i++) {
      // Random position at top of screen
      final double x = random.nextDouble() * gameRef.size.x;
      
      // Create snowflake particle
      final snowflake = ParticleComponent(
        particle: Particle.generate(
          count: 1,
          lifespan: 5.0,
          generator: (i) => AcceleratedParticle(
            acceleration: Vector2(random.nextDouble() * 20 - 10, 20),
            position: Vector2(x, -10),
            child: CircleParticle(
              radius: random.nextDouble() * 2 + 1,
              paint: Paint()
                ..color = Colors.white.withOpacity(0.8),
            ),
          ),
        ),
      );
      
      gameRef.add(snowflake);
    }
  }
  
  void _updateFogEffect(double dt) {
    // Create fog particle occasionally
    if (random.nextDouble() < weatherIntensity * 0.1) {
      // Random position
      final double x = random.nextDouble() * gameRef.size.x;
      final double y = random.nextDouble() * gameRef.size.y;
      
      // Create fog particle
      final fog = ParticleComponent(
        particle: Particle.generate(
          count: 1,
          lifespan: 10.0,
          generator: (i) => MovingParticle(
            from: Vector2(x, y),
            to: Vector2(x + random.nextDouble() * 100 - 50, y + random.nextDouble() * 100 - 50),
            child: CircleParticle(
              radius: random.nextDouble() * 50 + 50,
              paint: Paint()
                ..color = Colors.white.withOpacity(0.1),
            ),
          ),
        ),
      );
      
      gameRef.add(fog);
    }
  }
  
  void _updateSandstormEffect(double dt) {
    // Calculate number of sand particles based on intensity
    final int sandParticlesCount = (weatherIntensity * 10).ceil();
    
    // Create sand particles
    for (int i = 0; i < sandParticlesCount; i++) {
      // Random position
      final double x = -10;
      final double y = random.nextDouble() * gameRef.size.y;
      
      // Create sand particle
      final sand = ParticleComponent(
        particle: Particle.generate(
          count: 1,
          lifespan: 2.0,
          generator: (i) => AcceleratedParticle(
            acceleration: Vector2(200, random.nextDouble() * 20 - 10),
            position: Vector2(x, y),
            child: CircleParticle(
              radius: random.nextDouble() * 1.5 + 0.5,
              paint: Paint()
                ..color = const Color(0xFFD2B48C).withOpacity(0.6),
            ),
          ),
        ),
      );
      
      gameRef.add(sand);
    }
  }
  
  void _updateThunderstormEffect(double dt) {
    // Update rain effect
    _updateRainEffect(dt);
    
    // Occasionally create lightning
    if (random.nextDouble() < weatherIntensity * 0.01) {
      // Create lightning flash
      final lightning = ParticleComponent(
        particle: Particle.generate(
          count: 1,
          lifespan: 0.2,
          generator: (i) => ComputedParticle(
            renderer: (canvas, particle) {
              final paint = Paint()
                ..color = Colors.white.withOpacity(0.8 * (1 - particle.progress))
                ..style = PaintingStyle.fill;
              
              canvas.drawRect(
                Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
                paint,
              );
            },
          ),
        ),
      );
      
      gameRef.add(lightning);
    }
  }
}