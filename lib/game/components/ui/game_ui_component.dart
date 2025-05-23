import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:arabic_mmorpg/domain/entities/character_entity.dart';
import 'package:arabic_mmorpg/game/worlds/game_world.dart';

class GameUIComponent extends PositionComponent {
  final CharacterEntity character;
  final GameWorld world;
  
  // UI components
  late final TextComponent levelComponent;
  late final TextComponent nameComponent;
  late final TextComponent healthComponent;
  late final TextComponent manaComponent;
  late final TextComponent goldComponent;
  late final TextComponent gemsComponent;
  late final TextComponent mapNameComponent;
  
  GameUIComponent({
    required this.character,
    required this.world,
  }) : super(
    position: Vector2.zero(),
    size: Vector2.zero(),
    anchor: Anchor.topLeft,
  );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Create UI components
    levelComponent = TextComponent(
      text: 'Lv. ${character.level}',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black,
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      position: Vector2(10, 10),
      anchor: Anchor.topLeft,
    );
    add(levelComponent);
    
    nameComponent = TextComponent(
      text: character.name,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black,
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      position: Vector2(50, 10),
      anchor: Anchor.topLeft,
    );
    add(nameComponent);
    
    healthComponent = TextComponent(
      text: 'HP: ${character.health}/${character.maxHealth}',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.red,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black,
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      position: Vector2(10, 30),
      anchor: Anchor.topLeft,
    );
    add(healthComponent);
    
    manaComponent = TextComponent(
      text: 'MP: ${character.mana}/${character.maxMana}',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black,
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      position: Vector2(10, 50),
      anchor: Anchor.topLeft,
    );
    add(manaComponent);
    
    goldComponent = TextComponent(
      text: 'Gold: ${character.gold}',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.yellow,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black,
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      position: Vector2(10, 70),
      anchor: Anchor.topLeft,
    );
    add(goldComponent);
    
    gemsComponent = TextComponent(
      text: 'Gems: ${character.gems}',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.purple,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black,
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      position: Vector2(10, 90),
      anchor: Anchor.topLeft,
    );
    add(gemsComponent);
    
    mapNameComponent = TextComponent(
      text: 'Map: ${world.map.name}',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black,
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      position: Vector2(10, 110),
      anchor: Anchor.topLeft,
    );
    add(mapNameComponent);
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Update UI components
    levelComponent.text = 'Lv. ${character.level}';
    nameComponent.text = character.name;
    healthComponent.text = 'HP: ${character.health}/${character.maxHealth}';
    manaComponent.text = 'MP: ${character.mana}/${character.maxMana}';
    goldComponent.text = 'Gold: ${character.gold}';
    gemsComponent.text = 'Gems: ${character.gems}';
    mapNameComponent.text = 'Map: ${world.map.name}';
  }
}