import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/features/document/domain/entities/documentData.dart';
import 'package:vrhaman/src/features/document/domain/repositories/document_repositories.dart';

class UploadDocumentUseCase {
  final DocumentRepository repository;

  UploadDocumentUseCase(this.repository);

  Future<Either<Failure, DocumentData>> call(DocumentData documentData) async {
    return await repository.uploadDocument(documentData);
  }
}
