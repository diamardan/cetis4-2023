import 'package:cetis4/config/shared_provider/shared_providers.dart';
import 'package:cetis4/features/grades/data/api/grades_api.dart';
import 'package:cetis4/features/grades/data/repository/grades_reposistory.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final gradeApiProvider = Provider<GradeApi>((ref) {
  return GradeApi(ref.read(dioClientProvider));
});

final gradeRepositoryProvider = Provider<GradeRepository>((ref) {
  return GradeRepository(ref.read(gradeApiProvider));
});
