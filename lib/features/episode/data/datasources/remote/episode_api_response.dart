part of 'episode_api_service.dart';

class GetEpisodesResponse {
  final GetEpisodesResponseInfo? info;
  final List<EpisodeModel>? results;

  GetEpisodesResponse(this.info, this.results);

  factory GetEpisodesResponse.fromJson(Map<String, dynamic> map) {
    List<EpisodeModel> results = [];
    for (Map<String, dynamic> json in map["results"]) {
      results.add(EpisodeModel.fromJson(json));
    }
    return GetEpisodesResponse(
      GetEpisodesResponseInfo.fromJson(map["info"]),
      results,
    );
  }
}

class GetEpisodesResponseInfo {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  GetEpisodesResponseInfo(this.count, this.pages, this.next, this.prev);

  factory GetEpisodesResponseInfo.fromJson(Map<String, dynamic> map) {
    return GetEpisodesResponseInfo(
        map["count"], map["pages"], map["next"], map["prev"]);
  }
}
