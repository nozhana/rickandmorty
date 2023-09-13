import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String? email;
  final String? fullName;
  final String? profileImageUrl;

  const UserEntity(
      {required this.id, this.email, this.fullName, this.profileImageUrl});

  @override
  List<Object?> get props => [id, email, fullName, profileImageUrl];

  static const empty = UserEntity(id: '');

  bool get isEmpty => this == UserEntity.empty;
  bool get isNotEmpty => this != UserEntity.empty;
}
