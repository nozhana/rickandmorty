import 'package:rickandmorty/features/character/domain/entities/embedded_location_entity.dart';

class EmbeddedLocationModel extends EmbeddedLocationEntity {
  const EmbeddedLocationModel({String? name, String? url})
      : super(name: name, url: url);

  factory EmbeddedLocationModel.fromJson(Map<String, dynamic> map) {
    return EmbeddedLocationModel(
        name: map['name'] as String, url: map['url'] as String);
  }

  Map<String, String> toJson() {
    return {'name': name ?? 'unknown', 'url': url ?? ''};
  }
}
