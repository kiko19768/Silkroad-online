import 'package:equatable/equatable.dart';

enum GuildRank {
  leader,
  viceLeader,
  elder,
  member,
  recruit,
}

class GuildMember {
  final String userId;
  final String characterId;
  final String characterName;
  final int characterLevel;
  final String characterClass;
  final GuildRank rank;
  final int contribution;
  final DateTime joinedAt;
  final DateTime lastActiveAt;
  
  const GuildMember({
    required this.userId,
    required this.characterId,
    required this.characterName,
    required this.characterLevel,
    required this.characterClass,
    required this.rank,
    required this.contribution,
    required this.joinedAt,
    required this.lastActiveAt,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GuildMember &&
        other.userId == userId &&
        other.characterId == characterId &&
        other.characterName == characterName &&
        other.characterLevel == characterLevel &&
        other.characterClass == characterClass &&
        other.rank == rank &&
        other.contribution == contribution &&
        other.joinedAt == joinedAt &&
        other.lastActiveAt == lastActiveAt;
  }
  
  @override
  int get hashCode => characterId.hashCode;
}

class GuildBuilding {
  final String id;
  final String name;
  final String description;
  final int level;
  final int maxLevel;
  final int goldCost;
  final int resourceCost;
  final int upgradeTime;
  final Map<String, dynamic> benefits;
  
  const GuildBuilding({
    required this.id,
    required this.name,
    required this.description,
    required this.level,
    required this.maxLevel,
    required this.goldCost,
    required this.resourceCost,
    required this.upgradeTime,
    required this.benefits,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GuildBuilding &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.level == level &&
        other.maxLevel == maxLevel &&
        other.goldCost == goldCost &&
        other.resourceCost == resourceCost &&
        other.upgradeTime == upgradeTime &&
        other.benefits == benefits;
  }
  
  @override
  int get hashCode => id.hashCode;
}

class GuildWar {
  final String id;
  final String targetGuildId;
  final String targetGuildName;
  final DateTime startTime;
  final DateTime endTime;
  final int ourScore;
  final int theirScore;
  final String status;
  
  const GuildWar({
    required this.id,
    required this.targetGuildId,
    required this.targetGuildName,
    required this.startTime,
    required this.endTime,
    required this.ourScore,
    required this.theirScore,
    required this.status,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GuildWar &&
        other.id == id &&
        other.targetGuildId == targetGuildId &&
        other.targetGuildName == targetGuildName &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.ourScore == ourScore &&
        other.theirScore == theirScore &&
        other.status == status;
  }
  
  @override
  int get hashCode => id.hashCode;
}

class GuildEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String announcement;
  final String leaderId;
  final String leaderName;
  final int level;
  final int experience;
  final int requiredExperience;
  final int gold;
  final int resources;
  final String logoPath;
  final String bannerPath;
  final DateTime createdAt;
  final int memberCount;
  final int maxMemberCount;
  final List<GuildMember> members;
  final List<GuildBuilding> buildings;
  final List<GuildWar> wars;
  final List<String> allianceIds;
  final List<String> enemyIds;
  final Map<String, dynamic> additionalProperties;
  
  const GuildEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.announcement,
    required this.leaderId,
    required this.leaderName,
    required this.level,
    required this.experience,
    required this.requiredExperience,
    required this.gold,
    required this.resources,
    required this.logoPath,
    required this.bannerPath,
    required this.createdAt,
    required this.memberCount,
    required this.maxMemberCount,
    required this.members,
    required this.buildings,
    required this.wars,
    required this.allianceIds,
    required this.enemyIds,
    required this.additionalProperties,
  });
  
  @override
  List<Object?> get props => [
    id,
    name,
    description,
    announcement,
    leaderId,
    leaderName,
    level,
    experience,
    requiredExperience,
    gold,
    resources,
    logoPath,
    bannerPath,
    createdAt,
    memberCount,
    maxMemberCount,
    members,
    buildings,
    wars,
    allianceIds,
    enemyIds,
    additionalProperties,
  ];
}