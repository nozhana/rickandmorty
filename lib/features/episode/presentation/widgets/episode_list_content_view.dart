import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rickandmorty/core/resources/widgets/snackbars/snackbars.dart';
import 'package:rickandmorty/features/episode/domain/entities/episode_entity.dart';

class EpisodeListContentView extends StatefulWidget {
  const EpisodeListContentView(
      {Key? key,
      required this.episodeEntities,
      this.isLoading = false,
      this.scrollController})
      : super(key: key);

  final List<EpisodeEntity> episodeEntities;
  final bool isLoading;
  final ScrollController? scrollController;

  @override
  State<EpisodeListContentView> createState() => _EpisodeListContentViewState();
}

class _EpisodeListContentViewState extends State<EpisodeListContentView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        // Main content
        child: ListView.builder(
          controller: widget.scrollController,
          shrinkWrap: true,
          itemCount: widget.episodeEntities.length + (widget.isLoading ? 1 : 0),
          itemExtent: 86.0,
          itemBuilder: (BuildContext context, int index) {
            if (index >= widget.episodeEntities.length) {
              return const SizedBox(
                height: 80,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                ),
              );
            }
            return Card(
              elevation: 0,
              color: Theme.of(context).canvasColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                onTap: () => SchedulerBinding.instance
                    .addPostFrameCallback((_) => ScaffoldMessenger.of(context)
                      ..clearSnackBars()
                      ..showSnackBar(comingSoonSnackbar(context))),
                enableFeedback: true,
                splashColor: Theme.of(context).splashColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title, Subtitle, Date
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              widget.episodeEntities[index].name ?? "Unknown",
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Subtitle
                            Text(
                              widget.episodeEntities[index].episode ?? "S??E??",
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.grey),
                            ),
                            // Date
                            Text(
                              widget.episodeEntities[index].airDate ??
                                  "Unknown air date",
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      // Trailing
                      Icon(Icons.arrow_forward_ios,
                          color: Theme.of(context).primaryColorDark),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
