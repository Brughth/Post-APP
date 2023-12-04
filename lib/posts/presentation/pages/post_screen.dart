import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_app/posts/presentation/pages/comment_screen.dart';

import '../../data/models/post_model.dart';
import '../../data/repositories/post_repository.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
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
          "Post APP",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
              ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _postRepository.getPosts(),
        builder:
            (BuildContext context, AsyncSnapshot<List<PostModel>?> snapshot) {
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
                  "Aucun post pour le moment",
                  style: Theme.of(context).textTheme.bodyLarge,
                ));
              }
              return ListView.separated(
                itemCount: postList.length,
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemBuilder: (context, index) {
                  var post = postList[index];
                  return ListTile(
                    title: Text(
                      post.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    subtitle: Text(post.body),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return CommentScreen(
                            post: post,
                          );
                        }),
                      );
                    },
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
