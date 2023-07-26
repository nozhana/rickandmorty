import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rickandmorty/config/theme/app_themes.dart';
import 'package:rickandmorty/core/constants/constants.dart';
import 'package:rickandmorty/core/resources/views/error/empty_view.dart';
import 'package:rickandmorty/core/resources/views/error/error_view.dart';
import 'package:rickandmorty/core/resources/views/loading/loading_view.dart';
import 'package:rickandmorty/features/character/domain/entities/character_entity.dart';
import 'package:rickandmorty/features/character/presentation/bloc/character_bloc.dart';
import 'package:rickandmorty/features/character/presentation/widgets/gender_bottom_sheet.dart';
import 'package:rickandmorty/features/character/presentation/widgets/name_bottom_sheet.dart';
import 'package:rickandmorty/features/character/presentation/widgets/species_bottom_sheet.dart';
import 'package:rickandmorty/features/character/presentation/widgets/status_bottom_sheet.dart';
import 'package:rickandmorty/features/character/presentation/widgets/type_bottom_sheet.dart';
import 'package:rickandmorty/injection_container.dart';

part '../widgets/characters_grid_view.dart';
part '../widgets/character_list_snackbars.dart';

class CharacterListView extends StatefulWidget {
  final CharacterEvent initialEvent;
  const CharacterListView(
      {Key? key, this.initialEvent = const GetAllCharacters()})
      : super(key: key);

  @override
  State<CharacterListView> createState() => _CharacterListViewState();
}

