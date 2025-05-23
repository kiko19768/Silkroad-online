import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:arabic_mmorpg/domain/entities/map_entity.dart';
import 'package:arabic_mmorpg/game/components/environment/day_night_cycle_component.dart';

class MapComponent extends PositionComponent {
  final MapEntity map;
  
  // Layers
  late final TiledComponent backgroundLayer;
  late final TiledComponent foregroundLayer;
  
  // Lighting overlay
  late final RectangleComponent lightingOverlay;
  
  // Current lighting
  Color currentLightColor = Colors.white;
  double currentLightOpacity = 0.0;
  
  MapComponent({
    required this.map,
  }) : super(
    position: Vector2.zero(),
    size: Vector2(map.width.toDouble(), map.height.toDouble()),
    anchor: Anchor.topLeft,
  );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Load tilemap
    final tiledMap = await TiledComponent.load(
      map.tilemapPath,
      Vector2.all(32), // Tile size
    );
    
    // Add background layer
    backgroundLayer = await TiledComponent.load(
      map.backgroundPath,
      Vector2.all(32), // Tile size
    );
    add(backgroundLayer);
    
    // Add main tilemap
    add(tiledMap);
    
    // Add foreground layer
    foregroundLayer = await TiledComponent.load(
      map.foregroundPath,
      Vector2.all(32), // Tile size
    );
    add(foregroundLayer);
    
    // Create lighting overlay
    lightingOverlay = RectangleComponent(
      size: size,
      paint: Paint()
        ..color = currentLightColor.withOpacity(currentLightOpacity)
        ..style = PaintingStyle.fill,
      priority: 100, // High priority to render on top of most things
    );
    add(lightingOverlay);
  }
  
  // Update lighting based on time of day
  void updateLighting(TimeOfDay timeOfDay) {
    switch (timeOfDay) {
      case TimeOfDay.dawn:
        currentLightColor = const Color(0xFFE6B89C); // Soft orange-pink
        currentLightOpacity = 0.3;
        break;
      case TimeOfDay.morning:
        currentLightColor = const Color(0xFFFFF8E1); // Warm white
        currentLightOpacity = 0.1;
        break;
      case TimeOfDay.noon:
        currentLightColor = Colors.white; // Pure white
        currentLightOpacity = 0.0;
        break;
      case TimeOfDay.afternoon:
        currentLightColor = const Color(0xFFFFF8E1); // Warm white
        currentLightOpacity = 0.1;
        break;
      case TimeOfDay.dusk:
        currentLightColor = const Color(0xFFE6B89C); // Soft orange-pink
        currentLightOpacity = 0.3;
        break;
      case TimeOfDay.evening:
        currentLightColor = const Color(0xFF7986CB); // Indigo blue
        currentLightOpacity = 0.5;
        break;
      case TimeOfDay.night:
        currentLightColor = const Color(0xFF3F51B5); // Deep blue
        currentLightOpacity = 0.7;
        break;
      case TimeOfDay.midnight:
        currentLightColor = const Color(0xFF1A237E); // Very deep blue
        currentLightOpacity = 0.8;
        break;
    }
    
    // Update lighting overlay
    lightingOverlay.paint.color = currentLightColor.withOpacity(currentLightOpacity);
  }
  
  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    
    // Update lighting overlay size
    if (lightingOverlay.isMounted) {
      lightingOverlay.size = size;
    }
  }
}