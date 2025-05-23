// Base exception
abstract class AppException implements Exception {
  final String message;
  
  const AppException({required this.message});
  
  @override
  String toString() => message;
}

// Network exceptions
class ServerException extends AppException {
  const ServerException({String message = 'Server error occurred'}) 
      : super(message: message);
}

class BadRequestException extends AppException {
  const BadRequestException({String message = 'Bad request'}) 
      : super(message: message);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({String message = 'Unauthorized'}) 
      : super(message: message);
}

class ForbiddenException extends AppException {
  const ForbiddenException({String message = 'Forbidden'}) 
      : super(message: message);
}

class NotFoundException extends AppException {
  const NotFoundException({String message = 'Resource not found'}) 
      : super(message: message);
}

class TimeoutException extends AppException {
  const TimeoutException({String message = 'Connection timeout'}) 
      : super(message: message);
}

class NoInternetException extends AppException {
  const NoInternetException({String message = 'No internet connection'}) 
      : super(message: message);
}

class RequestCancelledException extends AppException {
  const RequestCancelledException({String message = 'Request cancelled'}) 
      : super(message: message);
}

class UnexpectedException extends AppException {
  const UnexpectedException({String message = 'Unexpected error occurred'}) 
      : super(message: message);
}

// WebSocket exceptions
class WebSocketException extends AppException {
  const WebSocketException({String message = 'WebSocket error occurred'}) 
      : super(message: message);
}

// Cache exceptions
class CacheException extends AppException {
  const CacheException({String message = 'Cache error occurred'}) 
      : super(message: message);
}

// Authentication exceptions
class AuthException extends AppException {
  const AuthException({String message = 'Authentication error occurred'}) 
      : super(message: message);
}

// Game exceptions
class GameException extends AppException {
  const GameException({String message = 'Game error occurred'}) 
      : super(message: message);
}

// Character exceptions
class CharacterException extends AppException {
  const CharacterException({String message = 'Character error occurred'}) 
      : super(message: message);
}

// Item exceptions
class ItemException extends AppException {
  const ItemException({String message = 'Item error occurred'}) 
      : super(message: message);
}

// Guild exceptions
class GuildException extends AppException {
  const GuildException({String message = 'Guild error occurred'}) 
      : super(message: message);
}

// Quest exceptions
class QuestException extends AppException {
  const QuestException({String message = 'Quest error occurred'}) 
      : super(message: message);
}

// Map exceptions
class MapException extends AppException {
  const MapException({String message = 'Map error occurred'}) 
      : super(message: message);
}

// Combat exceptions
class CombatException extends AppException {
  const CombatException({String message = 'Combat error occurred'}) 
      : super(message: message);
}

// Skill exceptions
class SkillException extends AppException {
  const SkillException({String message = 'Skill error occurred'}) 
      : super(message: message);
}

// Trade exceptions
class TradeException extends AppException {
  const TradeException({String message = 'Trade error occurred'}) 
      : super(message: message);
}

// Chat exceptions
class ChatException extends AppException {
  const ChatException({String message = 'Chat error occurred'}) 
      : super(message: message);
}

// Event exceptions
class EventException extends AppException {
  const EventException({String message = 'Event error occurred'}) 
      : super(message: message);
}

// Resource exceptions
class ResourceException extends AppException {
  const ResourceException({String message = 'Resource error occurred'}) 
      : super(message: message);
}

// Permission exceptions
class PermissionException extends AppException {
  const PermissionException({String message = 'Permission error occurred'}) 
      : super(message: message);
}

// Validation exceptions
class ValidationException extends AppException {
  final Map<String, List<String>>? errors;
  
  const ValidationException({
    String message = 'Validation error occurred',
    this.errors,
  }) : super(message: message);
}

// Rate limit exceptions
class RateLimitException extends AppException {
  final int? retryAfterSeconds;
  
  const RateLimitException({
    String message = 'Rate limit exceeded',
    this.retryAfterSeconds,
  }) : super(message: message);
}

// Maintenance exceptions
class MaintenanceException extends AppException {
  final DateTime? estimatedEndTime;
  
  const MaintenanceException({
    String message = 'Server is under maintenance',
    this.estimatedEndTime,
  }) : super(message: message);
}