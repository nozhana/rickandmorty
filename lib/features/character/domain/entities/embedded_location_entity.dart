import 'package:equatable/equatable.dart';

class EmbeddedLocationEntity extends Equatable {
  final String? name;
  final String? url;

  const EmbeddedLocationEntity({this.name, this.url});

  @override
  List<Object?> get props => [name, url];
}
