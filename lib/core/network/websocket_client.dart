import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:arabic_mmorpg/config/app_config.dart';
import 'package:arabic_mmorpg/core/error/exceptions.dart';

enum ConnectionStatus {
  disconnected,
  connecting,
  connected,
  reconnecting,
}

class WebSocketClient {
  WebSocketChannel? _channel;
  String? _currentUrl;
  String? _authToken;
  
  ConnectionStatus _status = ConnectionStatus.disconnected;
  ConnectionStatus get status => _status;
  
  final StreamController<Map<String, dynamic>> _messageController = 
      StreamController<Map<String, dynamic>>.broadcast();
  
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  
  // Connect to WebSocket server
  Future<void> connect(String path, {String? authToken}) async {
    if (_status == ConnectionStatus.connected || 
        _status == ConnectionStatus.connecting) {
      return;
    }
    
    _status = ConnectionStatus.connecting;
    _authToken = authToken;
    _currentUrl = '${AppConfig.wsBaseUrl}$path';
    
    try {
      final uri = Uri.parse(_currentUrl!);
      _channel = WebSocketChannel.connect(uri);
      
      // Listen for messages
      _channel!.stream.listen(
        (dynamic message) {
          final Map<String, dynamic> decodedMessage = 
              jsonDecode(message as String) as Map<String, dynamic>;
          _messageController.add(decodedMessage);
        },
        onError: (error) {
          _status = ConnectionStatus.disconnected;
          _messageController.addError(WebSocketException(
            message: 'WebSocket error: $error',
          ));
          _attemptReconnect();
        },
        onDone: () {
          _status = ConnectionStatus.disconnected;
          _attemptReconnect();
        },
      );
      
      // Send authentication if token is provided
      if (_authToken != null) {
        send({
          'type': 'auth',
          'token': _authToken,
        });
      }
      
      _status = ConnectionStatus.connected;
    } catch (e) {
      _status = ConnectionStatus.disconnected;
      _messageController.addError(WebSocketException(
        message: 'Failed to connect to WebSocket: $e',
      ));
      _attemptReconnect();
    }
  }
  
  // Send message to WebSocket server
  void send(Map<String, dynamic> message) {
    if (_status != ConnectionStatus.connected || _channel == null) {
      _messageController.addError(WebSocketException(
        message: 'Cannot send message: WebSocket is not connected',
      ));
      return;
    }
    
    try {
      final String encodedMessage = jsonEncode(message);
      _channel!.sink.add(encodedMessage);
    } catch (e) {
      _messageController.addError(WebSocketException(
        message: 'Failed to send message: $e',
      ));
    }
  }
  
  // Disconnect from WebSocket server
  Future<void> disconnect() async {
    if (_channel != null) {
      await _channel!.sink.close();
      _channel = null;
    }
    _status = ConnectionStatus.disconnected;
    _currentUrl = null;
    _authToken = null;
  }
  
  // Attempt to reconnect
  Future<void> _attemptReconnect() async {
    if (_status == ConnectionStatus.reconnecting || _currentUrl == null) {
      return;
    }
    
    _status = ConnectionStatus.reconnecting;
    
    // Implement exponential backoff for reconnection
    int retryCount = 0;
    const maxRetries = 5;
    
    while (retryCount < maxRetries && _status != ConnectionStatus.connected) {
      await Future.delayed(Duration(seconds: 1 << retryCount));
      
      try {
        await connect(_currentUrl!, authToken: _authToken);
        break;
      } catch (e) {
        retryCount++;
      }
    }
    
    if (_status != ConnectionStatus.connected) {
      _messageController.addError(WebSocketException(
        message: 'Failed to reconnect after $maxRetries attempts',
      ));
    }
  }
  
  // Dispose resources
  void dispose() {
    disconnect();
    _messageController.close();
  }
}