import 'package:equatable/equatable.dart';
import 'package:arabic_mmorpg/domain/entities/item_entity.dart';
import 'package:arabic_mmorpg/domain/entities/skill_entity.dart';

enum CharacterClass {
  warrior,
  mage,
  archer,
  assassin,
}

enum CharacterGender {
  male,
  female,
}

class CharacterEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final CharacterClass characterClass;
  final CharacterGender gender;
  final int level;
  final int experience;
  final int requiredExperience;
  final int health;
  final int maxHealth;
  final int mana;
  final int maxMana;
  final int strength;
  final int intelligence;
  final int vitality;
  final int agility;
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
  final int gold;
  final int gems;
  final int battlePower;
  final int skillPoints;
  final int statPoints;
  final String? guildId;
  final String? guildRole;
  final String currentMapId;
  final double positionX;
  final double positionY;
  final List<ItemEntity> equipment;
  final List<ItemEntity> inventory;
  final List<SkillEntity> skills;
  
  const CharacterEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.characterClass,
    required this.gender,
    required this.level,
    required this.experience,
    required this.requiredExperience,
    required this.health,
    required this.maxHealth,
    required this.mana,
    required this.maxMana,
    required this.strength,
    required this.intelligence,
    required this.vitality,
    required this.agility,
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
    required this.gold,
    required this.gems,
    required this.battlePower,
    required this.skillPoints,
    required this.statPoints,
    this.guildId,
    this.guildRole,
    required this.currentMapId,
    required this.positionX,
    required this.positionY,
    required this.equipment,
    required this.inventory,
    required this.skills,
  });
  
  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    characterClass,
    gender,
    level,
    experience,
    requiredExperience,
    health,
    maxHealth,
    mana,
    maxMana,
    strength,
    intelligence,
    vitality,
    agility,
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
    gold,
    gems,
    battlePower,
    skillPoints,
    statPoints,
    guildId,
    guildRole,
    currentMapId,
    positionX,
    positionY,
    equipment,
    inventory,
    skills,
  ];
  
  // Create a copy with updated values
  CharacterEntity copyWith({
    String? id,
    String? userId,
    String? name,
    CharacterClass? characterClass,
    CharacterGender? gender,
    int? level,
    int? experience,
    int? requiredExperience,
    int? health,
    int? maxHealth,
    int? mana,
    int? maxMana,
    int? strength,
    int? intelligence,
    int? vitality,
    int? agility,
    int? minPhysicalAttack,
    int? maxPhysicalAttack,
    int? minMagicalAttack,
    int? maxMagicalAttack,
    int? physicalDefense,
    int? magicalDefense,
    int? accuracy,
    int? evasion,
    int? criticalRate,
    int? criticalDamage,
    double? moveSpeed,
    double? attackSpeed,
    int? gold,
    int? gems,
    int? battlePower,
    int? skillPoints,
    int? statPoints,
    String? guildId,
    String? guildRole,
    String? currentMapId,
    double? positionX,
    double? positionY,
    List<ItemEntity>? equipment,
    List<ItemEntity>? inventory,
    List<SkillEntity>? skills,
  }) {
    return CharacterEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      characterClass: characterClass ?? this.characterClass,
      gender: gender ?? this.gender,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      requiredExperience: requiredExperience ?? this.requiredExperience,
      health: health ?? this.health,
      maxHealth: maxHealth ?? this.maxHealth,
      mana: mana ?? this.mana,
      maxMana: maxMana ?? this.maxMana,
      strength: strength ?? this.strength,
      intelligence: intelligence ?? this.intelligence,
      vitality: vitality ?? this.vitality,
      agility: agility ?? this.agility,
      minPhysicalAttack: minPhysicalAttack ?? this.minPhysicalAttack,
      maxPhysicalAttack: maxPhysicalAttack ?? this.maxPhysicalAttack,
      minMagicalAttack: minMagicalAttack ?? this.minMagicalAttack,
      maxMagicalAttack: maxMagicalAttack ?? this.maxMagicalAttack,
      physicalDefense: physicalDefense ?? this.physicalDefense,
      magicalDefense: magicalDefense ?? this.magicalDefense,
      accuracy: accuracy ?? this.accuracy,
      evasion: evasion ?? this.evasion,
      criticalRate: criticalRate ?? this.criticalRate,
      criticalDamage: criticalDamage ?? this.criticalDamage,
      moveSpeed: moveSpeed ?? this.moveSpeed,
      attackSpeed: attackSpeed ?? this.attackSpeed,
      gold: gold ?? this.gold,
      gems: gems ?? this.gems,
      battlePower: battlePower ?? this.battlePower,
      skillPoints: skillPoints ?? this.skillPoints,
      statPoints: statPoints ?? this.statPoints,
      guildId: guildId ?? this.guildId,
      guildRole: guildRole ?? this.guildRole,
      currentMapId: currentMapId ?? this.currentMapId,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      equipment: equipment ?? this.equipment,
      inventory: inventory ?? this.inventory,
      skills: skills ?? this.skills,
    );
  }
}