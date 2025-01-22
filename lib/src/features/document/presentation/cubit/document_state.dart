part of 'document_cubit.dart';

abstract class DocumentState {}

class DocumentInitial extends DocumentState {}

class DocumentLoading extends DocumentState {}

class DocumentUploaded extends DocumentState {
  final DocumentData documentData;

  DocumentUploaded(this.documentData);
}

class DocumentError extends DocumentState {
  final String message;

  DocumentError(this.message);
}
