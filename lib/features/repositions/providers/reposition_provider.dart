import 'package:cetis4/config/shared_provider/shared_providers.dart';
import 'package:cetis4/features/repositions/data/api/repositions_api.dart';
import 'package:cetis4/features/repositions/data/repository/repositions_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final repositionApiProvider = Provider<RepositionApi>((ref) {
  return RepositionApi(ref.read(dioClientProvider));
});

final repositionRepositoryProvider = Provider<RepositionRepository>((ref) {
  return RepositionRepository(ref.read(repositionApiProvider));
});
