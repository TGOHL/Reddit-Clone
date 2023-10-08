import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../constants/assets.dart';
import '../constants/enums.dart';
import '../services/database.dart';
import '../widgets/arrow_group.dart';
import '../widgets/comment_tile.dart';
import '../widgets/menu_button.dart';
import '../widgets/time_player.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home-screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController _controller;
  late ScrollController _scrollController;
  bool _isAppBarExpanded = true;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);

    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..setLooping(true)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleScroll() {
    bool isAppBarExpanded = _scrollController.hasClients &&
        _scrollController.offset <
            MediaQuery.of(context).size.width / _controller.value.aspectRatio;
    if (isAppBarExpanded == _isAppBarExpanded) return;
    setState(() {
      _isAppBarExpanded = isAppBarExpanded;
      if (_isAppBarExpanded) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
            overlays: [SystemUiOverlay.top]);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService db = Provider.of<DatabaseService>(context);
    final post = db.post;
    final owner = db.getUserById(post.ownerId);
    if (!_controller.value.isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height,
            collapsedHeight: MediaQuery.of(context).size.width /
                _controller.value.aspectRatio,
            snap: true,
            floating: true,
            backgroundColor: Colors.black,
            flexibleSpace: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  Positioned(
                    top: 36,
                    left: 0,
                    right: 0,
                    child: Visibility(
                      visible: _isAppBarExpanded,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_back),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundImage: AssetImage(owner.imageUrl),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                "r/",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const Text("MechanicalKeyboards"),
                            ],
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.more_horiz),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: _isAppBarExpanded,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 10),
                              CircleAvatar(
                                radius: 14,
                                backgroundImage: AssetImage(owner.imageUrl),
                              ),
                              const SizedBox(width: 6),
                              Text(owner.name),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: _isAppBarExpanded,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 12, 80, 12),
                            child: Text(post.content),
                          ),
                        ),
                        TimePlayer(
                          controller: _controller,
                          isExtened: _isAppBarExpanded,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 66,
                    right: 0,
                    child: Visibility(
                      visible: _isAppBarExpanded,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ArrowGroup(
                              axis: ArrowGoupAxis.VERTICAL,
                              onChange: (delta) {
                                post.likesCount += delta;
                              },
                              likesCount: post.likesCount,
                            ),
                          ),
                          const SizedBox(height: 8),
                          IconButton(
                            onPressed: () {},
                            icon: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.chat_bubble_outline_rounded),
                                Text(post.commentsCount.toString()),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.file_upload_outlined),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.symmetric(vertical: 24),
              color: Colors.black,
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).size.width /
                      _controller.value.aspectRatio,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: db.comments.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: const Color(0xFF1B1B1B),
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text("SORT COMMENTS BY"),
                                  MenuButton(
                                    label: 'NEW',
                                    iconData: Icons.date_range,
                                    onTap: () {
                                      Navigator.of(context).pop();

                                      db.changeSortType(CommentSortType.NEW);
                                    },
                                  ),
                                  MenuButton(
                                    label: 'TOP',
                                    iconData: Icons.tornado_sharp,
                                    onTap: () {
                                      Navigator.of(context).pop();

                                      db.changeSortType(CommentSortType.TOP);
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white12),
                                        child: const Text(
                                          "Close",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8, left: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.sort),
                            Text(
                              db.sortType == CommentSortType.NEW
                                  ? 'NEW COMMNETS'
                                  : 'TOP COMMENTS',
                            ),
                          const   Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                    );
                  }
                  return CommentTile(
                    comment: db.comments[index - 1],
                    onCommentDeleted: (id) {
                      db.deleteComment(id);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
