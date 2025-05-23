import 'package:equatable/equatable.dart';

enum MapType {
  city,
  forest,
  desert,
  snow,
  mountain,
  dungeon,
  castle,
  town,
  field,
  instance,
  arena,
  guild,
  event,
}

class MapPortal {
  final String id;
  final String name;
  final String targetMapId;
  final double targetX;
  final double targetY;
  final double positionX;
  final double positionY;
  final double radius;
  final int requiredLevel;
  final String? requiredQuestId;
  final String? requiredItemId;
  final bool isActive;
  
  const MapPortal({
    required this.id,
    required this.name,
    required this.targetMapId,
    required this.targetX,
    required this.targetY,
    required this.positionX,
    required this.positionY,
    required this.radius,
    required this.requiredLevel,
    this.requiredQuestId,
    this.requiredItemId,
    required this.isActive,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MapPortal &&
        other.id == id &&
        other.name == name &&
        other.targetMapId == targetMapId &&
        other.targetX == targetX &&
        other.targetY == targetY &&
        other.positionX == positionX &&
        other.positionY == positionY &&
        other.radius == radius &&
        other.requiredLevel == requiredLevel &&
        other.requiredQuestId == requiredQuestId &&
        other.requiredItemId == requiredItemId &&
        other.isActive == isActive;
  }
  
  @override
  int get hashCode => id.hashCode;
}

class MapNPC {
  final String id;
  final String name;
  final String type;
  final double positionX;
  final double positionY;
  final double rotation;
  final String modelPath;
  final String? dialogueId;
  final List<String>? shopIds;
  final List<String>? questIds;
  final bool isInteractable;
  
  const MapNPC({
    required this.id,
    required this.name,
    required this.type,
    required this.positionX,
    required this.positionY,
    required this.rotation,
    required this.modelPath,
    this.dialogueId,
    this.shopIds,
    this.questIds,
    required this.isInteractable,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MapNPC &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.positionX == positionX &&
        other.positionY == positionY &&
        other.rotation == rotation &&
        other.modelPath == modelPath &&
        other.dialogueId == dialogueId &&
        other.shopIds == shopIds &&
        other.questIds == questIds &&
        other.isInteractable == isInteractable;
  }
  
  @override
  int get hashCode => id.hashCode;
}

class MapMonsterSpawn {
  final String id;
  final String monsterId;
  final int count;
  final double positionX;
  final double positionY;
  final double radius;
  final int respawnTime;
  final bool isActive;
  final String? eventId;
  
  const MapMonsterSpawn({
    required this.id,
    required this.monsterId,
    required this.count,
    required this.positionX,
    required this.positionY,
    required this.radius,
    required this.respawnTime,
    required this.isActive,
    this.eventId,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MapMonsterSpawn &&
        other.id == id &&
        other.monsterId == monsterId &&
        other.count == count &&
        other.positionX == positionX &&
        other.positionY == positionY &&
        other.radius == radius &&
        other.respawnTime == respawnTime &&
        other.isActive == isActive &&
        other.eventId == eventId;
  }
  
  @override
  int get hashCode => id.hashCode;
}

class MapEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final MapType type;
  final int requiredLevel;
  final String? requiredQuestId;
  final String? requiredItemId;
  final bool isPvpEnabled;
  final bool isGuildWarEnabled;
  final bool isSafeZone;
  final bool isInstanceMap;
  final int maxPlayers;
  final int width;
  final int height;
  final String backgroundPath;
  final String foregroundPath;
  final String tilemapPath;
  final String collisionMapPath;
  final String musicPath;
  final String miniMapPath;
  final String fullMapPath;
  final MapType mapType;
  final List<MapPortal> portals;
  final List<MapNPC> npcs;
  final List<MapMonsterSpawn> monsterSpawns;
  final Map<String, dynamic> additionalProperties;
  
  const MapEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.requiredLevel,
    this.requiredQuestId,
    this.requiredItemId,
    required this.isPvpEnabled,
    required this.isGuildWarEnabled,
    required this.isSafeZone,
    required this.isInstanceMap,
    required this.maxPlayers,
    required this.width,
    required this.height,
    required this.backgroundPath,
    required this.foregroundPath,
    required this.tilemapPath,
    required this.collisionMapPath,
    required this.musicPath,
    required this.miniMapPath,
    required this.fullMapPath,
    required this.mapType,
    required this.portals,
    required this.npcs,
    required this.monsterSpawns,
    required this.additionalProperties,
  });
  
  @override
  List<Object?> get props => [
    id,
    name,
    description,
    type,
    requiredLevel,
    requiredQuestId,
    requiredItemId,
    isPvpEnabled,
    isGuildWarEnabled,
    isSafeZone,
    isInstanceMap,
    maxPlayers,
    width,
    height,
    backgroundPath,
    foregroundPath,
    tilemapPath,
    collisionMapPath,
    musicPath,
    miniMapPath,
    fullMapPath,
    mapType,
    portals,
    npcs,
    monsterSpawns,
    additionalProperties,
  ];
}