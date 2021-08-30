part of 'author_bloc.dart';

abstract class AuthorEvent extends Equatable {
  const AuthorEvent();

  @override
  List<Object> get props => [];
}

class GetAuthorPostEvent extends AuthorEvent {
  final int authorId;
  GetAuthorPostEvent({required this.authorId});
}

class GetMoreAuthorPostEvent extends AuthorEvent {
  final int authorId;
  GetMoreAuthorPostEvent({required this.authorId});
}
