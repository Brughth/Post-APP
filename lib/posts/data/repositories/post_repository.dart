import 'package:dio/dio.dart';
import 'package:post_app/posts/data/models/comment_model.dart';

import '../../../shared/const.dart';
import '../models/post_model.dart';

class PostRepository {
  final Dio dio = Dio(
    BaseOptions(),
  );

  Future<List<PostModel>?>? getPosts() async {
    try {
      Response response = await dio.get("$baseUrl/posts");
      var data = response.data;

      List<PostModel> posts = [];

      for (var item in data) {
        posts.add(PostModel.fromJson(item));
      }

      return posts;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<CommentModel>> getPostComments({required int postId}) async {
    Response response = await dio.get("$baseUrl/posts/$postId/comments");
    var comments = <CommentModel>[];

    for (var json in response.data) {
      comments.add(CommentModel.fromJson(json));
    }
    return comments;
  }
}
