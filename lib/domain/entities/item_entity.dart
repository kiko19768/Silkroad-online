import 'package:equatable/equatable.dart';

enum ItemType {
  weapon,
  armor,
  accessory,
  consumable,
  material,
  quest,
  mount,
  pet,
  wing,
  costume,
  gem,
  scroll,
  box,
  key,
  special,
}

enum ItemRarity {
  common,
  uncommon,
  rare,
  epic,
  legendary,
  mythic,
  divine,
}

enum EquipmentSlot {
  weapon,
  offhand,
  helmet,
  armor,
  pants,
  gloves,
  boots,
  necklace,
  ring1,
  ring2,
  earring1,
  earring2,
  cape,
  wing,
  costume,
  mount,
  pet,
}

class ItemAttribute {
  final String name;
  final String value;
  final bool isPercentage;
  
  const ItemAttribute({
    required this.name,
    required this.value,
    this.isPercentage = false,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ItemAttribute &&
        other.name == name &&
        other.value == value &&
        other.isPercentage == isPercentage;
  }
  
  @override
  int get hashCode => name.hashCode ^ value.hashCode ^ isPercentage.hashCode;
}

class ItemEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final ItemType type;
  final ItemRarity rarity;
  final EquipmentSlot? equipmentSlot;
  final int level;
  final int requiredLevel;
  final int quantity;
  final int maxQuantity;
  final bool isStackable;
  final bool isTradable;
  final bool isDroppable;
  final bool isSellable;
  final int buyPrice;
  final int sellPrice;
  final String iconPath;
  final String? modelPath;
  final List<ItemAttribute> attributes;
  final int upgradeLevel;
  final int maxUpgradeLevel;
  final int socketCount;
  final int maxSocketCount;
  final List<ItemEntity> socketedGems;
  final String? setId;
  final int durability;
  final int maxDurability;
  final int weight;
  final String? effectPath;
  final String? glowPath;
  
  const ItemEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.rarity,
    this.equipmentSlot,
    required this.level,
    required this.requiredLevel,
    required this.quantity,
    required this.maxQuantity,
    required this.isStackable,
    required this.isTradable,
    required this.isDroppable,
    required this.isSellable,
    required this.buyPrice,
    required this.sellPrice,
    required this.iconPath,
    this.modelPath,
    required this.attributes,
    required this.upgradeLevel,
    required this.maxUpgradeLevel,
    required this.socketCount,
    required this.maxSocketCount,
    required this.socketedGems,
    this.setId,
    required this.durability,
    required this.maxDurability,
    required this.weight,
    this.effectPath,
    this.glowPath,
  });
  
  @override
  List<Object?> get props => [
    id,
    name,
    description,
    type,
    rarity,
    equipmentSlot,
    level,
    requiredLevel,
    quantity,
    maxQuantity,
    isStackable,
    isTradable,
    isDroppable,
    isSellable,
    buyPrice,
    sellPrice,
    iconPath,
    modelPath,
    attributes,
    upgradeLevel,
    maxUpgradeLevel,
    socketCount,
    maxSocketCount,
    socketedGems,
    setId,
    durability,
    maxDurability,
    weight,
    effectPath,
    glowPath,
  ];
  
  // Create a copy with updated values
  ItemEntity copyWith({
    String? id,
    String? name,
    String? description,
    ItemType? type,
    ItemRarity? rarity,
    EquipmentSlot? equipmentSlot,
    int? level,
    int? requiredLevel,
    int? quantity,
    int? maxQuantity,
    bool? isStackable,
    bool? isTradable,
    bool? isDroppable,
    bool? isSellable,
    int? buyPrice,
    int? sellPrice,
    String? iconPath,
    String? modelPath,
    List<ItemAttribute>? attributes,
    int? upgradeLevel,
    int? maxUpgradeLevel,
    int? socketCount,
    int? maxSocketCount,
    List<ItemEntity>? socketedGems,
    String? setId,
    int? durability,
    int? maxDurability,
    int? weight,
    String? effectPath,
    String? glowPath,
  }) {
    return ItemEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      rarity: rarity ?? this.rarity,
      equipmentSlot: equipmentSlot ?? this.equipmentSlot,
      level: level ?? this.level,
      requiredLevel: requiredLevel ?? this.requiredLevel,
      quantity: quantity ?? this.quantity,
      maxQuantity: maxQuantity ?? this.maxQuantity,
      isStackable: isStackable ?? this.isStackable,
      isTradable: isTradable ?? this.isTradable,
      isDroppable: isDroppable ?? this.isDroppable,
      isSellable: isSellable ?? this.isSellable,
      buyPrice: buyPrice ?? this.buyPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      iconPath: iconPath ?? this.iconPath,
      modelPath: modelPath ?? this.modelPath,
      attributes: attributes ?? this.attributes,
      upgradeLevel: upgradeLevel ?? this.upgradeLevel,
      maxUpgradeLevel: maxUpgradeLevel ?? this.maxUpgradeLevel,
      socketCount: socketCount ?? this.socketCount,
      maxSocketCount: maxSocketCount ?? this.maxSocketCount,
      socketedGems: socketedGems ?? this.socketedGems,
      setId: setId ?? this.setId,
      durability: durability ?? this.durability,
      maxDurability: maxDurability ?? this.maxDurability,
      weight: weight ?? this.weight,
      effectPath: effectPath ?? this.effectPath,
      glowPath: glowPath ?? this.glowPath,
    );
  }
}