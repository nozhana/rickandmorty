part of '../pages/character_list_view.dart';

SnackBar timeoutErrorSnackbar(
    {required CharacterBloc characterBloc,
    required int page,
    CharacterEntity? filterCharacterEntity}) {
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
        if (!characterBloc.isClosed) {
          if (filterCharacterEntity?.hasValue ?? false) {
            characterBloc.add(FilterMoreCharacters(
                characterEntity: filterCharacterEntity!, page: page + 1));
          } else {
            characterBloc.add(GetMoreCharacters(page: page + 1));
          }
        }
      },
    ),
  );
}

SnackBar nonFatalErrorSnackbar(
    {required DioError error,
    required CharacterBloc characterBloc,
    required int page,
    CharacterEntity? filterCharacterEntity}) {
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
        if (filterCharacterEntity?.hasValue ?? false) {
          characterBloc.add(FilterMoreCharacters(
              characterEntity: filterCharacterEntity!, page: page + 1));
        } else {
          characterBloc.add(GetMoreCharacters(page: page + 1));
        }
      },
    ),
  );
}
