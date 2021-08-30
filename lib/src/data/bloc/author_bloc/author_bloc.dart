import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:onoo/src/data/model/author/author_post_model.dart';
import 'package:onoo/src/data/model/author/author_profile.dart';
import 'package:onoo/src/data/model/common/common_post.dart';
import 'package:onoo/src/data/repository.dart';
part 'author_event.dart';
part 'author_state.dart';

class AuthorBloc extends Bloc<AuthorEvent, AuthorState> {
  AuthorBloc() : super(AuthorInitial());
  int _page = 1;

  @override
  Stream<AuthorState> mapEventToState(
    AuthorEvent event,
  ) async* {
    if (event is GetMoreAuthorPostEvent) {
      try {
        _page++;
        AuthorPostModel postModel = await Repository().getPostDataByAuthorId(authorId: event.authorId, pageNumber: _page);
        List<CommonPostModel> posts = postModel.data;
        yield AuthorMorePostSuccessState(postList: posts);
      } catch (e) {
        yield AuthorPostErrorState(message: "Data loading error.");
      }
    } else if (event is GetAuthorPostEvent) {
      yield AuthorPostLoadingState();
      try {
        //first load profile data
        AuthorProfile profile = await Repository().getAuthorProfile(authorId: event.authorId);
        _page++;
        AuthorPostModel postModel = await Repository().getPostDataByAuthorId(authorId: event.authorId, pageNumber: _page);
        List<CommonPostModel> posts = postModel.data;
        yield AuthorPostSuccessState(postList: posts, profileData: profile);
      } catch (e) {
        yield AuthorPostErrorState(message: "Data loading error.");
      }
    }
  }
}
