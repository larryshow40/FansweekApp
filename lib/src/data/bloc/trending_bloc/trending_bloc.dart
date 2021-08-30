import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:onoo/src/data/model/common/common_post.dart';
import 'package:onoo/src/data/repository.dart';
part 'trending_event.dart';
part 'trending_state.dart';

class TrendingBloc extends Bloc<TrendingEvent, TrendingState> {
  final Repository repository;
  TrendingBloc({required this.repository}) : super(TrendingPostLoadingState());
  int _page = 1;

  @override
  Stream<TrendingState> mapEventToState(
    TrendingEvent event,
  ) async* {
    if (event is GetMoreTrendingPostEvent) {
      //yield TrendingPostMoreLoadingState();
      try {
        _page++;
        List<CommonPostModel> posts =
            await repository.getTrendingPosts(pageNumber: _page);
        // print("-----------more loading page: $_page, length: ${posts.length}");
        yield TrendingSuccessState(postList: posts);
      } catch (e) {
        yield TrendingErrorState(message: "Data loading error");
      }
    } else if (event is GetTrendingPostsEvent) {
      yield TrendingPostLoadingState();
      try {
        _page = 1;
        List<CommonPostModel> posts =
            await repository.getTrendingPosts(pageNumber: _page);
        //  print(
        //    "-----------first time loading page: $_page, length: ${posts.length}");
        yield TrendingSuccessState(postList: posts);
      } catch (e) {
        yield TrendingErrorState(message: "Data loading error");
      }
    } else if (event is TrendingPostErrorEvent) {
      yield TrendingErrorState(message: "Data loading state.");
    }
  }
}