class _CharacterListViewState extends State<CharacterListView> {
  final CharacterBloc _characterBloc = sl();
  final ScrollController _scrollController = ScrollController();
  final Set<CharacterEntity> _characterEntities = {};
  CharacterEntity _filterCharacterEntity = const CharacterEntity();
  int _page = 1;
  bool _showFab = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _characterBloc.add(widget.initialEvent);
  }

  @override
  void dispose() {
    _characterBloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CharacterBloc>(
      create: (context) => _characterBloc,
      child: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          switch (notification.direction) {
            case ScrollDirection.reverse:
            case ScrollDirection.forward:
              setState(() => _showFab = false);
              break;
            case ScrollDirection.idle:
              setState(() => _showFab = true);
              break;
          }
          return true;
        },
        child: Scaffold(
          appBar: _appBar(),
          body: _buildBody(),
          floatingActionButton: _filterFab(),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        "Characters",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget? _buildBody() {
    return BlocConsumer<CharacterBloc, CharacterState>(
      listener: (context, state) {
        if (state is CharactersDone || state is CharactersEmpty) {
          setState(() => _showFab = true);
        } else {
          setState(() => _showFab = false);
        }
      },
      builder: (context, state) {
        if (state is CharacterInitial || state is CharacterDone) {
          return Container();
        } else if (state is CharacterLoading) {
          return const LoadingView();
        } else if (state is CharactersDone) {
          _characterEntities.addAll(state.characterEntities!);
          if (state.info?.next != null) {
            _page = int.parse(RegExp(r'page=\d+')
                .firstMatch(state.info!.next!)![0]!
                .split("=")
                .last);
          }
          return charactersGridView(
              characterEntities: _characterEntities.toList(),
              context: context,
              controller: _scrollController);
        } else if (state is CharacterLoadingMore) {
          return charactersGridView(
            characterEntities: _characterEntities.toList(),
            context: context,
            controller: _scrollController,
            isLoading: true,
          );
        } else if (state is CharacterNonFatalError) {
          logger.error("‼️ ERROR! CharacterNonFatalError:", state.error);
          SchedulerBinding.instance.addPostFrameCallback((_) async {
            HapticFeedback.vibrate();
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(nonFatalErrorSnackbar(
                  error: state.error!,
                  characterBloc: _characterBloc,
                  page: _page,
                  filterCharacterEntity: _filterCharacterEntity));
          });
          return charactersGridView(
              characterEntities: _characterEntities.toList(),
              context: context,
              controller: _scrollController);
        } else if (state is CharacterError) {
          logger.error("‼️ ERROR! CharacterError:", state.error);
          return ErrorView(state.error);
        } else if (state is CharacterTimeoutError) {
          logger.error("‼️ ERROR! CharacterTimeoutError:", state.error);
          SchedulerBinding.instance.addPostFrameCallback((_) async {
            HapticFeedback.vibrate();
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(timeoutErrorSnackbar(
                  characterBloc: _characterBloc,
                  page: _page,
                  filterCharacterEntity: _filterCharacterEntity));
          });
          return charactersGridView(
              characterEntities: _characterEntities.toList(),
              context: context,
              controller: _scrollController);
        } else if (state is CharactersEmpty) {
          return const EmptyView();
        }
        throw UnimplementedError("Unimplemented CharacterState!");
      },
    );
  }

  Widget _filterFab() {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return SpeedDial(
          visible: _showFab,
          direction: (orientation == Orientation.portrait)
              ? SpeedDialDirection.up
              : SpeedDialDirection.left,
          animationCurve: Curves.elasticInOut,
          animatedIcon: AnimatedIcons.search_ellipsis,
          animatedIconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: theme().primaryColor,
          activeBackgroundColor: theme().primaryColorDark,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          label: const Text(
            "Filters",
            style: TextStyle(
                color: Colors.white,
                fontSize: 17.0,
                fontWeight: FontWeight.w600),
          ),
          spaceBetweenChildren: 16.0,
          onOpen: () => HapticFeedback.heavyImpact(),
          onClose: () => HapticFeedback.lightImpact(),
          children: <SpeedDialChild>[
            _speedDialChild(
                label: "Name",
                iconData: Icons.person,
                onTap: _getNameFromSheet),
            _speedDialChild(
                label: "Status",
                iconData: Icons.thumbs_up_down,
                onTap: _getStatusFromSheet),
            _speedDialChild(
                label: "Species",
                iconData: Icons.account_tree,
                onTap: _getSpeciesFromSheet),
            _speedDialChild(
                label: "Type",
                iconData: Icons.type_specimen,
                onTap: _getTypeFromSheet),
            _speedDialChild(
                label: "Gender",
                iconData: Icons.transgender,
                onTap: _getGenderFromSheet),
          ],
        );
      },
    );
  }

  SpeedDialChild _speedDialChild(
      {required String label, required IconData iconData, Function()? onTap}) {
    return SpeedDialChild(
      label: label,
      labelStyle: TextStyle(
          color: theme().primaryColorDark,
          fontWeight: FontWeight.w600,
          fontSize: 14.0),
      child: Icon(iconData, color: theme().primaryColorDark),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      onTap: () {
        HapticFeedback.mediumImpact();
        if (onTap != null) {
          onTap();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(comingSoonSnackbar());
        }
      },
    );
  }

  void _getNameFromSheet() async {
    final name =
        await NameBottomSheet(prefilledText: _filterCharacterEntity.name)
            .present(context);
    if (name != null) {
      _filterCharacterEntity = _filterCharacterEntity.copyWith(
          name: () => name.isEmpty ? null : name);
      _characterEntities.removeWhere((_) => true);
      _characterBloc
          .add(FilterCharacters(characterEntity: _filterCharacterEntity));
    }
  }

  void _getSpeciesFromSheet() async {
    final species =
        await SpeciesBottomSheet(prefilledText: _filterCharacterEntity.species)
            .present(context);
    if (species != null) {
      _filterCharacterEntity = _filterCharacterEntity.copyWith(
          species: () => species.isEmpty ? null : species);
      _characterEntities.removeWhere((_) => true);
      _characterBloc
          .add(FilterCharacters(characterEntity: _filterCharacterEntity));
    }
  }

  void _getTypeFromSheet() async {
    final type =
        await TypeBottomSheet(prefilledText: _filterCharacterEntity.type)
            .present(context);
    if (type != null) {
      _filterCharacterEntity = _filterCharacterEntity.copyWith(
          type: () => type.isEmpty ? null : type);
      _characterEntities.removeWhere((_) => true);
      _characterBloc
          .add(FilterCharacters(characterEntity: _filterCharacterEntity));
    }
  }

  void _getGenderFromSheet() async {
    final genderGetter =
        await GenderBottomSheet(selectedGender: _filterCharacterEntity.gender)
            .present(context);
    if (genderGetter != null) {
      _filterCharacterEntity =
          _filterCharacterEntity.copyWith(gender: () => genderGetter());
      _characterEntities.removeWhere((_) => true);
      _characterBloc
          .add(FilterCharacters(characterEntity: _filterCharacterEntity));
    }
  }

  void _getStatusFromSheet() async {
    final statusGetter =
        await StatusBottomSheet(selectedStatus: _filterCharacterEntity.status)
            .present(context);
    if (statusGetter != null) {
      _filterCharacterEntity =
          _filterCharacterEntity.copyWith(status: () => statusGetter());
      _characterEntities.removeWhere((_) => true);
      _characterBloc
          .add(FilterCharacters(characterEntity: _filterCharacterEntity));
    }
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge && _scrollController.offset != 0) {
      if (_characterBloc.state.info?.next == null) return;
      if (_filterCharacterEntity.hasValue) {
        _characterBloc.add(FilterMoreCharacters(
            characterEntity: _filterCharacterEntity, page: _page + 1));
      } else {
        _characterBloc.add(GetMoreCharacters(page: _page + 1));
      }
    }
  }
}
