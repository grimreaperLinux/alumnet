import 'package:alumnet/models/feed_post.dart';
import 'package:alumnet/screens/home/create_post_screen.dart';
import 'package:alumnet/widgets/feed_post.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<PostList>(context, listen: false).getPosts());
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() async {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      var postListProvider = Provider.of<PostList>(context, listen: false);
      if (postListProvider.hasMorePosts) {
        setState(() => _isLoadingMore = true);
        await Future.delayed(const Duration(seconds: 5));

        postListProvider.getPosts();
        setState(() => _isLoadingMore = false);
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            message: "No more posts are available.",
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<PostItem> postlist = Provider.of<PostList>(context).postList;
    List<Widget> postWidgets = postlist.map((post) => SocialCard(post: post)).toList();
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text(
                    "What's New",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, PostCreationScreen.routename).then(
                      (value) => {
                        showTopSnackBar(
                          Overlay.of(context),
                          const CustomSnackBar.success(
                            message: "Your Post has been created!",
                          ),
                        ),
                      },
                    );
                  },
                  icon: const Icon(Icons.add_box_rounded),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(children: [
                ...postWidgets,
                _isLoadingMore
                    ? Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.center,
                          child: LoadingAnimationWidget.waveDots(
                            color: Colors.black.withOpacity(0.5),
                            size: 50,
                          ),
                        ),
                      )
                    : const SizedBox()
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
