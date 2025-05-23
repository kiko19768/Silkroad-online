import 'package:equatable/equatable.dart';
import 'package:arabic_mmorpg/domain/entities/item_entity.dart';
import 'package:arabic_mmorpg/domain/entities/skill_entity.dart';

enum MonsterType {
  normal,
  elite,
  boss,
  worldBoss,
  unique,
  event,
}

enum MonsterBehavior {
  passive,
  aggressive,
  neutral,
  coward,
  territorial,
}

class MonsterDrop {
  final String itemId;
  final double dropRate;
  final int minQuantity;
  final int maxQuantity;
  final int? requiredQuestId;
  
  const MonsterDrop({
    required this.itemId,
    required this.dropRate,
    required this.minQuantity,
    required this.maxQuantity,
    this.requiredQuestId,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MonsterDrop &&
        other.itemId == itemId &&
        other.dropRate == dropRate &&
        other.minQuantity == minQuantity &&
        other.maxQuantity == maxQuantity &&
        other.requiredQuestId == requiredQuestId;
  }
  
  @override
  int get hashCode => itemId.hashCode;
}

class MonsterEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final MonsterType type;
  final MonsterBehavior behavior;
  final int level;
  final int health;
  final int mana;
  final int minPhysicalAttack;
  final int maxPhysicalAttack;
  final int minMagicalAttack;
  final int maxMagicalAttack;
  final int physicalDefense;
  final int magicalDefense;
  final int accuracy;
  final int evasion;
  final int criticalRate;
  final int criticalDamage;
  final double moveSpeed;
  final double attackSpeed;
  final double aggroRange;
  final double chaseRange;
  final int experienceReward;
  final int goldReward;
  final List<MonsterDrop> drops;
  final List<SkillEntity> skills;
  final String modelPath;
  final String iconPath;
  final String? effectPath;
  final String? soundPath;
  final Map<String, dynamic> additionalProperties;
  
  const MonsterEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.behavior,
    required this.level,
    required this.health,
    required this.mana,
    required this.minPhysicalAttack,
    required this.maxPhysicalAttack,
    required this.minMagicalAttack,
    required this.maxMagicalAttack,
    required this.physicalDefense,
    required this.magicalDefense,
    required this.accuracy,
    required this.evasion,
    required this.criticalRate,
    required this.criticalDamage,
    required this.moveSpeed,
    required this.attackSpeed,
    required this.aggroRange,
    required this.chaseRange,
    required this.experienceReward,
    required this.goldReward,
    required this.drops,
    required this.skills,
    required this.modelPath,
    required this.iconPath,
    this.effectPath,
    this.soundPath,
    required this.additionalProperties,
  });
  
  @override
  List<Object?> get props => [
    id,
    name,
    description,
    type,
    behavior,
    level,
    health,
    mana,
    minPhysicalAttack,
    maxPhysicalAttack,
    minMagicalAttack,
    maxMagicalAttack,
    physicalDefense,
    magicalDefense,
    accuracy,
    evasion,
    criticalRate,
    criticalDamage,
    moveSpeed,
    attackSpeed,
    aggroRange,
    chaseRange,
    experienceReward,
    goldReward,
    drops,
    skills,
    modelPath,
    iconPath,
    effectPath,
    soundPath,
    additionalProperties,
  ];
}