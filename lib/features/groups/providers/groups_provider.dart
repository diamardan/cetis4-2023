import 'package:cetis4/config/shared_provider/shared_providers.dart';
import 'package:cetis4/features/groups/data/api/groups_api.dart';
import 'package:cetis4/features/groups/data/repository/groups_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupApiProvider = Provider<GroupApi>((ref) {
  return GroupApi(ref.read(dioClientProvider));
});

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  return GroupRepository(ref.read(groupApiProvider));
});
