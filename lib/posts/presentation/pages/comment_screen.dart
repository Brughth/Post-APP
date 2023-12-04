import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_app/posts/data/models/comment_model.dart';

import '../../data/models/post_model.dart';
import '../../data/repositories/post_repository.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({
    super.key,
    required this.post,
  });
  final PostModel post;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late PostRepository _postRepository;

  @override
  void initState() {
    _postRepository = PostRepository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          widget.post.title.toUpperCase(),
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
              ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _postRepository.getPostComments(postId: widget.post.id),
        builder:
            (BuildContext context, AsyncSnapshot<List<CommentModel>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.waiting:
              return const Center(
                child: CupertinoActivityIndicator(
                  radius: 50,
                ),
              );

            case ConnectionState.none:
              return Center(child: Text(snapshot.error.toString()));

            case ConnectionState.done:
              var postList = snapshot.data;
              if (postList == null) {
                return Center(
                  child: Text(
                    "No comments yet",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }
              return ListView.separated(
                itemCount: postList.length,
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemBuilder: (context, index) {
                  var comment = postList[index];
                  return ListTile(
                    title: Text(
                      comment.email,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    subtitle: Text(comment.body),
                  );
                },
              );

            default:
              return Container();
          }
        },
      ),
    );
  }
}
