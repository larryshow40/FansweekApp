part of 'reply_bloc.dart';

abstract class ReplyState extends Equatable {
  const ReplyState();

  @override
  List<Object> get props => [];
}

class ReplyInitial extends ReplyState {}

class ReplyLoadingState extends ReplyState {}

class ReplyPostSuccessState extends ReplyState {
  final String message;
  ReplyPostSuccessState({required this.message});
  @override
  List<Object> get props => [message];
}

class GetReplySuccessState extends ReplyState {
  final ReplyModel replyModel;
  GetReplySuccessState({required this.replyModel});
  @override
  List<Object> get props => [replyModel];
}

class ReplyErrorState extends ReplyState {
  final String message;
  ReplyErrorState({required this.message});
  @override
  List<Object> get props => [message];
}
