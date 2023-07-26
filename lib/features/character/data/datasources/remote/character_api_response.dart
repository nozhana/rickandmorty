part of 'character_api_service.dart';

class GetCharactersResponse {
  final GetCharactersResponseInfo? info;
  final List<CharacterModel>? results;

  GetCharactersResponse(this.info, this.results);

  factory GetCharactersResponse.fromJson(Map<String, dynamic> map) {
    List<CharacterModel> results = [];
    for (Map<String, dynamic> json in map["results"]) {
      results.add(CharacterModel.fromJson(json));
    }
    return GetCharactersResponse(
      GetCharactersResponseInfo.fromJson(map["info"]),
      results,
    );
  }
}

class GetCharactersResponseInfo {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  GetCharactersResponseInfo(this.count, this.pages, this.next, this.prev);

  factory GetCharactersResponseInfo.fromJson(Map<String, dynamic> map) {
    return GetCharactersResponseInfo(
        map["count"], map["pages"], map["next"], map["prev"]);
  }
}
