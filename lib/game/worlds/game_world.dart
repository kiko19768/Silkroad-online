import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:arabic_mmorpg/domain/entities/character_entity.dart';
import 'package:arabic_mmorpg/domain/entities/map_entity.dart';
import 'package:arabic_mmorpg/game/components/map/map_component.dart';
import 'package:arabic_mmorpg/game/components/map/portal_component.dart';
import 'package:arabic_mmorpg/game/components/npc/npc_component.dart';
import 'package:arabic_mmorpg/game/components/monster/monster_component.dart';
import 'package:arabic_mmorpg/game/components/player/other_player_component.dart';
import 'package:arabic_mmorpg/game/components/environment/weather_component.dart';
import 'package:arabic_mmorpg/game/components/environment/day_night_cycle_component.dart';

class GameWorld extends World {
  final MapEntity map;
  final CharacterEntity character;
  
  // Map components
  late final MapComponent mapComponent;
  late final List<PortalComponent> portalComponents;
  late final List<NPCComponent> npcComponents;
  late final List<MonsterComponent> monsterComponents;
  late final List<OtherPlayerComponent> otherPlayerComponents;
  
  // Environment components
  late final WeatherComponent weatherComponent;
  late final DayNightCycleComponent dayNightCycleComponent;
  
  // Collision map
  late final TiledComponent collisionMap;
  
  // Debug mode
  bool isDebugMode = false;
  
  GameWorld({
    required this.map,
    required this.character,
  });
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Load map component
    mapComponent = MapComponent(map: map);
    add(mapComponent);
    
    // Load collision map
    collisionMap = await TiledComponent.load(
      map.collisionMapPath,
      Vector2.all(32), // Tile size
    );
    add(collisionMap);
    
    // Load portals
    portalComponents = [];
    for (final portal in map.portals) {
      final portalComponent = PortalComponent(
        portal: portal,
        position: Vector2(portal.positionX, portal.positionY),
      );
      portalComponents.add(portalComponent);
      add(portalComponent);
    }
    
    // Load NPCs
    npcComponents = [];
    for (final npc in map.npcs) {
      final npcComponent = NPCComponent(
        npc: npc,
        position: Vector2(npc.positionX, npc.positionY),
        rotation: npc.rotation,
      );
      npcComponents.add(npcComponent);
      add(npcComponent);
    }
    
    // Load monsters
    monsterComponents = [];
    for (final spawn in map.monsterSpawns) {
      if (spawn.isActive) {
        await _spawnMonsters(spawn);
      }
    }
    
    // Initialize other players list
    otherPlayerComponents = [];
    
    // Add environment components
    weatherComponent = WeatherComponent(
      mapType: map.type,
      possibleWeather: map.possibleWeather,
    );
    add(weatherComponent);
    
