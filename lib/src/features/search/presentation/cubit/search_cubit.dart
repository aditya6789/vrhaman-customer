import 'package:bloc/bloc.dart';
import 'package:vrhaman/src/core/model/common_vehicle.dart';
import 'package:vrhaman/src/features/search/domain/entities/searchdata.dart';
import 'package:vrhaman/src/features/search/domain/usecases/search_usecases.dart';
import 'package:vrhaman/src/features/search/domain/entities/addSearch.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final AddSearchUseCase addSearchUseCase;

  SearchCubit({required this.addSearchUseCase}) : super(SearchInitial());

  Future<Either<Failure, List<SearchData>>> addSearch(AddSearch addSearch) async {
    emit(SearchLoading());
    final failureOrSearch = await addSearchUseCase(addSearch);
    return failureOrSearch.fold(
      (failure) {
        emit(SearchError(failure.message));
        return Left(failure);
      },
      (search) {
        emit(SearchLoadedData(search));
        return Right(search);
      },
    );
  }

  Future<void> reset() async {
    await Future.delayed(Duration(seconds: 5));
    emit(SearchInitial());
  }
}
