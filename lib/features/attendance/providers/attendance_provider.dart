import 'package:cetis4/config/shared_provider/shared_providers.dart';
import 'package:cetis4/features/attendance/data/api/attendance_api.dart';
import 'package:cetis4/features/attendance/data/repository/attendance_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final attendanceApiProvider = Provider<AttendanceApi>((ref) {
  return AttendanceApi(ref.read(dioClientProvider));
});

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return AttendanceRepository(ref.read(attendanceApiProvider));
});
