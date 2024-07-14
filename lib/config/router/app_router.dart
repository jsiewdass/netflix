import 'package:go_router/go_router.dart';
import 'package:cinemapedia/presentation/screens/screens.dart';

final appRouter = GoRouter(initialLocation: '/home/0', routes: [
  GoRoute(
      path: '/home/:page',
      name: HomeScreen.name,
      builder: (context, state) {
        int pageIndex = int.parse(state.pathParameters['page'] ?? '0');
        pageIndex = pageIndex > 2 || pageIndex < 0 ? 0 : pageIndex;
        return HomeScreen(
          page: pageIndex,
        );
      },
      routes: [
        GoRoute(
            path: 'movie/:id',
            name: MovieScreen.name,
            builder: (context, state) => MovieScreen(
                  movieId: state.pathParameters['id'] ?? 'no-id',
                ))
      ]),
  GoRoute(
    path: '/',
    redirect: (_, __) => '/home/0',
  )
]);
