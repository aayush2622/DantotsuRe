import 'package:blur/blur.dart';
import 'package:dantotsu/Functions/Extensions.dart';
import 'package:flutter/material.dart';
import 'package:kenburns_nullsafety/kenburns_nullsafety.dart';
import 'package:provider/provider.dart';

import '../../DataClass/Media.dart';
import '../../Theme/ThemeProvider.dart';
import '../../Widgets/CachedNetworkImage.dart';
import 'Tabs/Watch/WatchPage.dart';

class MediaInfoPage extends StatefulWidget {
  final media mediaData;

  const MediaInfoPage(this.mediaData, {super.key});

  @override
  MediaInfoPageState createState() => MediaInfoPageState();
}

class MediaInfoPageState extends State<MediaInfoPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildMediaSection()),
          SliverToBoxAdapter(child: _buildMediaDetails()),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child:  _buildSliverContent(),
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
  Widget _buildSliverContent() {
    return IndexedStack(
      index: _selectedIndex,
      children: [
        const SizedBox(),
        WatchPage(mediaData: widget.mediaData),
        const SizedBox(),
      ],
    );
  }
  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.info), label: 'INFO'),
        BottomNavigationBarItem(
            icon: Icon(Icons.movie_filter_rounded), label: 'WATCH'),
        BottomNavigationBarItem(icon: Icon(Icons.comment), label: 'COMMENTS'),
      ],
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index; // Update the selected tab index
        });
        // Handle tab changes accordingly
      },
    );
  }

  Widget _buildMediaDetails() {
    final mediaData = widget.mediaData;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: _buildMediaDetailsSpans(mediaData),
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              _buildFavoriteButton(),
              _buildShareButton(),
            ],
          ),
        ),
        // Add your ViewPager2 equivalent widget here
      ],
    );
  }

  List<TextSpan> _buildMediaDetailsSpans(media mediaData) {
    final List<TextSpan> spans = [];
    var theme = Theme.of(context).colorScheme;
    if (mediaData.userStatus != null) {
      spans.add(TextSpan(
        text: mediaData.anime != null ? "Watched " : "Read ",
      ));
      spans.add(TextSpan(
        text: "${mediaData.userProgress}",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: theme.secondary,
        ),
      ));
      spans.add(const TextSpan(text: " out of "));
    } else {
      spans.add(const TextSpan(text: "Total of "));
    }

    if (mediaData.anime != null) {
      if (mediaData.anime!.nextAiringEpisode != -1) {
        spans.add(TextSpan(
            text: "${mediaData.anime!.nextAiringEpisode}",
            style: TextStyle(
                color: theme.onSurface, fontWeight: FontWeight.bold)));
        spans.add(const TextSpan(
          text: " / ",
        ));
      }
      spans.add(TextSpan(
        text: "${mediaData.anime!.totalEpisodes ?? "??"}",
        style: TextStyle(color: theme.onSurface, fontWeight: FontWeight.bold),
      ));
    } else {
      spans.add(TextSpan(
        text: "${mediaData.manga!.totalChapters ?? "??"}",
        style: TextStyle(color: theme.onSurface, fontWeight: FontWeight.bold),
      ));
    }
    return spans;
  }

  Widget _buildFavoriteButton() {
    return IconButton(
      icon: widget.mediaData.isFav
          ? const Icon(Icons.favorite)
          : const Icon(Icons.favorite_border),
      iconSize: 32,
      onPressed: () {
        // Favorite action
      },
    );
  }

  Widget _buildShareButton() {
    return IconButton(
      icon: const Icon(Icons.share),
      iconSize: 32,
      onPressed: () {
        // Share action
      },
    );
  }



  Widget _buildMediaSection() {
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;
    final theme = Theme.of(context).colorScheme;
    final gradientColors = isDarkMode
        ? [Colors.transparent, theme.surface]
        : [Colors.white.withOpacity(0.2), theme.surface];

    return SizedBox(
      height: 384 + (0.statusBar() * 2),
      child: Stack(
        children: [
          KenBurns(
            maxScale: 2.5,
            minAnimationDuration: const Duration(milliseconds: 6000),
            maxAnimationDuration: const Duration(milliseconds: 20000),
            child: cachedNetworkImage(
              imageUrl: widget.mediaData.banner ?? widget.mediaData.cover ?? '',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 384 + (0.statusBar() * 2),
            ),
          ),
          Container(
            width: double.infinity,
            height: 384 + (0.statusBar() * 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Blur(
            colorOpacity: 0.0,
            blur: 10,
            blurColor: Colors.transparent,
            child: Container(),
          ),
          _buildCloseButton(theme),
          _buildCoverImage(theme),
          _buildAddToListButton(theme),
        ],
      ),
    );
  }

  Positioned _buildCloseButton(ColorScheme theme) {
    return Positioned(
      top: 14.statusBar(),
      right: 24,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Card(
          elevation: 7,
          color: theme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: 32,
            height: 32,
            child: Center(
              child: Icon(Icons.close, size: 24, color: theme.onSurface),
            ),
          ),
        ),
      ),
    );
  }

  Positioned _buildCoverImage(ColorScheme theme) {
    return Positioned(
      bottom: 64,
      left: 32,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: cachedNetworkImage(
              imageUrl: widget.mediaData.cover ?? '',
              fit: BoxFit.cover,
              width: 108,
              height: 160,
              placeholder: (context, url) => Container(
                color: Colors.white12,
                width: 108,
                height: 160,
              ),
            ),
          ),
          const SizedBox(width: 16),
          _buildMediaInfo(theme),
        ],
      ),
    );
  }

  Column _buildMediaInfo(ColorScheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.mediaData.userPreferredName,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          widget.mediaData.status?.replaceAll("_", " ") ?? "",
          style: TextStyle(
            fontSize: 14,
            color: theme.primary,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
      ],
    );
  }

  Positioned _buildAddToListButton(ColorScheme theme) {
    return Positioned(
      bottom: 0,
      left: 32,
      right: 32,
      height: 48,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          side: BorderSide(color: theme.onSurface),
          backgroundColor: Colors.transparent,
        ),
        child: Text(
          widget.mediaData.userStatus ?? 'ADD TO LIST',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: theme.secondary,
            letterSpacing: 1.25,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
