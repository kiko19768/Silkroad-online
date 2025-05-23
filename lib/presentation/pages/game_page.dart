import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:arabic_mmorpg/domain/entities/character_entity.dart';
import 'package:arabic_mmorpg/domain/entities/map_entity.dart';
import 'package:arabic_mmorpg/game/game_engine.dart';
import 'package:arabic_mmorpg/presentation/widgets/game_overlay.dart';
import 'package:arabic_mmorpg/presentation/widgets/loading_overlay.dart';

class GamePage extends StatefulWidget {
  final CharacterEntity character;
  final MapEntity map;
  
  const GamePage({
    Key? key,
    required this.character,
    required this.map,
  }) : super(key: key);
  
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late GameEngine _gameEngine;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize game engine
    _gameEngine = GameEngine(
      playerCharacter: widget.character,
      currentMap: widget.map,
    );
    
    // Set loading state
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Game widget
          GameWidget(
            game: _gameEngine,
            overlayBuilderMap: {
              'gameOverlay': (context, game) => GameOverlay(game: game as GameEngine),
              'loadingOverlay': (context, game) => const LoadingOverlay(),
            },
            initialActiveOverlays: _isLoading ? ['loadingOverlay'] : ['gameOverlay'],
            loadingBuilder: (context) => const LoadingOverlay(),
          ),
          
          // Debug button
          Positioned(
            top: 10,
            right: 10,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.bug_report),
                color: Colors.white,
                onPressed: () {
                  _gameEngine.toggleDebugMode();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}