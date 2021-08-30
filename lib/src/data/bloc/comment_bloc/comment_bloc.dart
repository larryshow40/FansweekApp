import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:onoo/src/data/model/auth/onno_user.dart';
import 'package:onoo/src/data/model/comment/all_comments.dart';
import 'package:onoo/src/data/repository.dart';
import 'package:onoo/src/preferences/database_config.dart';
part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final Repository repository;
  CommentBloc({required this.repository}) : super(CommentLoadingState());

  @override
  Stream<CommentState> mapEventToState(
    CommentEvent event,
  ) async* {
    if (event is GetAllCommentEvent) {yield CommentLoadingState();//return loading state
      AllComments allComments = await Repository().getAllComments(postId: event.postId); //getting_all_comments_api
      yield GetCommentSuccessState(allComments: allComments); //return all comments
    } else if (event is PostCommentEvent) {
      yield CommentLoadingState();
      OnnoUser? user = DatabaseConfig().getOnooUser(); //user_from_local_storage
      if (user != null && user.token != null) {
        String response = await repository.postComment(postId: event.postId, comment: event.comment);
        yield CommentPostSuccessState(message: response);
      } else {
        yield CommentPostErrorState(message: "You have to login first");
      }
    }
  }
}
