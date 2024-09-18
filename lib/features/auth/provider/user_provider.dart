import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_youtube_clone/features/auth/model/user_model.dart';
import 'package:flutter_youtube_clone/features/auth/repository/user_data_service.dart';

final currentUserProvider = FutureProvider((ref) async {
  final UserModel user =
      await ref.watch(userDataServiceProvider).fetchCurrentUserData();
  return user;
});

final anyUserDataProvider = FutureProvider.family((ref, String userId) async {
  final UserModel user =
      await ref.watch(userDataServiceProvider).fetchAnyUserData(userId);
  return user;
});
