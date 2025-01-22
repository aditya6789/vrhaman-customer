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
   Future<Either<Failure, DocumentData>> uploadDocument(DocumentData documentData) async {
    try {
      final result = await dataSource.uploadDocument(DocumentDataModel(image: documentData.image)); // Replace 'some_id' with the actual id
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
