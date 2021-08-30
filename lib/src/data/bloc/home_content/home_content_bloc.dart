import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:onoo/src/data/model/home_content/home_content.dart';
import 'package:onoo/src/data/repository.dart';
part 'home_content_event.dart';
part 'home_content_state.dart';

class HomeContentBloc extends Bloc<HomeContentEvent, HomeContentState> {
  final Repository repository;
  HomeContentBloc({required this.repository})
      : super(HomeContentLoadingState());

  @override
  Stream<HomeContentState> mapEventToState(
    HomeContentEvent event,
  ) async* {
    if (event is GetHomeContentEvent) {
      yield HomeContentLoadingState();
      try {
        HomeContent? homeContent = await repository.getHomeContent();
        if (homeContent != null) {
          yield HomeContentCompletedState(homeContent: homeContent);
        } else {
          yield HomeContentErrorState(message: "Data loading failed.");
        }
      } catch (e) {
        yield HomeContentErrorState(message: e.toString());
      }
    }
  }
}
