import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/features/document/data/models/documentDataModel.dart';
import 'package:vrhaman/src/features/document/domain/entities/documentData.dart';
import 'package:vrhaman/src/features/document/domain/usecases/document_usecases.dart';

part 'document_state.dart';

class DocumentCubit extends Cubit<DocumentState> {
  final UploadDocumentUseCase uploadDocumentUseCase;

  DocumentCubit({required this.uploadDocumentUseCase}) : super(DocumentInitial());

  Future<void> uploadDocument(DocumentData documentData) async {
    emit(DocumentLoading());
    final failureOrSuccess = await uploadDocumentUseCase(documentData);
    failureOrSuccess.fold(
      (failure) => emit(DocumentError(_mapFailureToMessage(failure))),
      (documentData) => emit(DocumentUploaded(documentData)),
    );
  }

  Future<void> updateDocument(DocumentData documentData) async {
    emit(DocumentLoading());
    final failureOrSuccess = await uploadDocumentUseCase.updateDocumentUseCase(documentData);
    failureOrSuccess.fold(
      (failure) => emit(DocumentError(_mapFailureToMessage(failure))),
      (documentData) => emit(DocumentUploaded(documentData)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    // Customize error messages based on the type of failure
    return failure.message;
  }
}
