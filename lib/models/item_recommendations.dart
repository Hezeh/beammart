import 'package:beammart/models/item.dart';

class ItemRecommendations {
  List<Recommendations> recommendations;
  String recsId;

  ItemRecommendations({this.recommendations, this.recsId});

  ItemRecommendations.fromJson(Map<String, dynamic> json) {
    if (json['recommendations'] != null) {
      recommendations = [];
      json['recommendations'].forEach((v) {
        recommendations.add(new Recommendations.fromJson(v));
      });
    }
    recsId = json['recsId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.recommendations != null) {
      data['recommendations'] =
          this.recommendations.map((v) => v.toJson()).toList();
      data['recsId'] = this.recsId;
    }
    return data;
  }
}

class Recommendations {
  String category;
  List<Item> items;

  Recommendations({this.category, this.items});

  Recommendations.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items.add(new Item.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
