import 'dart:convert';

import 'package:instagramz_flutter/api/models/meal.dart';
import 'package:http/http.dart' as http;
import 'package:instagramz_flutter/api/resources/constant.dart';

class ApiMethod {
  Future<MealModel> getRandomMeal() async {
    String url = apiRandomStr;
    final response = await http.get(Uri.parse(url));
    final Map<String, dynamic> json = jsonDecode(response.body);
    return MealModel.fromJson(json['meals'][0]);
  }
}
