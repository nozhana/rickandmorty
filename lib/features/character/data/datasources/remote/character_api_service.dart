import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/http.dart';
import 'package:rickandmorty/features/character/data/models/character.dart';
import '../../../../../core/constants/constants.dart';

part 'character_api_service.g.dart';
part 'character_api_response.dart';

@RestApi(baseUrl: ramApiBaseUrl)
abstract class CharacterApiService {
  factory CharacterApiService(Dio dio) = _CharacterApiService;

  @GET('/character')
  Future<HttpResponse<GetCharactersResponse>> getAllCharacters();

  @GET('/character/?page={page}')
  Future<HttpResponse<GetCharactersResponse>> getMoreCharacters(
      @Path("page") int page);

  @GET('/character/')
  Future<HttpResponse<GetCharactersResponse>> filterCharacters({
    @Query("page") int? page,
    @Query("name") String? name,
    @Query("status") String? status,
    @Query("species") String? species,
    @Query("type") String? type,
    @Query("gender") String? gender,
  });

  @GET('/character/{id}')
  Future<HttpResponse<CharacterModel>> getCharacter(@Path("id") String id);
}
