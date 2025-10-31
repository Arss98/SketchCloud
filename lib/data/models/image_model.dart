import 'package:equatable/equatable.dart';

final class ImageModel extends Equatable {
  final String id;
  final String downloadUrl;
  final DateTime createdAt;

  const ImageModel({
    required this.id,
    required this.downloadUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}