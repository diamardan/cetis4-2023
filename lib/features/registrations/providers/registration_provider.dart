import 'package:cetis4/config/shared_provider/shared_providers.dart';
import 'package:cetis4/features/registrations/data/api/registration_api.dart';
import 'package:cetis4/features/registrations/data/repository/registration_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final registrationApiProvider = Provider<RegistrationApi>((ref) {
  return RegistrationApi(ref.read(dioClientProvider));
});

final registrationRepositoryProvider = Provider<RegistrationRepository>((ref) {
  return RegistrationRepository(ref.read(registrationApiProvider));
});
