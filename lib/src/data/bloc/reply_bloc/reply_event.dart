part of 'reply_bloc.dart';

abstract class ReplyEvent extends Equatable {
  const ReplyEvent();

  @override
  List<Object> get props => [];
}

class GetAllReplyEvent extends ReplyEvent {
  final int commetnId;
  GetAllReplyEvent({required this.commetnId});
}

class PostReplyEvent extends ReplyEvent {
  final int postId;
  final int commentId;
  final String reply;
  final String token;

  PostReplyEvent(
      {required this.postId,
      required this.commentId,
      required this.reply,
      required this.token});
}
