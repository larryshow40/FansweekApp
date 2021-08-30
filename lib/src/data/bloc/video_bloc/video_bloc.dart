import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:onoo/src/data/model/video_content.dart';
import 'package:onoo/src/data/repository.dart';
part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final Repository repository;
  VideoBloc({required this.repository}) : super(VideoContentLoadingState());

  @override
  Stream<VideoState> mapEventToState(
    VideoEvent event,
  ) async* {
    if (event is GetVideoDataEvent) {
      yield VideoContentLoadingState();
      try {
        VideoContent? videoContent = await repository.getVideoContent();
        if (videoContent != null) {
          yield VideoContentLoadedSuccessState(videoContent: videoContent);
        } else {
          yield VideoErrorState(message: "Data loading failed");
        }
      } catch (e) {
        yield VideoErrorState(message: e.toString());
      }
    }
  }
}
