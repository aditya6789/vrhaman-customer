import 'package:vrhaman/src/features/document/domain/entities/documentData.dart';

class DocumentDataModel extends DocumentData {
  DocumentDataModel({required super.image});

  factory DocumentDataModel.fromJson(Map<String, dynamic> json) {
    return DocumentDataModel(image: json['document']);
  }
}