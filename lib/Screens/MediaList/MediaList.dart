import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/Anilist/Anilist.dart';
import 'MediaListViewModel.dart';
import 'MediaListTabs.dart';

class MediaListScreen extends StatefulWidget {
  final bool anime;

  const MediaListScreen({super.key, required this.anime});

  @override
  MediaListScreenState createState() => MediaListScreenState();
}

class MediaListScreenState extends State<MediaListScreen> {
  final _viewModel = Get.put(MediaListViewModel());

  @override
  void initState() {
    super.initState();
    _viewModel.loadAll(anime: widget.anime, userId: Anilist.userid ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          Anilist.username.value ?? '',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: theme.primary,
          ),
        ),
        iconTheme: IconThemeData(color: theme.primary),

      ),
      body: Obx(() {
        if (_viewModel.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_viewModel.listImages.value == null || _viewModel.listImages.value!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        return MediaListTabs(viewModel: _viewModel);
      }),
    );
  }
}