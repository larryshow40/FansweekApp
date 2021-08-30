part of 'details_content_bloc.dart';

abstract class DetailsContentState extends Equatable {
  const DetailsContentState();

  @override
  List<Object> get props => [];
}

class DetailsContentLoadingState extends DetailsContentState {}

class DetailsContentLoadedSuccessState extends DetailsContentState {
  final PostDetails postDetails;
  DetailsContentLoadedSuccessState({required this.postDetails});
  @override
  List<Object> get props => [postDetails];
}

class DetailsContentErrorState extends DetailsContentState {
  final String message;
  DetailsContentErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
