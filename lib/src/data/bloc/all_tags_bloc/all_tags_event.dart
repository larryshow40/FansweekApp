part of 'all_tags_bloc.dart';

abstract class AllTagsEvent extends Equatable {
  const AllTagsEvent();
  @override
  List<Object> get props => [];
}

class GetAllTagsEvent extends AllTagsEvent {}
class AllTagsNoInternetEvent extends AllTagsEvent {}
