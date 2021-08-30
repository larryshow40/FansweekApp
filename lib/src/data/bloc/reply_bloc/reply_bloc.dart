import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:onoo/src/data/model/comment/reply_model.dart';
import 'package:onoo/src/data/repository.dart';
part 'reply_event.dart';
part 'reply_state.dart';

class ReplyBloc extends Bloc<ReplyEvent, ReplyState> {
  ReplyBloc() : super(ReplyInitial());

  @override
  Stream<ReplyState> mapEventToState(
    ReplyEvent event,
  ) async* {
    if (event is GetAllReplyEvent) {
      yield ReplyLoadingState();
      ReplyModel replyModel =
          await Repository().getAllReplies(commentId: event.commetnId);
      yield GetReplySuccessState(replyModel: replyModel);
    } else if (event is PostReplyEvent) {
      yield ReplyLoadingState();
      bool isSuccess = await Repository().postReply(
          postId: event.postId,
          commentId: event.commentId,
          reply: event.reply,
          token: event.token);
      if (isSuccess) {
        yield ReplyPostSuccessState(message: "Reply Posted");
      } else {
        yield ReplyErrorState(message: "Failed to post reply");
      }
    }
  }
}
