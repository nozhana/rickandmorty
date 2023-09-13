import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String? email;
  final String? fullName;

  const UserEntity({required this.id, this.email, this.fullName});

  @override
  List<Object?> get props => [id, email, fullName];

  static const empty = UserEntity(id: '');

  bool get isEmpty => this == UserEntity.empty;
  bool get isNotEmpty => this != UserEntity.empty;
}
