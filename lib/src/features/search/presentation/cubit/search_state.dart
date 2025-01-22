part of 'search_cubit.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final AddSearch search;

  SearchLoaded(this.search);
}
class SearchLoadedData extends SearchState {
  final List<SearchData> search;

  SearchLoadedData(this.search);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}
