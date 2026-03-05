import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/user.dart';

final authStateProvider = StreamProvider<UserEntity?>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return repository.authStateChanges();
});