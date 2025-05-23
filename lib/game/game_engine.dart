import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:arabic_mmorpg/config/app_config.dart';
import 'package:arabic_mmorpg/game/worlds/game_world.dart';
import 'package:arabic_mmorpg/game/components/player/player_component.dart';
import 'package:arabic_mmorpg/game/components/ui/game_ui_component.dart';
import 'package:arabic_mmorpg/game/systems/input_system.dart';
import 'package:arabic_mmorpg/game/systems/network_system.dart';
import 'package:arabic_mmorpg/game/systems/combat_system.dart';
import 'package:arabic_mmorpg/game/systems/animation_system.dart';
import 'package:arabic_mmorpg/game/systems/audio_system.dart';
import 'package:arabic_mmorpg/game/systems/particle_system.dart';
import 'package:arabic_mmorpg/game/components/environment/weather_component.dart';
import 'package:arabic_mmorpg/game/components/environment/day_night_cycle_component.dart';
import 'package:arabic_mmorpg/domain/entities/character_entity.dart';
import 'package:arabic_mmorpg/domain/entities/map_entity.dart';

class GameEngine extends FlameGame with 
    HasKeyboardHandlerComponents,
    HasCollisionDetection,
    TapCallbacks,
    DragCallbacks,
    ScrollCallbacks {
  
  // Game state
  late final CharacterEntity playerCharacter;
  late final MapEntity currentMap;
  late final PlayerComponent playerComponent;
  late final GameWorld gameWorld;
  late final GameUIComponent gameUI;
  
  // Systems
  late final InputSystem inputSystem;
  late final NetworkSystem networkSystem;
  late final CombatSystem combatSystem;
  late final AnimationSystem animationSystem;
  late final AudioSystem audioSystem;
  late final ParticleSystem particleSystem;
  
  // Environment components
  late final WeatherComponent weatherComponent;
  late final DayNightCycleComponent dayNightCycleComponent;
  
  // Game time
  double dt = 0.0;
  
  // Camera
  late final CameraComponent cameraComponent;
  
  // Debug mode
  bool isDebugMode = AppConfig.enableDebugInfo;
  
  // Constructor
  GameEngine({
    required this.playerCharacter,
    required this.currentMap,
  });
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Set game size and viewport
    camera.viewport = FixedResolutionViewport(Vector2(1920, 1080));
    
    // Initialize systems
    inputSystem = InputSystem();
    networkSystem = NetworkSystem();
    combatSystem = CombatSystem();
    animationSystem = AnimationSystem();
    audioSystem = AudioSystem();
    particleSystem = ParticleSystem();
    
    // Initialize environment components
    weatherComponent = WeatherComponent(
      mapType: currentMap.mapType,
      possibleWeather: _getPossibleWeatherForMap(currentMap.mapType),
    );
    
    dayNightCycleComponent = DayNightCycleComponent();
    
    // Add systems to the game
    add(inputSystem);
    add(networkSystem);
    add(combatSystem);
    add(animationSystem);
    add(audioSystem);
    add(particleSystem);
    
    // Add environment components
    add(weatherComponent);
    add(dayNightCycleComponent);
    
    // Create game world
    gameWorld = GameWorld(
      map: currentMap,
      character: playerCharacter,
    );
    
    // Create player component
    playerComponent = PlayerComponent(
      character: playerCharacter,
      position: Vector2(playerCharacter.positionX, playerCharacter.positionY),
    );
    
    // Create camera component
    cameraComponent = CameraComponent(
      world: gameWorld,
      viewport: camera.viewport,
    );
    cameraComponent.follow(playerComponent);
    
    // Create UI component
    gameUI = GameUIComponent(
      character: playerCharacter,
      world: gameWorld,
    );
    
    // Add components to the game
    add(gameWorld);
    add(cameraComponent);
    add(gameUI);
    
    // Start background music
    audioSystem.playBackgroundMusic(currentMap.musicPath);
  }
  
  @override
  void update(double deltaTime) {
    // Store dt for other components to use
    dt = deltaTime;
    
    super.update(deltaTime);
    
    // Update game logic
    _updateGameLogic(deltaTime);
    
    // Update network state
    _syncWithServer(deltaTime);
  }
  
  void _updateGameLogic(double deltaTime) {
    // Update game systems
    inputSystem.update(deltaTime);
    combatSystem.update(deltaTime);
    animationSystem.update(deltaTime);
    particleSystem.update(deltaTime);
    
    // Update environment components
    weatherComponent.update(deltaTime);
    dayNightCycleComponent.update(deltaTime);
  }
  
  void _syncWithServer(double dt) {
    // Sync player position and state with server
    networkSystem.syncPlayerState(
      playerComponent.position,
      playerComponent.currentState,
      playerCharacter,
    );
    
    // Process incoming network messages
    networkSystem.processIncomingMessages();
  }
  
  // Change map
  Future<void> changeMap(MapEntity newMap, double posX, double posY) async {
    // Stop current music
    audioSystem.stopBackgroundMusic();
    
    // Play teleport effect
    animationSystem.playTeleportEffect(playerComponent.position);
    
    // Remove current world
    remove(gameWorld);
    
    // Remove current weather component
    remove(weatherComponent);
    
    // Update current map
    currentMap = newMap;
    
    // Update player position
    playerCharacter = playerCharacter.copyWith(
      currentMapId: newMap.id,
      positionX: posX,
      positionY: posY,
    );
    
    // Create new world
    gameWorld = GameWorld(
      map: newMap,
      character: playerCharacter,
    );
    
    // Create new weather component
    weatherComponent = WeatherComponent(
      mapType: newMap.mapType,
      possibleWeather: _getPossibleWeatherForMap(newMap.mapType),
    );
    
    // Update player component position
    playerComponent.position = Vector2(posX, posY);
    
    // Add new components
    add(gameWorld);
    add(weatherComponent);
    
    // Update camera target
    cameraComponent.world = gameWorld;
    
    // Play teleport sound
    audioSystem.playPortalSound();
    
    // Play new background music
    audioSystem.playBackgroundMusic(newMap.musicPath);
    
    // Play teleport effect at new position
    animationSystem.playTeleportEffect(playerComponent.position);
  }
  
  // Toggle debug mode
  void toggleDebugMode() {
    isDebugMode = !isDebugMode;
    gameWorld.isDebugMode = isDebugMode;
    playerComponent.isDebugMode = isDebugMode;
  }
  
  // Handle time of day changes
  void onTimeOfDayChanged(TimeOfDay timeOfDay) {
    // Update game world lighting
    gameWorld.updateLighting(timeOfDay);
    
    // Update NPC behaviors based on time
    gameWorld.updateNpcBehaviors(timeOfDay);
    
    // Update monster behaviors based on time
    gameWorld.updateMonsterBehaviors(timeOfDay);
    
    // Play appropriate ambient sounds
    switch (timeOfDay) {
      case TimeOfDay.dawn:
        audioSystem.playAmbientSound('morning_birds');
        break;
      case TimeOfDay.morning:
      case TimeOfDay.noon:
      case TimeOfDay.afternoon:
        audioSystem.playAmbientSound('daytime_ambient');
        break;
      case TimeOfDay.dusk:
        audioSystem.playAmbientSound('evening_crickets');
        break;
      case TimeOfDay.evening:
      case TimeOfDay.night:
      case TimeOfDay.midnight:
        audioSystem.playAmbientSound('night_ambient');
        break;
    }
  }
  
  // Get possible weather types for map
  List<WeatherType> _getPossibleWeatherForMap(MapType mapType) {
    switch (mapType) {
      case MapType.city:
        return [WeatherType.clear, WeatherType.rain, WeatherType.fog];
      case MapType.forest:
        return [WeatherType.clear, WeatherType.rain, WeatherType.fog];
      case MapType.desert:
        return [WeatherType.clear, WeatherType.sandstorm];
      case MapType.snow:
        return [WeatherType.clear, WeatherType.snow, WeatherType.fog];
      case MapType.mountain:
        return [WeatherType.clear, WeatherType.snow, WeatherType.fog, WeatherType.thunderstorm];
      case MapType.dungeon:
        return [WeatherType.clear, WeatherType.fog];
      case MapType.castle:
        return [WeatherType.clear, WeatherType.rain, WeatherType.fog];
      default:
        return [WeatherType.clear];
    }
  }
}