    dayNightCycleComponent = DayNightCycleComponent();
    add(dayNightCycleComponent);
  }
  
  Future<void> _spawnMonsters(MapMonsterSpawn spawn) async {
    // In a real implementation, you would fetch monster data from a repository
    // For now, we'll create placeholder monsters
    for (int i = 0; i < spawn.count; i++) {
      // Calculate random position within spawn radius
      final double angle = i * (360 / spawn.count) * (3.14159 / 180);
      final double distance = spawn.radius * 0.8;
      final double x = spawn.positionX + distance * cos(angle);
      final double y = spawn.positionY + distance * sin(angle);
      
      final monsterComponent = MonsterComponent(
        monsterId: spawn.monsterId,
        spawnId: spawn.id,
        position: Vector2(x, y),
        respawnTime: spawn.respawnTime,
      );
      
      monsterComponents.add(monsterComponent);
      add(monsterComponent);
    }
  }
  
  // Add other player to the world
  void addOtherPlayer(CharacterEntity otherCharacter) {
    // Check if player already exists
    final existingPlayerIndex = otherPlayerComponents.indexWhere(
      (player) => player.characterId == otherCharacter.id
    );
    
    if (existingPlayerIndex >= 0) {
      // Update existing player
      otherPlayerComponents[existingPlayerIndex].updateCharacter(otherCharacter);
    } else {
      // Add new player
      final otherPlayerComponent = OtherPlayerComponent(
        character: otherCharacter,
        position: Vector2(otherCharacter.positionX, otherCharacter.positionY),
      );
      otherPlayerComponents.add(otherPlayerComponent);
      add(otherPlayerComponent);
    }
  }
  
  // Remove other player from the world
  void removeOtherPlayer(String characterId) {
    final playerIndex = otherPlayerComponents.indexWhere(
      (player) => player.characterId == characterId
    );
    
    if (playerIndex >= 0) {
      final playerComponent = otherPlayerComponents[playerIndex];
      remove(playerComponent);
      otherPlayerComponents.removeAt(playerIndex);
    }
  }
  
  // Check if position is walkable
  bool isWalkable(Vector2 position) {
    // Check map boundaries
    if (position.x < 0 || position.x >= map.width || 
        position.y < 0 || position.y >= map.height) {
      return false;
    }
    
    // Check collision with map objects
    final tileX = (position.x / 32).floor();
    final tileY = (position.y / 32).floor();
    
    // In a real implementation, you would check the collision layer
    // For now, we'll return true
    return true;
  }
  
  // Find portal at position
  PortalComponent? getPortalAt(Vector2 position) {
    for (final portal in portalComponents) {
      final distance = position.distanceTo(portal.position);
      if (distance <= portal.radius) {
        return portal;
      }
    }
    return null;
  }
  
  // Find NPC at position
  NPCComponent? getNPCAt(Vector2 position) {
    for (final npc in npcComponents) {
      final distance = position.distanceTo(npc.position);
      if (distance <= 50) { // Interaction radius
        return npc;
      }
    }
    return null;
  }
  
  // Find monster at position
  MonsterComponent? getMonsterAt(Vector2 position) {
    for (final monster in monsterComponents) {
      final distance = position.distanceTo(monster.position);
      if (distance <= 50) { // Interaction radius
        return monster;
      }
    }
    return null;
  }
  
  // Find other player at position
  OtherPlayerComponent? getOtherPlayerAt(Vector2 position) {
    for (final player in otherPlayerComponents) {
      final distance = position.distanceTo(player.position);
      if (distance <= 50) { // Interaction radius
        return player;
      }
    }
    return null;
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Update day/night cycle
    dayNightCycleComponent.update(dt);
    
    // Update weather
    weatherComponent.update(dt);
    
    // Update monsters
    for (final monster in monsterComponents) {
      monster.update(dt);
    }
    
    // Update other players
    for (final player in otherPlayerComponents) {
      player.update(dt);
    }
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
    // Render collision grid
    final paint = Paint()
      ..color = const Color(0x44FF0000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    for (int x = 0; x < map.width; x += 32) {
      for (int y = 0; y < map.height; y += 32) {
        canvas.drawRect(
          Rect.fromLTWH(x.toDouble(), y.toDouble(), 32, 32),
          paint,
        );
      }
    }
    
    // Render portal areas
    final portalPaint = Paint()
      ..color = const Color(0x440000FF)
      ..style = PaintingStyle.fill;
    
    for (final portal in portalComponents) {
      canvas.drawCircle(
        Offset(portal.position.x, portal.position.y),
        portal.radius,
        portalPaint,
      );
    }
    
    // Render NPC interaction areas
    final npcPaint = Paint()
      ..color = const Color(0x4400FF00)
      ..style = PaintingStyle.fill;
    
    for (final npc in npcComponents) {
      canvas.drawCircle(
        Offset(npc.position.x, npc.position.y),
        50, // Interaction radius
        npcPaint,
      );
    }
    
    // Render monster aggro ranges
    final monsterPaint = Paint()
      ..color = const Color(0x44FF0000)
      ..style = PaintingStyle.fill;
    
    for (final monster in monsterComponents) {
      canvas.drawCircle(
        Offset(monster.position.x, monster.position.y),
        monster.aggroRange,
        monsterPaint,
      );
    }
  }
  
  // Update lighting based on time of day
  void updateLighting(TimeOfDay timeOfDay) {
    // Update map lighting
    mapComponent.updateLighting(timeOfDay);
    
    // Update lighting for all components
    for (final npc in npcComponents) {
      npc.updateLighting(timeOfDay);
    }
    
    for (final monster in monsterComponents) {
      monster.updateLighting(timeOfDay);
    }
    
    for (final player in otherPlayerComponents) {
      player.updateLighting(timeOfDay);
    }
  }
  
  // Update NPC behaviors based on time of day
  void updateNpcBehaviors(TimeOfDay timeOfDay) {
    for (final npc in npcComponents) {
      switch (timeOfDay) {
        case TimeOfDay.dawn:
          npc.setActivity('waking_up');
          break;
        case TimeOfDay.morning:
        case TimeOfDay.noon:
        case TimeOfDay.afternoon:
          npc.setActivity('working');
          break;
        case TimeOfDay.dusk:
          npc.setActivity('closing_shop');
          break;
        case TimeOfDay.evening:
        case TimeOfDay.night:
        case TimeOfDay.midnight:
          npc.setActivity('sleeping');
          break;
      }
    }
  }
  
  // Update monster behaviors based on time of day
  void updateMonsterBehaviors(TimeOfDay timeOfDay) {
    for (final monster in monsterComponents) {
      switch (timeOfDay) {
        case TimeOfDay.dawn:
          monster.setActivity('waking_up');
          break;
        case TimeOfDay.morning:
        case TimeOfDay.noon:
        case TimeOfDay.afternoon:
          monster.setActivity('hunting');
          break;
        case TimeOfDay.dusk:
          monster.setActivity('feeding');
          break;
        case TimeOfDay.evening:
        case TimeOfDay.night:
        case TimeOfDay.midnight:
          // Some monsters are more aggressive at night
          if (monster.isNocturnal) {
            monster.setActivity('hunting');
            monster.increaseAggroRange(1.5); // 50% increase in aggro range
          } else {
            monster.setActivity('sleeping');
            monster.decreaseAggroRange(0.5); // 50% decrease in aggro range
          }
          break;
      }
    }
  }
}