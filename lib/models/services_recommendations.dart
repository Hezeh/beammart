import 'package:beammart/models/consumer_service_model.dart';

class ServicesRecommendations {
  List<Recommendations>? recommendations;
  String? recsId;

  ServicesRecommendations({this.recommendations, this.recsId});

  ServicesRecommendations.fromJson(Map<String, dynamic> json) {
    if (json['recommendations'] != null) {
      recommendations = [];
      json['recommendations'].forEach((v) {
        recommendations!.add(new Recommendations.fromJson(v));
      });
    }
    recsId = json['recsId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.recommendations != null) {
      data['recommendations'] =
          this.recommendations!.map((v) => v.toJson()).toList();
      data['recsId'] = this.recsId;
    }
    return data;
  }
}

class Recommendations {
  String? category;
  List<ConsumerServiceModel>? services;

  Recommendations({this.category, this.services});

  Recommendations.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    if (json['services'] != null) {
      services = [];
      json['services'].forEach((v) {
        services!.add(new ConsumerServiceModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
