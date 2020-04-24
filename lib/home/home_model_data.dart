

class HomeModelData {
  String studio_name;
  String address_line1;
  String about_studio;

  HomeModelData(this.studio_name, this.address_line1, this.about_studio);

  factory HomeModelData.fromJson(dynamic json){
    return HomeModelData(
      json['studio_name'],
      json['address_line1'],
      json['about_studio']
    );
  }


}