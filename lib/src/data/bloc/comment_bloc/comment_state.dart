part of 'comment_bloc.dart';

abstract class CommentState extends Equatable {
  const CommentState();
  @override
  List<Object> get props => [];
}

class CommentInitial extends CommentState {}
class CommentLoadingState extends CommentState {}
class CommentPostSuccessState extends CommentState {
  final String message;
  CommentPostSuccessState({required this.message});
  @override
  List<Object> get props => [message];
}

class GetCommentSuccessState extends CommentState {
  final AllComments allComments;
  GetCommentSuccessState({required this.allComments});
  @override
  List<Object> get props => [allComments];
}

class CommentPostErrorState extends CommentState {
  final String message;
  CommentPostErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class CommentErrorState extends CommentState {
  final String message;
  CommentErrorState({required this.message});
  @override
  List<Object> get props => [message];
}
