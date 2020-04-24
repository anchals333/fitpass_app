

import 'package:fitpass_app/home/home_model_data.dart';

class HomeModel{
  String message;
  int  results;
  List<HomeModelData> data;

  HomeModel(this.message, this.results, this.data);

  factory HomeModel.fromJson(dynamic json){
    var jsonData = json['data'] as List;
    List<HomeModelData> list = jsonData.map((value) => HomeModelData.fromJson(value)).toList();

    return HomeModel(json['message'], json['results'], list);
  }


}