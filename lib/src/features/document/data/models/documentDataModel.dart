import 'package:vrhaman/src/features/document/domain/entities/documentData.dart';

class DocumentDataModel  {
  final String document;
  DocumentDataModel({required this.document});


  factory DocumentDataModel.fromJson(Map<String, dynamic> json) {
    return DocumentDataModel( document: json['document']);
  }
}