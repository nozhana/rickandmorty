part of '../pages/character_list_view.dart';

SnackBar timeoutErrorSnackbar(BuildContext context,
    {required CharacterBloc characterBloc,
    required int page,
    CharacterEntity? filterCharacterEntity}) {
  return SnackBar(
    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
    behavior: SnackBarBehavior.floating,
    dismissDirection: DismissDirection.down,
    elevation: 4.0,
    padding: const EdgeInsets.all(8.0),
    content: Row(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(Icons.error_outline, color: Colors.redAccent),
        ),
        Text("Request timed out.",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSecondaryContainer)),
      ],
    ),
    action: SnackBarAction(
      label: "Retry",
      textColor: Theme.of(context).colorScheme.onSecondaryContainer,
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

SnackBar nonFatalErrorSnackbar(BuildContext context,
    {required DioError error,
    required CharacterBloc characterBloc,
    required int page,
    CharacterEntity? filterCharacterEntity}) {
  return SnackBar(
    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
    behavior: SnackBarBehavior.floating,
    dismissDirection: DismissDirection.down,
    elevation: 4.0,
    padding: const EdgeInsets.all(8.0),
    content: SizedBox.shrink(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.error_outline, color: Colors.redAccent),
              ),
              Text("Failed to fetch data.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          Theme.of(context).colorScheme.onSecondaryContainer)),
            ],
          ),
          Text(
            error.message,
            overflow: TextOverflow.fade,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onTertiaryContainer),
          ),
        ],
      ),
    ),
    action: SnackBarAction(
      label: "Retry",
      textColor: Theme.of(context).colorScheme.onSecondaryContainer,
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
