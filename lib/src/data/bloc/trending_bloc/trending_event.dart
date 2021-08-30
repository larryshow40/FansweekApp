part of 'trending_bloc.dart';

abstract class TrendingEvent extends Equatable {
  const TrendingEvent();

  @override
  List<Object> get props => [];
}

class GetMoreTrendingPostEvent extends TrendingEvent {}

class GetTrendingPostsEvent extends TrendingEvent {}

class TrenndingPostLoadingEvent extends TrendingEvent {}

class TrendingPostErrorEvent extends TrendingEvent {}
