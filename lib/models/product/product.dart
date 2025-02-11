import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product extends Equatable with _$Product{
  const Product._();
  @JsonSerializable(explicitToJson: true)

  const factory Product({
    required String id,
    required String name,
    required String category,
    required String title,
    required String description,
    required String unit,
    required double dolar,
    required List<String> images
  }) = _Product;

  factory Product.fromJson(Map<String, Object?> json) => _$ProductFromJson(json);

  factory Product.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Product(
      id: data?['id'],
      name: data?['name'],
      category: data?['category'],
      title: data?['title'],
      description: data?['description'],
      unit: data?['unit'],
      dolar: data?['dolar'],
      images: data?['images'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": name,
      "name": name,
      "category": category,
      "title": title,
      "description": description,
      "unit": unit,
      "dolar": dolar,
      "images": images,
    };
  }

  @override
  List<String> get props => [id];
}