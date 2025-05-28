import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/features/document/data/models/documentDataModel.dart';
import 'package:vrhaman/src/features/document/domain/entities/documentData.dart';

abstract interface class DocumentRepository {
  Future<Either<Failure, DocumentDataModel>> uploadDocument(DocumentData documentData);
  Future<Either<Failure, DocumentDataModel>> updateDocument(DocumentData documentData);
}