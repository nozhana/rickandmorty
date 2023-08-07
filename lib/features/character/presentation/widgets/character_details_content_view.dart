import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickandmorty/config/theme/app_themes.dart';
import 'package:rickandmorty/core/constants/constants.dart';
import 'package:rickandmorty/core/extensions/string_extension.dart';
import 'package:rickandmorty/core/resources/navigation/widgets/base_navigatable_scaffold.dart';
import 'package:rickandmorty/core/resources/views/error/error_view.dart';
import 'package:rickandmorty/core/resources/views/loading/loading_view.dart';
import 'package:rickandmorty/core/resources/widgets/snackbars/snackbars.dart';
import 'package:rickandmorty/features/character/domain/entities/types.dart';
import 'package:rickandmorty/features/character/presentation/bloc/character_bloc.dart';

class CharacterDetailsContentView extends StatelessWidget {
  const CharacterDetailsContentView({
    Key? key,
    required this.characterId,
  }) : super(key: key);

  final int characterId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterBloc, CharacterState>(
      builder: (context, state) {
        if (state is CharacterInitial) {
          return const Center(child: SizedBox.square(dimension: 20));
        } else if (state is CharacterDone) {
          return _buildContentListView(context, state);
        } else if (state is CharacterLoading) {
          return const LoadingView();
        } else if (state is CharacterTimeoutError) {
          _showTimeoutSnackbar(context, state);
          return const ErrorView(errorMessage: "Can't load Character details.");
        }
        logger.error("Unimplemented! $state; ${state.error}");
        throw UnimplementedError();
      },
    );
  }

  ListView _buildContentListView(BuildContext context, CharacterDone state) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 9,
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width >
                  BaseNavigatableScaffold.desktopBreakingPoint
              ? 140.0
              : 16.0,
          vertical: 8.0),
      itemBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return _buildCharacterImageTile(
                imageUrl: state.characterEntity?.image);
          case 1:
            return _buildCharacterNameTile(name: state.characterEntity?.name);
          case 2:
            return _buildCharacterInfoTile(
                title: state.characterEntity?.gender?.name,
                subtitle: "Gender",
                leadingIconData: state.characterEntity?.gender ==
                        CharacterGender.male
                    ? Icons.male
                    : state.characterEntity?.gender == CharacterGender.female
                        ? Icons.female
                        : state.characterEntity?.gender ==
                                CharacterGender.genderless
                            ? Icons.transgender
                            : Icons.question_mark);
          case 3:
            return _buildCharacterInfoTile(
                title: state.characterEntity?.status?.name,
                subtitle: "Status",
                leadingIconData:
                    state.characterEntity?.status == CharacterStatus.alive
                        ? Icons.person
                        : state.characterEntity?.status == CharacterStatus.dead
                            ? Icons.person_off
                            : Icons.question_mark);
          case 4:
            return _buildCharacterInfoTile(
                title: state.characterEntity?.location?.name,
                subtitle: "Last seen location",
                leadingIconData: Icons.location_on);
          case 5:
            return _buildCharacterInfoTile(
              title: state.characterEntity?.origin?.name,
              subtitle: "Location of origin",
              leadingIconData: Icons.location_city,
            );
          case 6:
            return _buildCharacterInfoTile(
                title: state.characterEntity?.species,
                subtitle: "Species",
                leadingIconData: Icons.account_tree);
          case 7:
            return _buildCharacterInfoTile(
                title: state.characterEntity?.type,
                subtitle: "Type",
                leadingIconData: Icons.type_specimen);
          case 8:
            return _buildCharacterInfoTile(
              title: "View all episodes",
              subtitle:
                  "Appeared in ${state.characterEntity?.episode?.length ?? "unknown number of"} ${((state.characterEntity?.episode?.length ?? 0) > 1) ? "episodes" : "episode"}",
              onTap: () {
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context)
                    .showSnackBar(comingSoonSnackbar());
              },
            );
          default:
            return Container();
        }
      },
    );
  }

  Widget _buildCharacterImageTile({required String? imageUrl}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      margin: const EdgeInsets.all(16.0),
      child: imageUrl?.isNotEmpty ?? false
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
              ),
            )
          : const SizedBox(
              height: 64,
              child: Center(
                child: Text(
                  "No Image",
                  style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600),
                ),
              ),
            ),
    );
  }

  Widget _buildCharacterNameTile({required String? name}) {
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          name?.firstUpper ?? "Unknown",
          style: const TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }

  Widget _buildCharacterInfoTile({
    required String? title,
    required String? subtitle,
    IconData? leadingIconData,
    IconData? trailingIconData,
    void Function()? onTap,
  }) {
    return ListTile(
      title: Text((title?.isNotEmpty ?? false) ? title!.firstUpper : "Unknown"),
      subtitle:
          (subtitle?.isNotEmpty ?? false) ? Text(subtitle!.firstUpper) : null,
      onTap: onTap,
      leading: leadingIconData != null
          ? Icon(
              leadingIconData,
              size: 36.0,
              color: theme().primaryColorDark,
            )
          : null,
      trailing: trailingIconData != null
          ? Icon(
              trailingIconData,
              size: 24.0,
              color: theme().primaryColorDark,
            )
          : onTap != null
              ? Icon(
                  Icons.arrow_forward_ios,
                  size: 24.0,
                  color: theme().primaryColorDark,
                )
              : null,
    );
  }

  void _showTimeoutSnackbar(BuildContext context, CharacterTimeoutError state) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(
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
            textColor: Theme.of(context).primaryColorLight,
            onPressed: () {
              final characterBloc = BlocProvider.of<CharacterBloc>(context);
              if (!characterBloc.isClosed) {
                characterBloc.add(GetCharacter(id: characterId));
              }
            },
          ),
        ));
    });
  }
}
