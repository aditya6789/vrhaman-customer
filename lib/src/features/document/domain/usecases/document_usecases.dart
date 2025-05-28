import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/features/document/data/models/documentDataModel.dart';
import 'package:vrhaman/src/features/document/domain/entities/documentData.dart';
import 'package:vrhaman/src/features/document/domain/repositories/document_repositories.dart';

class UploadDocumentUseCase {
  final DocumentRepository repository;

  UploadDocumentUseCase(this.repository);

  Future<Either<Failure, DocumentDataModel>> call(DocumentData documentData) async {
    return await repository.uploadDocument(documentData);
  }

  Future<Either<Failure, DocumentDataModel>> updateDocumentUseCase(DocumentData documentData) async {
    return await repository.updateDocument(documentData);
  }
}
