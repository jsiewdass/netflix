import 'dart:async';

import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:animate_do/animate_do.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  List<Movie> initialMovies;
  final SearchMoviesCallback searchMovies;
  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer;
  SearchMovieDelegate({required this.initialMovies, required this.searchMovies})
      : super(
          searchFieldLabel: 'Buscar Películas',
          // textInputAction: TextInputAction.done
        );
  @override
  String get searchFieldLabel => 'Buscar pelicula';

  void _onQueryChange() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        isLoadingStream.add(false);
        debounceMovies.add([]);
        return;
      }
      isLoadingStream.add(true);
      final movies = await searchMovies(query);
      debounceMovies.add(movies);
      initialMovies = movies;
      isLoadingStream.add(false);
    });
  }

  void _clearStreams() {
    debounceMovies.close();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
          initialData: false,
          stream: isLoadingStream.stream,
          builder: (context, snapshot) {
            final isLoading = snapshot.data ?? false;
            return isLoading
                ? SpinPerfect(
                    infinite: true,
                    child: IconButton(
                        onPressed: () => query = '',
                        icon: const Icon(Icons.refresh_rounded)))
                : FadeIn(
                    animate: query.isNotEmpty,
                    child: IconButton(
                        onPressed: () => query = '',
                        icon: const Icon(Icons.clear)));
          })
      // if (query.isNotEmpty)
      // SpinPerfect(
      //     infinite: true,
      //     child: IconButton(
      //         onPressed: () => query = '',
      //         icon: const Icon(Icons.refresh_rounded))),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
        _clearStreams();
      },
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _onQueryChange();
    return _BuildResultAndSuggestions(
      initialMovies: initialMovies,
      debounceMovies: debounceMovies,
      close: close,
      clearStreams: _clearStreams,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChange();
    return _BuildResultAndSuggestions(
      initialMovies: initialMovies,
      debounceMovies: debounceMovies,
      close: close,
      clearStreams: _clearStreams,
    );
  }
}

class _BuildResultAndSuggestions extends StatelessWidget {
  final List<Movie> initialMovies;
  final StreamController debounceMovies;
  final Function close;
  final Function clearStreams;
  const _BuildResultAndSuggestions(
      {required this.initialMovies,
      required this.debounceMovies,
      required this.close,
      required this.clearStreams});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: initialMovies,
        stream: debounceMovies.stream,
        builder: (context, snapshot) {
          final movies = snapshot.data ?? [];
          return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return _MovieItem(
                  movie: movies[index],
                  onMovieSelected: (context, movie) {
                    close(context, movie);
                    clearStreams();
                  },
                );
              });
        });
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;
  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            //image
            SizedBox(
                width: size.width * 0.2,
                child: Image.network(
                  movie.posterPath,
                  loadingBuilder: (context, child, loadingProgress) =>
                      FadeIn(child: child),
                )),
            //description
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: textStyles.titleMedium,
                  ),
                  (movie.overview.length > 100)
                      ? Text('${movie.overview.substring(0, 100)}...')
                      : Text(movie.overview),
                  Row(
                    children: [
                      Icon(
                        Icons.star_half_rounded,
                        color: Colors.yellow.shade800,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        HumanFormats.number(movie.voteAverage, 1),
                        style: textStyles.bodyMedium!
                            .copyWith(color: Colors.yellow.shade900),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
