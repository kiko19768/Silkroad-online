import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:arabic_mmorpg/domain/entities/map_entity.dart';

class MiniMap extends StatelessWidget {
  final MapEntity map;
  final Vector2 playerPosition;
  
  const MiniMap({
    Key? key,
    required this.map,
    required this.playerPosition,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
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
          // Map background
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              map.miniMapPath,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          
          // Player marker
          Positioned(
            left: (playerPosition.x / map.width) * 150,
            top: (playerPosition.y / map.height) * 150,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
            ),
          ),
          
          // Map name
          Positioned(
            top: 5,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  map.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          
          // Expand button
          Positioned(
            bottom: 5,
            right: 5,
            child: GestureDetector(
              onTap: () {
                // Show full map
                _showFullMap(context);
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.fullscreen,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showFullMap(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey.shade700,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              // Map name
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  map.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              // Map image
              Expanded(
                child: Stack(
                  children: [
                    // Map background
                    Image.asset(
                      map.fullMapPath,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.contain,
                    ),
                    
                    // Player marker
                    Positioned(
                      left: (playerPosition.x / map.width) * MediaQuery.of(context).size.width * 0.8,
                      top: (playerPosition.y / map.height) * MediaQuery.of(context).size.height * 0.7,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    
                    // NPCs, portals, etc.
                    ..._buildMapMarkers(context),
                  ],
                ),
              ),
              
              // Close button
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('إغلاق'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  List<Widget> _buildMapMarkers(BuildContext context) {
    final List<Widget> markers = [];
    
    // Add NPC markers
    for (final npc in map.npcs) {
      markers.add(
        Positioned(
          left: (npc.positionX / map.width) * MediaQuery.of(context).size.width * 0.8,
          top: (npc.positionY / map.height) * MediaQuery.of(context).size.height * 0.7,
          child: Tooltip(
            message: npc.name,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    // Add portal markers
    for (final portal in map.portals) {
      markers.add(
        Positioned(
          left: (portal.positionX / map.width) * MediaQuery.of(context).size.width * 0.8,
          top: (portal.positionY / map.height) * MediaQuery.of(context).size.height * 0.7,
          child: Tooltip(
            message: portal.name,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    // Add monster spawn markers
    for (final spawn in map.monsterSpawns) {
      markers.add(
        Positioned(
          left: (spawn.positionX / map.width) * MediaQuery.of(context).size.width * 0.8,
          top: (spawn.positionY / map.height) * MediaQuery.of(context).size.height * 0.7,
          child: Tooltip(
            message: 'Monster Spawn: ${spawn.monsterId}',
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.5),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    return markers;
  }
}