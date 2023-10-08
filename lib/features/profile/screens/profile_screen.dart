import 'package:cetis4/utils/cache_image_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cetis4/features/profile/providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return SafeArea(
        child: Scaffold(
      body: Center(
        child: buildCacheNetworkImage(
            url: "https://drive.google.com/uc?id=${profile.studentPhotoPath}"),
      ),
    ));
  }
}
