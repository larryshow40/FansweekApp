import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:onoo/src/data/model/post_details.dart';
import 'package:onoo/src/data/repository.dart';
part 'details_content_event.dart';
part 'details_content_state.dart';

class DetailsContentBloc
    extends Bloc<DetailsContentEvent, DetailsContentState> {
  final Repository repository;
  DetailsContentBloc({required this.repository})
      : super(DetailsContentLoadingState());

  @override
  Stream<DetailsContentState> mapEventToState(
    DetailsContentEvent event,
  ) async* {
    if (event is GetDetailsContentEvent) {
      yield DetailsContentLoadingState();
      try {
        PostDetails? postDetails =
            await repository.getPostDetails(id: event.id);
        if (postDetails != null) {
          yield DetailsContentLoadedSuccessState(postDetails: postDetails);
        } else {
          yield DetailsContentErrorState(
              message: "Can't load data for this post.");
        }
      } catch (e) {
        yield DetailsContentErrorState(message: e.toString());
      }
    }
  }
}
