import 'package:equatable/equatable.dart';

enum SkillType {
  active,
  passive,
  ultimate,
  combo,
  awakening,
  fusion,
}

enum SkillTargetType {
  self,
  single,
  area,
  line,
  cone,
  all,
}

enum SkillElement {
  physical,
  fire,
  water,
  earth,
  wind,
  light,
  dark,
  neutral,
}

class SkillEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final SkillType type;
  final SkillTargetType targetType;
  final SkillElement element;
  final int level;
  final int maxLevel;
  final int requiredCharacterLevel;
  final int manaCost;
  final int cooldown;
  final int castTime;
  final double range;
  final double areaOfEffect;
  final int baseDamage;
  final double damageMultiplier;
  final int baseHealing;
  final double healingMultiplier;
  final int duration;
  final String iconPath;
  final String effectPath;
  final String animationPath;
  final String soundPath;
  final List<String> requiredSkillIds;
  final List<String> comboSkillIds;
  final Map<String, dynamic> additionalEffects;
  
  const SkillEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.targetType,
    required this.element,
    required this.level,
    required this.maxLevel,
    required this.requiredCharacterLevel,
    required this.manaCost,
    required this.cooldown,
    required this.castTime,
    required this.range,
    required this.areaOfEffect,
    required this.baseDamage,
    required this.damageMultiplier,
    required this.baseHealing,
    required this.healingMultiplier,
    required this.duration,
    required this.iconPath,
    required this.effectPath,
    required this.animationPath,
    required this.soundPath,
    required this.requiredSkillIds,
    required this.comboSkillIds,
    required this.additionalEffects,
  });
  
  @override
  List<Object?> get props => [
    id,
    name,
    description,
    type,
    targetType,
    element,
    level,
    maxLevel,
    requiredCharacterLevel,
    manaCost,
    cooldown,
    castTime,
    range,
    areaOfEffect,
    baseDamage,
    damageMultiplier,
    baseHealing,
    healingMultiplier,
    duration,
    iconPath,
    effectPath,
    animationPath,
    soundPath,
    requiredSkillIds,
    comboSkillIds,
    additionalEffects,
  ];
  
  // Create a copy with updated values
  SkillEntity copyWith({
    String? id,
    String? name,
    String? description,
    SkillType? type,
    SkillTargetType? targetType,
    SkillElement? element,
    int? level,
    int? maxLevel,
    int? requiredCharacterLevel,
    int? manaCost,
    int? cooldown,
    int? castTime,
    double? range,
    double? areaOfEffect,
    int? baseDamage,
    double? damageMultiplier,
    int? baseHealing,
    double? healingMultiplier,
    int? duration,
    String? iconPath,
    String? effectPath,
    String? animationPath,
    String? soundPath,
    List<String>? requiredSkillIds,
    List<String>? comboSkillIds,
    Map<String, dynamic>? additionalEffects,
  }) {
    return SkillEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      targetType: targetType ?? this.targetType,
      element: element ?? this.element,
      level: level ?? this.level,
      maxLevel: maxLevel ?? this.maxLevel,
      requiredCharacterLevel: requiredCharacterLevel ?? this.requiredCharacterLevel,
      manaCost: manaCost ?? this.manaCost,
      cooldown: cooldown ?? this.cooldown,
      castTime: castTime ?? this.castTime,
      range: range ?? this.range,
      areaOfEffect: areaOfEffect ?? this.areaOfEffect,
      baseDamage: baseDamage ?? this.baseDamage,
      damageMultiplier: damageMultiplier ?? this.damageMultiplier,
      baseHealing: baseHealing ?? this.baseHealing,
      healingMultiplier: healingMultiplier ?? this.healingMultiplier,
      duration: duration ?? this.duration,
      iconPath: iconPath ?? this.iconPath,
      effectPath: effectPath ?? this.effectPath,
      animationPath: animationPath ?? this.animationPath,
      soundPath: soundPath ?? this.soundPath,
      requiredSkillIds: requiredSkillIds ?? this.requiredSkillIds,
      comboSkillIds: comboSkillIds ?? this.comboSkillIds,
      additionalEffects: additionalEffects ?? this.additionalEffects,
    );
  }
}