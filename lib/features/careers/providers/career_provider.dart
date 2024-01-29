import 'package:cetis4/config/shared_provider/shared_providers.dart';
import 'package:cetis4/features/careers/data/api/career_api.dart';
import 'package:cetis4/features/careers/data/repository/career_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final careerApiProvider = Provider<CareerApi>((ref) {
  return CareerApi(ref.read(dioClientProvider));
});

final careerRepositoryProvider = Provider<CareerRepository>((ref) {
  return CareerRepository(ref.read(careerApiProvider));
});
