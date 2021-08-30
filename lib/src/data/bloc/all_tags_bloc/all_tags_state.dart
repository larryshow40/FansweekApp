part of 'all_tags_bloc.dart';

abstract class AllTagsState extends Equatable {}
//loading state
class AllTagsLoadingState extends AllTagsState {
  @override
  List<Object?> get props => [];
}
//sucess state
class AllTagsSuccessState extends AllTagsState {
  final AllTags allTags;
  AllTagsSuccessState({required this.allTags});
  AllTags getAllTagsData() {
    return allTags;
  }
  @override
  List<Object?> get props => [allTags];
}

//error state
class AllTagsErrorState extends AllTagsState {
  final String message;
  AllTagsErrorState({required this.message});
  @override
  List<Object?> get props => [message];
}

class AllTagsNoInternetState extends AllTagsState {
  @override
  List<Object?> get props => [];
}
