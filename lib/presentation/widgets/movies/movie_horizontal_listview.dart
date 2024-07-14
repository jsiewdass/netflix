import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';

import 'package:go_router/go_router.dart';

class MovieHorizontalListview extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNexPage;
  const MovieHorizontalListview({
    super.key,
    required this.movies,
    this.title,
    this.subTitle,
    this.loadNexPage,
  });

  @override
  State<MovieHorizontalListview> createState() =>
      _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (widget.loadNexPage == null) return;
      if ((scrollController.position.pixels + 200) >=
          scrollController.position.maxScrollExtent) {
        widget.loadNexPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          if (widget.title != null && widget.subTitle != null)
            _Title(title: widget.title, subTitle: widget.subTitle),
          Expanded(
              child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.movies.length,
                  itemBuilder: (context, index) {
                    return FadeInRight(
                        child: _Slide(movie: widget.movies[index]));
                  }))
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? subTitle;
  const _Title({this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    final colors = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if (title != null)
            Text(
              title!,
              style: titleStyle,
            ),
          const Spacer(),
          if (subTitle != null)
            FilledButton.tonal(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(colors),
                visualDensity: VisualDensity.compact,
              ),
              onPressed: () {},
              child: Text(
                subTitle!,
                style: titleStyle,
              ),
            )
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;
  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                width: 150,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return GestureDetector(
                      onTap: () => context.push('/home/0/movie/${movie.id}'),
                      child: FadeIn(child: child));
                },
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: 150,
            child: Text(
              movie.title,
              style: textStyle.titleSmall,
            ),
          ),
          SizedBox(
            width: 150,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.star_half_outlined,
                        color: Colors.yellow.shade800,
                      ),
                      const SizedBox(width: 5),
                      Text('${movie.voteAverage}', style: textStyle.bodyMedium),
                      const Spacer(),
                      const SizedBox(width: 10),
                      Text(HumanFormats.number(movie.popularity),
                          style: textStyle.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]));
  }
}
