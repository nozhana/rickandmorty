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
import 'package:rickandmorty/core/resources/widgets/snackbars/snackbars.dart';
import 'package:rickandmorty/features/episode/domain/entities/episode_entity.dart';
import 'package:rickandmorty/features/episode/presentation/bloc/episode_bloc.dart';
import 'package:rickandmorty/features/episode/presentation/widgets/episode_list_content_view.dart';
import 'package:rickandmorty/injection_container.dart';

part '../widgets/episode_list_snackbars.dart';

class EpisodeListView extends StatefulWidget {
  const EpisodeListView({Key? key, this.initialEvent = const GetAllEpisodes()})
      : super(key: key);

  final EpisodeEvent initialEvent;

  @override
  State<EpisodeListView> createState() => _EpisodeListViewState();
}

class _EpisodeListViewState extends State<EpisodeListView> {
  late final EpisodeBloc _episodeBloc;
  final _scrollController = ScrollController();
  final Set<EpisodeEntity> _episodeEntities = {};
  final EpisodeEntity _filterEpisodeEntity = const EpisodeEntity();
  int _page = 1;
  bool _showFab = false;

  @override
  void initState() {
    super.initState();
    _episodeBloc = sl()..add(widget.initialEvent);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        floatingActionButton: _buildSpeedDial(),
        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            switch (notification.direction) {
              case ScrollDirection.forward:
              case ScrollDirection.idle:
                setState(() => _showFab = true);
                break;
              case ScrollDirection.reverse:
                setState(() => _showFab = false);
                break;
            }
            return true;
          },
          child: BlocProvider<EpisodeBloc>(
              create: (context) => _episodeBloc,
              child: BlocConsumer<EpisodeBloc, EpisodeState>(
                listener: (context, state) {
                  if (state is EpisodeInitial ||
                      state is EpisodeLoading ||
                      state is EpisodeLoadingMore) {
                    SchedulerBinding.instance.addPostFrameCallback(
                        (_) => setState(() => _showFab = false));
                  } else {
                    SchedulerBinding.instance.addPostFrameCallback(
                        (_) => setState(() => _showFab = true));
                  }
                },
                builder: (context, state) =>
                    _buildEpisodeListViewBody(context, state),
              )),
        ));
  }

  Widget _buildEpisodeListViewBody(BuildContext context, EpisodeState state) {
    if (state is EpisodeInitial) {
      return Container();
    } else if (state is EpisodeLoading) {
      return const LoadingView();
    } else if (state is EpisodesDone) {
      _episodeEntities.addAll(state.episodeEntities ?? {});
      if (state.info?.next != null) {
        _page = (int.tryParse(RegExp(r"page=\d+")
                    .firstMatch(state.info!.next!)![0]!
                    .split("=")
                    .last) ??
                _page + 1) -
            1;
      }
      return EpisodeListContentView(
          episodeEntities: _episodeEntities.toList(),
          scrollController: _scrollController);
    } else if (state is EpisodesEmpty) {
      return const EmptyView();
    } else if (state is EpisodeLoadingMore) {
      return EpisodeListContentView(
          episodeEntities: _episodeEntities.toList(),
          scrollController: _scrollController,
          isLoading: true);
    } else if (state is EpisodeError) {
      return ErrorView(error: state.error);
    } else if (state is EpisodeNonFatalError) {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        HapticFeedback.vibrate();
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(nonFatalErrorSnackbar(
              error: state.error!, episodeBloc: _episodeBloc, page: _page));
      });
      return EpisodeListContentView(
          episodeEntities: _episodeEntities.toList(),
          scrollController: _scrollController);
    } else if (state is EpisodeTimeoutError) {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        HapticFeedback.vibrate();
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
              timeoutErrorSnackbar(episodeBloc: _episodeBloc, page: _page));
      });
      return EpisodeListContentView(
          episodeEntities: _episodeEntities.toList(),
          scrollController: _scrollController);
    }
    logger.error("Unexpected EpisodeState: ${state.runtimeType} - $state");
    return const ErrorView(errorMessage: "Unexpected state");
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        "Episodes",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge && _scrollController.offset != 0) {
      if (_episodeBloc.state.info?.next == null) return;

      setState(() {
        _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent + 80);
      });

      if (_filterEpisodeEntity.hasValue) {
        _episodeBloc.add(FilterMoreEpisodes(
            episodeEntity: _filterEpisodeEntity,
            page: _episodeEntities.isEmpty ? _page : _page + 1));
      } else {
        _episodeBloc.add(GetMoreEpisodes(
            page: _episodeEntities.isEmpty ? _page : _page + 1));
      }
    }
  }

  Widget _buildSpeedDial() => OrientationBuilder(
      builder: (context, orientation) => SpeedDial(
            visible: _showFab,
            backgroundColor: theme().primaryColor,
            animationCurve: Curves.elasticInOut,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            foregroundColor: Colors.white,
            activeBackgroundColor: theme().primaryColorDark,
            animatedIcon: AnimatedIcons.search_ellipsis,
            label: const Text("Filters",
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600)),
            direction: (orientation == Orientation.landscape)
                ? SpeedDialDirection.left
                : SpeedDialDirection.up,
            spaceBetweenChildren: 16.0,
            onOpen: () => HapticFeedback.heavyImpact(),
            onClose: () => HapticFeedback.lightImpact(),
            children: [
              _speedDialChild(label: "Name", iconData: Icons.text_format),
              _speedDialChild(label: "Season and Episode", iconData: Icons.tv),
            ],
          ));

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
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(comingSoonSnackbar());
        }
      },
    );
  }
}
