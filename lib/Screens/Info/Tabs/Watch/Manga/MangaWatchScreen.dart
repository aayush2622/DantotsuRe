import 'package:dantotsu/Screens/Info/Tabs/Watch/BaseParser.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../DataClass/Media.dart';
import '../BaseWatchScreen.dart';
import 'MangaParser.dart';

class MangaWatchScreen extends StatefulWidget {
  final media mediaData;

  const MangaWatchScreen({super.key, required this.mediaData});

  @override
  MangaWatchScreenState createState() => MangaWatchScreenState();
}

class MangaWatchScreenState extends BaseWatchScreen<MangaWatchScreen> {
  late MangaParser _viewModel;

  @override
  media get mediaData => widget.mediaData;

  @override
  BaseParser get viewModel => _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Get.put(MangaParser(), tag: widget.mediaData.id.toString());
    widget.mediaData.selected = _viewModel.loadSelected(widget.mediaData);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.reset();
    });
  }

  @override
  get widgetList => [];

  
}