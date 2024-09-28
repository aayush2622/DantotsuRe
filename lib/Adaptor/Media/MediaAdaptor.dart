import 'dart:async';

import 'package:dantotsu/Adaptor/Media/MediaLargeViewHolder.dart';
import 'package:dantotsu/Functions/Extensions.dart';
import 'package:flutter/material.dart';

import '../../Animation/ScaleAnimation.dart';
import '../../DataClass/Media.dart';
import '../../Functions/Function.dart';
import '../../Screens/Info/MediaScreen.dart';
import '../../Screens/Settings/SettingsBottomSheet.dart';
import '../../Widgets/ScrollConfig.dart';
import 'MediaPageSmallViewHolder.dart';
import 'MediaViewHolder.dart';

class MediaAdaptor extends StatefulWidget {
  final int type;
  final List<media> mediaList;

  const MediaAdaptor({super.key, required this.type, required this.mediaList});

  @override
  MediaGridState createState() => MediaGridState();
}

class MediaGridState extends State<MediaAdaptor> {
  late List<media> _mediaList;

  @override
  void initState() {
    super.initState();
    _mediaList = widget.mediaList;
  }

  @override
  void didUpdateWidget(covariant MediaAdaptor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mediaList != widget.mediaList) {
      setState(() {
        _mediaList = widget.mediaList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case 0:
        return _buildGridLayout();
      case 1:
        return LargeView(mediaList: _mediaList);
      case 2:
        return _buildListLayout();
      default:
        return const SizedBox();
    }
  }
  Widget _buildListLayout() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: double.infinity
        ),
        child: SingleChildScrollView(
          child: Column(
            children: _mediaList.map((m) {
              return SlideAndScaleAnimation(
                initialScale: 0.0,
                finalScale: 1.0,
                initialOffset: const Offset(1.0, 0.0),
                finalOffset: Offset.zero,
                duration: const Duration(milliseconds: 200),
                child: GestureDetector(
                  onTap: () => navigateToPage(context, MediaInfoPage(m)),
                  onLongPress: () => settingsBottomSheet(context),
                  child: Container(
                    width: double.maxFinite,
                    margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                    child: MediaPageLargeViewHolder(m),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
  Widget _buildGridLayout() {
    return SizedBox(
      height: 250,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: ScrollConfig(
          context,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _mediaList.length,
            itemBuilder: (context, index) {
              final isFirst = index == 0;
              final isLast = index == _mediaList.length - 1;
              final margin = EdgeInsets.only(
                left: isFirst ? 24.0 : 6.5,
                right: isLast ? 24.0 : 6.5,
              );
              return SlideAndScaleAnimation(
                initialScale: 0.0,
                finalScale: 1.0,
                initialOffset: const Offset(1.0, 0.0),
                finalOffset: Offset.zero,
                duration: const Duration(milliseconds: 200),
                child: GestureDetector(
                  onTap: () => navigateToPage(context, MediaInfoPage(_mediaList[index])),
                  onLongPress: () => settingsBottomSheet(context),
                  child: Container(
                    width: 102,
                    margin: margin,
                    child: MediaViewHolder(mediaInfo: _mediaList[index]),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class LargeView extends StatefulWidget {
  final List<media> mediaList;

  const LargeView({super.key, required this.mediaList});

  @override
  LargeViewState createState() => LargeViewState();
}

class LargeViewState extends State<LargeView> {
  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_pageController.hasClients) {
        final page = _pageController.page?.toInt() ?? 0;
        final nextPage = (page + 1) % widget.mediaList.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 464 + (0.statusBar() * 2),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: ScrollConfig(
          context,
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.mediaList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () =>
                    navigateToPage(context, MediaInfoPage(widget.mediaList[index])),
                onLongPress: () => settingsBottomSheet(context),
                child: MediaPageSmallViewHolder(widget.mediaList[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}
