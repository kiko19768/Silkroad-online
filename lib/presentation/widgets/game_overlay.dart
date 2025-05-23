import 'package:flutter/material.dart';
import 'package:arabic_mmorpg/game/game_engine.dart';
import 'package:arabic_mmorpg/presentation/widgets/player_status_bar.dart';
import 'package:arabic_mmorpg/presentation/widgets/skill_bar.dart';
import 'package:arabic_mmorpg/presentation/widgets/mini_map.dart';
import 'package:arabic_mmorpg/presentation/widgets/chat_box.dart';
import 'package:arabic_mmorpg/presentation/widgets/game_menu_button.dart';

class GameOverlay extends StatelessWidget {
  final GameEngine game;
  
  const GameOverlay({
    Key? key,
    required this.game,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // RTL for Arabic
      child: Stack(
        children: [
          // Player status bar (top left)
          Positioned(
            top: 10,
            left: 10,
            child: SafeArea(
              child: PlayerStatusBar(
                character: game.playerCharacter,
              ),
            ),
          ),
          
          // Mini map (top right)
          Positioned(
            top: 10,
            right: 10,
            child: SafeArea(
              child: MiniMap(
                map: game.currentMap,
                playerPosition: game.playerComponent.position,
              ),
            ),
          ),
          
          // Skill bar (bottom center)
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: SafeArea(
              child: SkillBar(
                skills: game.playerCharacter.skills,
                onSkillTap: (skillIndex) {
                  // Use skill
                  if (game.playerCharacter.skills.length > skillIndex) {
                    final skill = game.playerCharacter.skills[skillIndex];
                    game.playerComponent.useSkill(skill);
                  }
                },
              ),
            ),
          ),
          
          // Chat box (bottom left)
          Positioned(
            bottom: 80,
            left: 10,
            child: SafeArea(
              child: ChatBox(
                onSendMessage: (message) {
                  // Send chat message
                  // This would be handled by the network system
                },
              ),
            ),
          ),
          
          // Game menu button (top center)
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Center(
                child: GameMenuButton(
                  onMenuOpen: () {
                    // Open game menu
                    // This would show a dialog with game options
                  },
                ),
              ),
            ),
          ),
          
          // Virtual joystick (bottom left) - for mobile
          if (MediaQuery.of(context).size.width < 600)
            Positioned(
              bottom: 100,
              left: 20,
              child: _buildVirtualJoystick(),
            ),
          
          // Action buttons (bottom right) - for mobile
          if (MediaQuery.of(context).size.width < 600)
            Positioned(
              bottom: 100,
              right: 20,
              child: _buildActionButtons(),
            ),
        ],
      ),
    );
  }
  
  Widget _buildVirtualJoystick() {
    // In a real implementation, you would use a joystick package
    // For now, we'll create a placeholder
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          'جويستك',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  
  Widget _buildActionButtons() {
    // In a real implementation, you would create proper action buttons
    // For now, we'll create placeholders
    return Row(
      children: [
        _buildActionButton('هجوم', Colors.red, () {
          game.playerComponent.attack();
        }),
        const SizedBox(width: 10),
        _buildActionButton('مهارة', Colors.blue, () {
          if (game.playerCharacter.skills.isNotEmpty) {
            game.playerComponent.useSkill(game.playerCharacter.skills[0]);
          }
        }),
      ],
    );
  }
  
  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color.withOpacity(0.7),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}