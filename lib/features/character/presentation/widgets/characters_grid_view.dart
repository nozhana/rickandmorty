part of '../pages/character_list_view.dart';

Widget charactersGridView(
    {required List<CharacterEntity> characterEntities,
    required BuildContext context,
    required ScrollController controller,
    bool isLoading = false}) {
  return SingleChildScrollView(
    controller: controller,
    physics: (isLoading
        ? const NeverScrollableScrollPhysics()
        : const BouncingScrollPhysics()),
    child: Center(
      child: Column(children: <Widget>[
        _charactersGridView(
          characterEntities: characterEntities,
          context: context,
        ),
        Visibility(
          visible: isLoading,
          replacement: Container(height: 80),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.grey.shade500,
              ),
            ),
          ),
        )
      ]),
    ),
  );
}

Widget _charactersGridView(
    {required List<CharacterEntity> characterEntities,
    required BuildContext context}) {
  final crossAxisCount = (MediaQuery.of(context).size.width > 700)
      ? 4
      : (MediaQuery.of(context).size.width > 450)
          ? 3
          : 2;

  final horizontalContentPadding = (MediaQuery.of(context).size.width > 700)
      ? 46.0
      : (MediaQuery.of(context).size.width > 450)
          ? 24.0
          : 8.0;

  return Container(
    margin: EdgeInsets.symmetric(horizontal: horizontalContentPadding),
    decoration: BoxDecoration(
      color: theme().backgroundColor,
    ),
    child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: 0.9,
      ),
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: characterEntities.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (BuildContext context, int index) {
        return _charactersGridTile(
            context: context,
            characterEntities: characterEntities,
            index: index);
      },
    ),
  );
}

Widget _charactersGridTile(
    {required BuildContext context,
    required List<CharacterEntity> characterEntities,
    required int index}) {
  return GestureDetector(
    onTap: () {
      HapticFeedback.lightImpact();
      context.beamToNamed('/characters/${characterEntities[index].id}',
          data: {'characterName': characterEntities[index].name});
    },
    child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: theme().shadowColor.withOpacity(0.1),
            blurRadius: 6.0,
            offset: const Offset(0.0, 2.0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            SizedBox.expand(
              child: _networkImage(characterEntities[index].image!,
                  MediaQuery.of(context).size.width.toInt()),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme().cardColor,
              ),
              child: _textCaption(
                  width: MediaQuery.of(context).size.width,
                  caption: characterEntities[index].name!),
            ),
          ],
        ),
      ),
    ),
  );
}

SizedBox _textCaption({required double width, required String caption}) {
  return SizedBox(
    width: width,
    height: 40,
    child: Center(
      child: Text(
        caption,
        softWrap: true,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: theme().primaryColorDark, fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

CachedNetworkImage _networkImage(String imageUrl, int width) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    memCacheWidth: width,
    alignment: Alignment.center,
    fit: BoxFit.cover,
    placeholder: (context, url) => Center(
      child: SizedBox.expand(
          child: Container(
        color: theme().backgroundColor,
      )),
    ),
  );
}
