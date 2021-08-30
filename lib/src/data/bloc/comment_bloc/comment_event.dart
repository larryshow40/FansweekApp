part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object> get props => [];
}

class GetAllCommentEvent extends CommentEvent {
  final int postId;

  GetAllCommentEvent({required this.postId});
}

class PostCommentEvent extends CommentEvent {
  final int postId;
  final String comment;

  PostCommentEvent({required this.comment, required this.postId});
}
