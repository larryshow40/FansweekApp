part of 'video_bloc.dart';

abstract class VideoState extends Equatable {
  const VideoState();

  @override
  List<Object> get props => [];
}

class VideoContentLoadingState extends VideoState {}

class VideoContentLoadedSuccessState extends VideoState {
  final VideoContent videoContent;
  VideoContentLoadedSuccessState({required this.videoContent});

  VideoContent getVideoContent() {
    return videoContent;
  }

  @override
  List<Object> get props => [videoContent];
}

class VideoErrorState extends VideoState {
  final String message;
  VideoErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
