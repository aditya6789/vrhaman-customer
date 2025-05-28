import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/features/document/data/data_sources/document_data_source.dart';
import 'package:vrhaman/src/features/document/data/models/documentDataModel.dart';
import 'package:vrhaman/src/features/document/domain/entities/documentData.dart';
import 'package:vrhaman/src/features/document/domain/repositories/document_repositories.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final DocumentDataSource dataSource;

  DocumentRepositoryImpl({required this.dataSource});

  @override
   Future<Either<Failure, DocumentDataModel>> uploadDocument(DocumentData documentData) async {
    try {
      final result = await dataSource.uploadDocument(documentData);
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DocumentDataModel>> updateDocument(DocumentData documentData) async {
    try {
      final result = await dataSource.updateDocument(documentData);
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
