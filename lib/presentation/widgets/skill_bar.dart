import 'package:flutter/material.dart';
import 'package:arabic_mmorpg/domain/entities/skill_entity.dart';

class SkillBar extends StatelessWidget {
  final List<SkillEntity> skills;
  final Function(int) onSkillTap;
  
  const SkillBar({
    Key? key,
    required this.skills,
    required this.onSkillTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Basic attack button
          _buildSkillButton(
            icon: Icons.sports_kabaddi,
            label: 'هجوم',
            cooldown: 0,
            maxCooldown: 0,
            onTap: () => onSkillTap(-1), // -1 for basic attack
          ),
          
          // Skills
          ...List.generate(8, (index) {
            if (index < skills.length) {
              final skill = skills[index];
              return _buildSkillButton(
                iconPath: skill.iconPath,
                label: skill.name,
                cooldown: skill.currentCooldown,
                maxCooldown: skill.cooldown,
                onTap: () => onSkillTap(index),
              );
            } else {
              return _buildEmptySkillButton();
            }
          }),
        ],
      ),
    );
  }
  
  Widget _buildSkillButton({
    IconData? icon,
    String? iconPath,
    required String label,
    required double cooldown,
    required double maxCooldown,
    required VoidCallback onTap,
  }) {
    final bool isOnCooldown = cooldown > 0;
    final double cooldownPercentage = maxCooldown > 0 ? cooldown / maxCooldown : 0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: isOnCooldown ? null : onTap,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey.shade700,
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              // Skill icon
              Center(
                child: iconPath != null
                    ? Image.asset(
                        iconPath,
                        width: 40,
                        height: 40,
                        color: isOnCooldown ? Colors.grey : null,
                      )
                    : Icon(
                        icon ?? Icons.help_outline,
                        size: 30,
                        color: isOnCooldown ? Colors.grey : Colors.white,
                      ),
              ),
              
              // Skill label
              Positioned(
                bottom: 2,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isOnCooldown ? Colors.grey : Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              
              // Cooldown overlay
              if (isOnCooldown)
                Positioned.fill(
                  child: ClipRect(
                    child: FractionallySizedBox(
                      alignment: Alignment.bottomCenter,
                      heightFactor: cooldownPercentage,
                      child: Container(
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
              
              // Cooldown text
              if (isOnCooldown)
                Center(
                  child: Text(
                    cooldown.ceil().toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildEmptySkillButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.shade700,
            width: 2,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            size: 30,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}