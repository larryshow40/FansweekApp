part of 'details_content_bloc.dart';

abstract class DetailsContentEvent extends Equatable {
  const DetailsContentEvent();

  @override
  List<Object> get props => [];
}

class GetDetailsContentEvent extends DetailsContentEvent {
  final int id;
  GetDetailsContentEvent({required this.id});
}
