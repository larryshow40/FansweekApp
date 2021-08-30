part of 'author_bloc.dart';

abstract class AuthorState extends Equatable {
  const AuthorState();
  @override
  List<Object> get props => [];
}

class AuthorInitial extends AuthorState {}
class AuthorPostLoadingState extends AuthorState {}
class AuthorPostSuccessState extends AuthorState {
  final List<CommonPostModel> postList;
  final AuthorProfile profileData;
  AuthorPostSuccessState({required this.postList, required this.profileData});

  @override
  List<Object> get props => [postList];
}

class AuthorMorePostSuccessState extends AuthorState {
  final List<CommonPostModel> postList;
  AuthorMorePostSuccessState({required this.postList});

  @override
  List<Object> get props => [postList];
}

class AuthorPostErrorState extends AuthorState {
  final String message;
  AuthorPostErrorState({required this.message});
  @override
  List<Object> get props => [message];
}
