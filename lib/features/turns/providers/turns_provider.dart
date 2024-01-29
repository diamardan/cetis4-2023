import 'package:cetis4/config/shared_provider/shared_providers.dart';
import 'package:cetis4/features/turns/data/api/turns_api.dart';
import 'package:cetis4/features/turns/data/repository/turns_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final turnApiProvider = Provider<TurnApi>((ref) {
  return TurnApi(ref.read(dioClientProvider));
});

final turnRepositoryProvider = Provider<TurnRepository>((ref) {
  return TurnRepository(ref.read(turnApiProvider));
});
