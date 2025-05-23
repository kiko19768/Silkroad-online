import 'package:flutter/material.dart';
import 'package:arabic_mmorpg/domain/entities/character_entity.dart';

class PlayerStatusBar extends StatelessWidget {
  final CharacterEntity character;
  
  const PlayerStatusBar({
    Key? key,
    required this.character,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Player name and level
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    character.level.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _getCharacterClassText(character.characterClass),
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          
          // Health bar
          _buildProgressBar(
            label: 'الصحة',
            current: character.health,
            max: character.maxHealth,
            color: Colors.red,
          ),
          const SizedBox(height: 5),
          
          // Mana bar
          _buildProgressBar(
            label: 'الطاقة',
            current: character.mana,
            max: character.maxMana,
            color: Colors.blue,
          ),
          const SizedBox(height: 5),
          
          // Experience bar
          _buildProgressBar(
            label: 'الخبرة',
            current: character.experience,
            max: character.requiredExperience,
            color: Colors.green,
          ),
          const SizedBox(height: 10),
          
          // Gold and gems
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildResourceItem(
                icon: Icons.monetization_on,
                color: Colors.amber,
                value: character.gold.toString(),
                label: 'ذهب',
              ),
              _buildResourceItem(
                icon: Icons.diamond,
                color: Colors.purple,
                value: character.gems.toString(),
                label: 'جواهر',
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildProgressBar({
    required String label,
    required int current,
    required int max,
    required Color color,
  }) {
    final double percentage = max > 0 ? current / max : 0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            Text(
              '$current/$max',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Container(
          height: 10,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(5),
          ),
          child: FractionallySizedBox(
            widthFactor: percentage,
            alignment: Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildResourceItem({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  String _getCharacterClassText(CharacterClass characterClass) {
    switch (characterClass) {
      case CharacterClass.warrior:
        return 'محارب';
      case CharacterClass.mage:
        return 'ساحر';
      case CharacterClass.archer:
        return 'رامٍ';
      case CharacterClass.assassin:
        return 'قاتل';
      default:
        return '';
    }
  }
}