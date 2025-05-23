import 'package:equatable/equatable.dart';

// Base failure
abstract class Failure extends Equatable {
  final String message;
  
  const Failure({required this.message});
  
  @override
  List<Object> get props => [message];
}

// Server failures
class ServerFailure extends Failure {
  const ServerFailure({String message = 'Server error occurred'}) 
      : super(message: message);
}

class BadRequestFailure extends Failure {
  const BadRequestFailure({String message = 'Bad request'}) 
      : super(message: message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({String message = 'Unauthorized'}) 
      : super(message: message);
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure({String message = 'Forbidden'}) 
      : super(message: message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({String message = 'Resource not found'}) 
      : super(message: message);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({String message = 'Connection timeout'}) 
      : super(message: message);
}

class NoInternetFailure extends Failure {
  const NoInternetFailure({String message = 'No internet connection'}) 
      : super(message: message);
}

class RequestCancelledFailure extends Failure {
  const RequestCancelledFailure({String message = 'Request cancelled'}) 
      : super(message: message);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({String message = 'Unexpected error occurred'}) 
      : super(message: message);
}

// WebSocket failures
class WebSocketFailure extends Failure {
  const WebSocketFailure({String message = 'WebSocket error occurred'}) 
      : super(message: message);
}

// Cache failures
class CacheFailure extends Failure {
  const CacheFailure({String message = 'Cache error occurred'}) 
      : super(message: message);
}

// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({String message = 'Authentication error occurred'}) 
      : super(message: message);
}

// Game failures
class GameFailure extends Failure {
  const GameFailure({String message = 'Game error occurred'}) 
      : super(message: message);
}

// Character failures
class CharacterFailure extends Failure {
  const CharacterFailure({String message = 'Character error occurred'}) 
      : super(message: message);
}

// Item failures
class ItemFailure extends Failure {
  const ItemFailure({String message = 'Item error occurred'}) 
      : super(message: message);
}

// Guild failures
class GuildFailure extends Failure {
  const GuildFailure({String message = 'Guild error occurred'}) 
      : super(message: message);
}

// Quest failures
class QuestFailure extends Failure {
  const QuestFailure({String message = 'Quest error occurred'}) 
      : super(message: message);
}

// Map failures
class MapFailure extends Failure {
  const MapFailure({String message = 'Map error occurred'}) 
      : super(message: message);
}

// Combat failures
class CombatFailure extends Failure {
  const CombatFailure({String message = 'Combat error occurred'}) 
      : super(message: message);
}

// Skill failures
class SkillFailure extends Failure {
  const SkillFailure({String message = 'Skill error occurred'}) 
      : super(message: message);
}

// Trade failures
class TradeFailure extends Failure {
  const TradeFailure({String message = 'Trade error occurred'}) 
      : super(message: message);
}

// Chat failures
class ChatFailure extends Failure {
  const ChatFailure({String message = 'Chat error occurred'}) 
      : super(message: message);
}

// Event failures
class EventFailure extends Failure {
  const EventFailure({String message = 'Event error occurred'}) 
      : super(message: message);
}

// Resource failures
class ResourceFailure extends Failure {
  const ResourceFailure({String message = 'Resource error occurred'}) 
      : super(message: message);
}

// Permission failures
class PermissionFailure extends Failure {
  const PermissionFailure({String message = 'Permission error occurred'}) 
      : super(message: message);
}

// Validation failures
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;
  
  const ValidationFailure({
    String message = 'Validation error occurred',
    this.errors,
  }) : super(message: message);
  
  @override
  List<Object> get props => [message, errors ?? {}];
}

// Rate limit failures
class RateLimitFailure extends Failure {
  final int? retryAfterSeconds;
  
  const RateLimitFailure({
    String message = 'Rate limit exceeded',
    this.retryAfterSeconds,
  }) : super(message: message);
  
  @override
  List<Object> get props => [message, retryAfterSeconds ?? 0];
}

// Maintenance failures
class MaintenanceFailure extends Failure {
  final DateTime? estimatedEndTime;
  
  const MaintenanceFailure({
    String message = 'Server is under maintenance',
    this.estimatedEndTime,
  }) : super(message: message);
  
  @override
  List<Object> get props => [message, estimatedEndTime ?? DateTime.now()];
}