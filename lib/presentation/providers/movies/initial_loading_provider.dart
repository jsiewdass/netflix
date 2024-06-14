import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

final initialLoadingProvider = Provider((ref) {
  final step1 = ref.watch(nowPlayingProvider).isEmpty;
  final step2 = ref.watch(moviesSlideshowProvider).isEmpty;
  final step3 = ref.watch(popularMoviesProvider).isEmpty;
  final step4 = ref.watch(upcomingMoviesProvider).isEmpty;
  final step5 = ref.watch(topRatedMoviesProvider).isEmpty;
  if (step1 || step2 || step3 || step4 || step5) return true;
  return false;
});
