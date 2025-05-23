import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String username;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final bool isVip;
  final int vipLevel;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  
  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    required this.isVip,
    required this.vipLevel,
    required this.createdAt,
    required this.lastLoginAt,
  });
  
  @override
  List<Object?> get props => [
    id,
    username,
    email,
    displayName,
    avatarUrl,
    isVip,
    vipLevel,
    createdAt,
    lastLoginAt,
  ];
}