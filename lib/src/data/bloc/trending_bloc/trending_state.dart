part of 'trending_bloc.dart';

abstract class TrendingState extends Equatable {}

class TrendingPostLoadingState extends TrendingState {
  @override
  List<Object?> get props => [];
}

class TrendingPostMoreLoadingState extends TrendingState {
  @override
  List<Object?> get props => [];
}

class TrendingSuccessState extends TrendingState {
  final List<CommonPostModel> postList;
  TrendingSuccessState({required this.postList});
  List<CommonPostModel> getTrendingPosts() {
    return postList;
  }

  @override
  List<Object?> get props => [postList];
}

class TrendingErrorState extends TrendingState {
  final String message;
  TrendingErrorState({required this.message});
  @override
  List<Object?> get props => [message];
}
