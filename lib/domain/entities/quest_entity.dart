import 'package:equatable/equatable.dart';
import 'package:arabic_mmorpg/domain/entities/item_entity.dart';

enum QuestType {
  main,
  side,
  daily,
  weekly,
  guild,
  event,
  achievement,
  hidden,
}

enum QuestStatus {
  notStarted,
  inProgress,
  completed,
  failed,
  expired,
}

class QuestObjective {
  final String id;
  final String description;
  final String type;
  final String targetId;
  final int requiredAmount;
  final int currentAmount;
  final bool isCompleted;
  final Map<String, dynamic> additionalProperties;
  
  const QuestObjective({
    required this.id,
    required this.description,
    required this.type,
    required this.targetId,
    required this.requiredAmount,
    required this.currentAmount,
    required this.isCompleted,
    required this.additionalProperties,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuestObjective &&
        other.id == id &&
        other.description == description &&
        other.type == type &&
        other.targetId == targetId &&
        other.requiredAmount == requiredAmount &&
        other.currentAmount == currentAmount &&
        other.isCompleted == isCompleted &&
        other.additionalProperties == additionalProperties;
  }
  
  @override
  int get hashCode => id.hashCode;
  
  QuestObjective copyWith({
    String? id,
    String? description,
    String? type,
    String? targetId,
    int? requiredAmount,
    int? currentAmount,
    bool? isCompleted,
    Map<String, dynamic>? additionalProperties,
  }) {
    return QuestObjective(
      id: id ?? this.id,
      description: description ?? this.description,
      type: type ?? this.type,
      targetId: targetId ?? this.targetId,
      requiredAmount: requiredAmount ?? this.requiredAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      isCompleted: isCompleted ?? this.isCompleted,
      additionalProperties: additionalProperties ?? this.additionalProperties,
    );
  }
}

class QuestReward {
  final String type;
  final String? itemId;
  final int? amount;
  final Map<String, dynamic> additionalProperties;
  
  const QuestReward({
    required this.type,
    this.itemId,
    this.amount,
    required this.additionalProperties,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuestReward &&
        other.type == type &&
        other.itemId == itemId &&
        other.amount == amount &&
        other.additionalProperties == additionalProperties;
  }
  
  @override
  int get hashCode => type.hashCode;
}

class QuestEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final QuestType type;
  final QuestStatus status;
  final int requiredLevel;
  final List<String> requiredQuestIds;
  final List<QuestObjective> objectives;
  final List<QuestReward> rewards;
  final int experienceReward;
  final int goldReward;
  final int reputationReward;
  final int skillPointReward;
  final int statPointReward;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? acceptedTime;
  final DateTime? completedTime;
  final String? npcId;
  final String? mapId;
  final double? positionX;
  final double? positionY;
  final String iconPath;
  final bool isRepeatable;
  final int repeatCooldown;
  final DateTime? nextRepeatTime;
  final Map<String, dynamic> additionalProperties;
  
  const QuestEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.status,
    required this.requiredLevel,
    required this.requiredQuestIds,
    required this.objectives,
    required this.rewards,
    required this.experienceReward,
    required this.goldReward,
    required this.reputationReward,
    required this.skillPointReward,
    required this.statPointReward,
    this.startTime,
    this.endTime,
    this.acceptedTime,
    this.completedTime,
    this.npcId,
    this.mapId,
    this.positionX,
    this.positionY,
    required this.iconPath,
    required this.isRepeatable,
    required this.repeatCooldown,
    this.nextRepeatTime,
    required this.additionalProperties,
  });
  
  @override
  List<Object?> get props => [
    id,
    name,
    description,
    type,
    status,
    requiredLevel,
    requiredQuestIds,
    objectives,
    rewards,
    experienceReward,
    goldReward,
    reputationReward,
    skillPointReward,
    statPointReward,
    startTime,
    endTime,
    acceptedTime,
    completedTime,
    npcId,
    mapId,
    positionX,
    positionY,
    iconPath,
    isRepeatable,
    repeatCooldown,
    nextRepeatTime,
    additionalProperties,
  ];
  
  QuestEntity copyWith({
    String? id,
    String? name,
    String? description,
    QuestType? type,
    QuestStatus? status,
    int? requiredLevel,
    List<String>? requiredQuestIds,
    List<QuestObjective>? objectives,
    List<QuestReward>? rewards,
    int? experienceReward,
    int? goldReward,
    int? reputationReward,
    int? skillPointReward,
    int? statPointReward,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? acceptedTime,
    DateTime? completedTime,
    String? npcId,
    String? mapId,
    double? positionX,
    double? positionY,
    String? iconPath,
    bool? isRepeatable,
    int? repeatCooldown,
    DateTime? nextRepeatTime,
    Map<String, dynamic>? additionalProperties,
  }) {
    return QuestEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      requiredLevel: requiredLevel ?? this.requiredLevel,
      requiredQuestIds: requiredQuestIds ?? this.requiredQuestIds,
      objectives: objectives ?? this.objectives,
      rewards: rewards ?? this.rewards,
      experienceReward: experienceReward ?? this.experienceReward,
      goldReward: goldReward ?? this.goldReward,
      reputationReward: reputationReward ?? this.reputationReward,
      skillPointReward: skillPointReward ?? this.skillPointReward,
      statPointReward: statPointReward ?? this.statPointReward,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      acceptedTime: acceptedTime ?? this.acceptedTime,
      completedTime: completedTime ?? this.completedTime,
      npcId: npcId ?? this.npcId,
      mapId: mapId ?? this.mapId,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      iconPath: iconPath ?? this.iconPath,
      isRepeatable: isRepeatable ?? this.isRepeatable,
      repeatCooldown: repeatCooldown ?? this.repeatCooldown,
      nextRepeatTime: nextRepeatTime ?? this.nextRepeatTime,
      additionalProperties: additionalProperties ?? this.additionalProperties,
    );
  }
}