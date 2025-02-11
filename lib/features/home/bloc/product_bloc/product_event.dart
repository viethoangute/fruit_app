import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable{
  @override
  List<Object> get props =>[];
}

class FetchProductsEvent extends ProductEvent {
  final String category;

  FetchProductsEvent({required this.category});
}