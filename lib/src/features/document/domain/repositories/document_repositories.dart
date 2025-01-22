import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/features/document/domain/entities/documentData.dart';

abstract interface class DocumentRepository {
  Future<Either<Failure, DocumentData>> uploadDocument(DocumentData documentData);
}