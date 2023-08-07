import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/http.dart';
import 'package:rickandmorty/features/episode/data/models/episode.dart';
import '../../../../../core/constants/constants.dart';

part 'episode_api_service.g.dart';
part 'episode_api_response.dart';

@RestApi(baseUrl: ramApiBaseUrl)
abstract class EpisodeApiService {
  factory EpisodeApiService(Dio dio) = _EpisodeApiService;

  @GET('/episode')
  Future<HttpResponse<GetEpisodesResponse>> getAllEpisodes();

  @GET('/episode/?page={page}')
  Future<HttpResponse<GetEpisodesResponse>> getMoreEpisodes(
      @Path("page") int page);

  @GET('/episode/')
  Future<HttpResponse<GetEpisodesResponse>> filterEpisodes({
    @Query("page") int? page,
    @Query("name") String? name,
    @Query("episode") String? episode,
  });

  @GET('/episode/{id}')
  Future<HttpResponse<EpisodeModel>> getEpisode(@Path("id") String id);
}
