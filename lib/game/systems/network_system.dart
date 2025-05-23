import 'dart:async';
import 'dart:convert';
import 'package:flame/components.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:arabic_mmorpg/config/app_config.dart';
import 'package:arabic_mmorpg/domain/entities/character_entity.dart';
import 'package:arabic_mmorpg/game/game_engine.dart';
import 'package:arabic_mmorpg/game/components/player/player_state.dart';

class NetworkSystem extends Component with HasGameRef<GameEngine> {
  // WebSocket connection
  WebSocketChannel? _channel;
  bool isConnected = false;
  
  // Message queue
  final List<Map<String, dynamic>> _incomingMessages = [];
  final List<Map<String, dynamic>> _outgoingMessages = [];
  
  // Sync timer
  double _syncTimer = 0.0;
  static const double _syncInterval = 0.1; // 10 times per second
  
  // Last sent position
  Vector2? _lastSentPosition;
  String? _lastSentState;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Connect to server
    _connectToServer();
  }
  
  void _connectToServer() {
    try {
      final uri = Uri.parse(AppConfig.websocketUrl);
      _channel = WebSocketChannel.connect(uri);
      
      // Listen for messages
      _channel!.stream.listen(
        (message) {
          // Parse message
          final Map<String, dynamic> data = jsonDecode(message);
          
          // Add to incoming messages
          _incomingMessages.add(data);
        },
        onDone: () {
          isConnected = false;
          print('WebSocket connection closed');
          
          // Reconnect after delay
          Future.delayed(const Duration(seconds: 5), () {
            _connectToServer();
          });
        },
        onError: (error) {
          isConnected = false;
          print('WebSocket error: $error');
          
          // Reconnect after delay
          Future.delayed(const Duration(seconds: 5), () {
            _connectToServer();
          });
        },
      );
      
      isConnected = true;
      print('Connected to WebSocket server');
      
      // Send initial connection message
      _sendMessage({
        'type': 'connect',
        'characterId': gameRef.playerCharacter.id,
        'mapId': gameRef.currentMap.id,
      });
    } catch (e) {
      isConnected = false;
      print('Failed to connect to WebSocket server: $e');
      
      // Retry after delay
      Future.delayed(const Duration(seconds: 5), () {
        _connectToServer();
      });
    }
  }
  
  void _sendMessage(Map<String, dynamic> message) {
    if (!isConnected || _channel == null) return;
    
    try {
      final String jsonMessage = jsonEncode(message);
      _channel!.sink.add(jsonMessage);
    } catch (e) {
      print('Failed to send message: $e');
    }
  }
  
  // Sync player state with server
  void syncPlayerState(Vector2 position, PlayerState state, CharacterEntity character) {
    // Check if sync timer has elapsed
    if (_syncTimer <= 0) {
      // Check if position or state has changed
      if (_lastSentPosition == null || 
          _lastSentState == null ||
          (_lastSentPosition! - position).length > 1.0 ||
          _lastSentState != state.toString()) {
        
        // Update last sent values
        _lastSentPosition = position.clone();
        _lastSentState = state.toString();
        
        // Send player state
        _sendMessage({
          'type': 'playerState',
          'characterId': character.id,
          'position': {
            'x': position.x,
            'y': position.y,
          },
          'state': state.toString(),
          'health': character.health,
          'mana': character.mana,
          'direction': _getDirectionFromState(),
        });
      }
      
      // Reset sync timer
      _syncTimer = _syncInterval;
    } else {
      // Decrement sync timer
      _syncTimer -= gameRef.dt;
    }
  }
  
  String _getDirectionFromState() {
    final direction = gameRef.playerComponent.direction;
    
    switch (direction) {
      case Direction.up:
        return 'up';
      case Direction.down:
        return 'down';
      case Direction.left:
        return 'left';
      case Direction.right:
        return 'right';
    }
  }
  
  // Process incoming messages
  void processIncomingMessages() {
    if (_incomingMessages.isEmpty) return;
    
    // Process all messages
    for (final message in _incomingMessages) {
      _processMessage(message);
    }
    
    // Clear processed messages
    _incomingMessages.clear();
  }
  
  void _processMessage(Map<String, dynamic> message) {
    final String type = message['type'];
    
    switch (type) {
      case 'playerJoined':
        _handlePlayerJoined(message);
        break;
      case 'playerLeft':
        _handlePlayerLeft(message);
        break;
      case 'playerState':
        _handlePlayerState(message);
        break;
      case 'monsterState':
        _handleMonsterState(message);
        break;
      case 'combat':
        _handleCombat(message);
        break;
      case 'chat':
        _handleChat(message);
        break;
      case 'mapChange':
        _handleMapChange(message);
        break;
      case 'itemDrop':
        _handleItemDrop(message);
        break;
      case 'questUpdate':
        _handleQuestUpdate(message);
        break;
      default:
        print('Unknown message type: $type');
        break;
    }
  }
  
  void _handlePlayerJoined(Map<String, dynamic> message) {
    final String characterId = message['characterId'];
    
    // Skip if it's the current player
    if (characterId == gameRef.playerCharacter.id) return;
    
    // Create character entity
    final CharacterEntity character = CharacterEntity(
      id: characterId,
      userId: message['userId'],
      name: message['name'],
      characterClass: _parseCharacterClass(message['characterClass']),
      gender: _parseGender(message['gender']),
      level: message['level'],
      experience: message['experience'],
      requiredExperience: message['requiredExperience'],
      health: message['health'],
      maxHealth: message['maxHealth'],
      mana: message['mana'],
      maxMana: message['maxMana'],
      strength: message['strength'],
      intelligence: message['intelligence'],
      vitality: message['vitality'],
      agility: message['agility'],
      luck: message['luck'],
      physicalAttack: message['physicalAttack'],
      magicalAttack: message['magicalAttack'],
      physicalDefense: message['physicalDefense'],
      magicalDefense: message['magicalDefense'],
      accuracy: message['accuracy'],
      evasion: message['evasion'],
      criticalRate: message['criticalRate'],
      criticalDamage: message['criticalDamage'],
      moveSpeed: message['moveSpeed'],
      attackSpeed: message['attackSpeed'],
      gold: message['gold'],
      gems: message['gems'],
      currentMapId: message['currentMapId'],
      positionX: message['position']['x'],
      positionY: message['position']['y'],
      guildId: message['guildId'],
      guildName: message['guildName'],
      guildRank: message['guildRank'],
      skills: [], // Skills would be parsed separately
      equipment: {}, // Equipment would be parsed separately
      inventory: [], // Inventory would be parsed separately
      quests: [], // Quests would be parsed separately
      state: message['state'],
      direction: message['direction'],
      additionalProperties: message['additionalProperties'] ?? {},
    );
    
    // Add player to game world
    gameRef.gameWorld.addOtherPlayer(character);
  }
  
  void _handlePlayerLeft(Map<String, dynamic> message) {
    final String characterId = message['characterId'];
    
    // Remove player from game world
    gameRef.gameWorld.removeOtherPlayer(characterId);
  }
  
  void _handlePlayerState(Map<String, dynamic> message) {
    final String characterId = message['characterId'];
    
    // Skip if it's the current player
    if (characterId == gameRef.playerCharacter.id) return;
    
    // Find player in game world
    final otherPlayers = gameRef.gameWorld.otherPlayerComponents;
    final playerIndex = otherPlayers.indexWhere(
      (player) => player.characterId == characterId
    );
    
    if (playerIndex >= 0) {
      // Update player state
      final player = otherPlayers[playerIndex];
      
      // Create updated character entity
      final CharacterEntity updatedCharacter = player.character.copyWith(
        positionX: message['position']['x'],
        positionY: message['position']['y'],
        health: message['health'],
        mana: message['mana'],
        state: message['state'],
        direction: message['direction'],
      );
      
      // Update player
      player.updateCharacter(updatedCharacter);
    }
  }
  
  void _handleMonsterState(Map<String, dynamic> message) {
    final String monsterId = message['monsterId'];
    final String spawnId = message['spawnId'];
    
    // Find monster in game world
    final monsters = gameRef.gameWorld.monsterComponents;
    final monsterIndex = monsters.indexWhere(
      (monster) => monster.monsterId == monsterId && monster.spawnId == spawnId
    );
    
    if (monsterIndex >= 0) {
      // Update monster state
      final monster = monsters[monsterIndex];
      
      // Update position
      monster.position = Vector2(
        message['position']['x'],
        message['position']['y'],
      );
      
      // Update health
      monster.takeDamage(
        monster.health - message['health'],
        message['lastAttackerId'] ?? '',
      );
      
      // Update state
      if (message['state'] == 'idle') {
        monster.stopMovement();
      } else if (message['state'] == 'walk') {
        monster.moveTo(Vector2(
          message['targetPosition']['x'],
          message['targetPosition']['y'],
        ));
      } else if (message['state'] == 'attack') {
        monster.attack();
      }
    }
  }
  
  void _handleCombat(Map<String, dynamic> message) {
    final String attackerId = message['attackerId'];
    final String targetId = message['targetId'];
    final int damage = message['damage'];
    final bool isCritical = message['isCritical'];
    final String skillId = message['skillId'];
    
    // Handle player taking damage
    if (targetId == gameRef.playerCharacter.id) {
      gameRef.playerComponent.takeDamage(damage);
    }
    
    // Handle player dealing damage
    if (attackerId == gameRef.playerCharacter.id) {
      // Show damage number on target
      // This would be handled by the combat system
    }
  }
  
  void _handleChat(Map<String, dynamic> message) {
    final String senderId = message['senderId'];
    final String senderName = message['senderName'];
    final String content = message['content'];
    final String channel = message['channel'];
    
    // Handle chat message
    // This would be handled by the UI system
  }
  
  void _handleMapChange(Map<String, dynamic> message) {
    final String characterId = message['characterId'];
    final String mapId = message['mapId'];
    final double positionX = message['position']['x'];
    final double positionY = message['position']['y'];
    
    // Handle map change for other players
    if (characterId != gameRef.playerCharacter.id) {
      // Remove player from game world if they changed to a different map
      if (mapId != gameRef.currentMap.id) {
        gameRef.gameWorld.removeOtherPlayer(characterId);
      }
    }
  }
  
  void _handleItemDrop(Map<String, dynamic> message) {
    final String itemId = message['itemId'];
    final String dropId = message['dropId'];
    final double positionX = message['position']['x'];
    final double positionY = message['position']['y'];
    
    // Handle item drop
    // This would be handled by the item system
  }
  
  void _handleQuestUpdate(Map<String, dynamic> message) {
    final String questId = message['questId'];
    final String status = message['status'];
    
    // Handle quest update
    // This would be handled by the quest system
  }
  
  CharacterClass _parseCharacterClass(String className) {
    switch (className) {
      case 'warrior':
        return CharacterClass.warrior;
      case 'mage':
        return CharacterClass.mage;
      case 'archer':
        return CharacterClass.archer;
      case 'assassin':
        return CharacterClass.assassin;
      default:
        return CharacterClass.warrior;
    }
  }
  
  Gender _parseGender(String genderName) {
    switch (genderName) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      default:
        return Gender.male;
    }
  }
  
  @override
  void onRemove() {
    // Close WebSocket connection
    _channel?.sink.close();
    super.onRemove();
  }
}