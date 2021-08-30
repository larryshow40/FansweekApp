part of 'home_content_bloc.dart';

@immutable
abstract class HomeContentState extends Equatable {}

class HomeContentLoadingState extends HomeContentState {
  @override
  List<Object?> get props => [];
}

class HomeContentCompletedState extends HomeContentState {
  final HomeContent homeContent;
  HomeContentCompletedState({required this.homeContent});

  HomeContent getHomeContentData() {
    return homeContent;
  }

  @override
  List<Object?> get props => [homeContent];
}

class HomeContentErrorState extends HomeContentState {
  final String message;
  HomeContentErrorState({required this.message});
  @override
  List<Object?> get props => [message];
}
