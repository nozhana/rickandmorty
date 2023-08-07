part of '../pages/episode_list_view.dart';

SnackBar timeoutErrorSnackbar(
    {required EpisodeBloc episodeBloc,
    required int page,
    EpisodeEntity? filterEpisodeEntity}) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    dismissDirection: DismissDirection.down,
    elevation: 4.0,
    padding: const EdgeInsets.all(8.0),
    content: const Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(Icons.error_outline, color: Colors.redAccent),
        ),
        Text("Request timed out.",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
    action: SnackBarAction(
      label: "Retry",
      textColor: theme().primaryColorLight,
      onPressed: () {
        if (!episodeBloc.isClosed) {
          if (filterEpisodeEntity?.hasValue ?? false) {
            episodeBloc.add(FilterMoreEpisodes(
                episodeEntity: filterEpisodeEntity!, page: page + 1));
          } else {
            episodeBloc.add(GetMoreEpisodes(page: page + 1));
          }
        }
      },
    ),
  );
}

SnackBar nonFatalErrorSnackbar(
    {required DioError error,
    required EpisodeBloc episodeBloc,
    required int page,
    EpisodeEntity? filterEpisodeEntity}) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    dismissDirection: DismissDirection.down,
    elevation: 4.0,
    padding: const EdgeInsets.all(8.0),
    content: SizedBox.shrink(
      child: Column(
        children: <Widget>[
          const Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.error_outline, color: Colors.redAccent),
              ),
              Text("Failed to fetch data.",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Text(
            error.message,
            overflow: TextOverflow.fade,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    ),
    action: SnackBarAction(
      label: "Retry",
      textColor: theme().primaryColorLight,
      onPressed: () {
        if (filterEpisodeEntity?.hasValue ?? false) {
          episodeBloc.add(FilterMoreEpisodes(
              episodeEntity: filterEpisodeEntity!, page: page + 1));
        } else {
          episodeBloc.add(GetMoreEpisodes(page: page + 1));
        }
      },
    ),
  );
}
