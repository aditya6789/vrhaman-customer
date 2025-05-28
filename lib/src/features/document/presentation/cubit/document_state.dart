part of 'document_cubit.dart';

abstract class DocumentState {}

class DocumentInitial extends DocumentState {}

class DocumentLoading extends DocumentState {}

class DocumentUploaded extends DocumentState {
  final DocumentDataModel documentDataModel;

  DocumentUploaded(this.documentDataModel);
}

class DocumentError extends DocumentState {
  final String message;

  DocumentError(this.message);
}
