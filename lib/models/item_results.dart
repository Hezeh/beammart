import 'package:beammart/models/item.dart';

class ItemResults {
  List<Item> items;
  Bounds bounds;

  ItemResults({this.items, this.bounds});

  ItemResults.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<Item>();
      json['items'].forEach((v) {
        items.add(new Item.fromJson(v));
      });
    }
    bounds =
        json['bounds'] != null ? new Bounds.fromJson(json['bounds']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    if (this.bounds != null) {
      data['bounds'] = this.bounds.toJson();
    }
    return data;
  }
}

class Bounds {
  Location topLeft;
  Location bottomRight;

  Bounds({this.topLeft, this.bottomRight});

  Bounds.fromJson(Map<String, dynamic> json) {
    topLeft = json['top_left'] != null
        ? new Location.fromJson(json['top_left'])
        : null;
    bottomRight = json['bottom_right'] != null
        ? new Location.fromJson(json['bottom_right'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.topLeft != null) {
      data['top_left'] = this.topLeft.toJson();
    }
    if (this.bottomRight != null) {
      data['bottom_right'] = this.bottomRight.toJson();
    }
    return data;
  }
}
