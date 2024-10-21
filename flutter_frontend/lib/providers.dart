import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_frontend/aws_auth.dart';

final authUserProvider = FutureProvider<String?>((ref) {
  // Watch the authAWSRepositoryProvider
  final authAWSRepo = ref.watch(authAWSRepositoryProvider);
  return authAWSRepo.user.then((value)=>value);
  // If authAWSRepo is not null, retrieve the user
});
final emailProvider = StateProvider<String>((ref) => '');



