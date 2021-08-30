part of 'home_content_bloc.dart';

@immutable
abstract class HomeContentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetHomeContentEvent extends HomeContentEvent {}
