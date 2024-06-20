import 'package:flutter/material.dart';

@immutable
class Category {
  final String idCategory;
  final String strCategory;
  final String strCategoryThumb;
  final String strCategoryDescription;

  const Category({
    required this.idCategory,
    required this.strCategory,
    required this.strCategoryThumb,
    required this.strCategoryDescription,
  });

  static Category fromJson(Map<String, dynamic> json) {
    return Category(
        idCategory: json['idCategory'],
        strCategory: json['strCategory'],
        strCategoryThumb: json['strCategoryThumb'],
        strCategoryDescription: json['strCategoryDescription']);
  }
}
