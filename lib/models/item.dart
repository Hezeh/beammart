class Item {
  String? itemId;
  String? userId;
  List<dynamic>? images;
  String? title;
  String? description;
  int? price;
  Location? location;
  String? locationDescription;
  String? businessName;
  String? businessDescription;
  String? phoneNumber;
  String? mondayOpeningHours;
  String? mondayClosingHours;
  String? tuesdayOpeningHours;
  String? tuesdayClosingHours;
  String? wednesdayOpeningHours;
  String? wednesdayClosingHours;
  String? thursdayOpeningHours;
  String? thursdayClosingHours;
  String? fridayOpeningHours;
  String? fridayClosingHours;
  String? saturdayOpeningHours;
  String? saturdayClosingHours;
  String? sundayOpeningHours;
  String? sundayClosingHours;
  double? distance;
  String? businessId;
  String? dateJoined;
  String? dateAdded;
  String? merchantPhotoUrl;
  bool? inStock;
  bool? isMondayOpen;
  bool? isTuesdayOpen;
  bool? isWednesdayOpen;
  bool? isThursdayOpen;
  bool? isFridayOpen;
  bool? isSaturdayOpen;
  bool? isSundayOpen;
  String? category;
  String? subCategory;

  Item({
    this.itemId,
    this.userId,
    this.images,
    this.title,
    this.description,
    this.price,
    this.location,
    this.locationDescription,
    this.businessName,
    this.businessDescription,
    this.phoneNumber,
    this.mondayOpeningHours,
    this.mondayClosingHours,
    this.tuesdayOpeningHours,
    this.tuesdayClosingHours,
    this.wednesdayOpeningHours,
    this.wednesdayClosingHours,
    this.thursdayOpeningHours,
    this.thursdayClosingHours,
    this.fridayOpeningHours,
    this.fridayClosingHours,
    this.saturdayOpeningHours,
    this.saturdayClosingHours,
    this.sundayOpeningHours,
    this.sundayClosingHours,
    this.distance,
    this.businessId,
    this.dateJoined,
    this.dateAdded,
    this.merchantPhotoUrl,
    this.inStock,
    this.isMondayOpen,
    this.isTuesdayOpen,
    this.isWednesdayOpen,
    this.isThursdayOpen,
    this.isFridayOpen,
    this.isSaturdayOpen,
    this.isSundayOpen,
    this.category,
    this.subCategory,
  });

  Item.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId'];
    userId = json['userId'];
    images = json['images'].cast<String>();
    title = json['title'];
    description = json['description'];
    price = json['price'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    locationDescription = json['locationDescription'];
    businessName = json['businessName'];
    businessDescription = json['businessDescription'];
    phoneNumber = json['phoneNumber'];
    mondayOpeningHours = json['mondayOpeningHours'];
    mondayClosingHours = json['mondayClosingHours'];
    tuesdayOpeningHours = json['tuesdayOpeningHours'];
    tuesdayClosingHours = json['tuesdayClosingHours'];
    wednesdayOpeningHours = json['wednesdayOpeningHours'];
    wednesdayClosingHours = json['wednesdayClosingHours'];
    thursdayOpeningHours = json['thursdayOpeningHours'];
    thursdayClosingHours = json['thursdayClosingHours'];
    fridayOpeningHours = json['fridayOpeningHours'];
    fridayClosingHours = json['fridayClosingHours'];
    saturdayOpeningHours = json['saturdayOpeningHours'];
    saturdayClosingHours = json['saturdayClosingHours'];
    sundayOpeningHours = json['sundayOpeningHours'];
    sundayClosingHours = json['sundayClosingHours'];
    distance = json['distance'];
    businessId = json['userId'];
    dateJoined = json['dateJoined'];
    dateAdded = json['dateAdded'];
    merchantPhotoUrl = json['businessProfilePhoto'];
    inStock = json['inStock'];
    isMondayOpen = json['isMondayOpen'];
    isTuesdayOpen = json['isTuesdayOpen'];
    isWednesdayOpen = json['isWednesdayOpen'];
    isThursdayOpen = json['isThursdayOpen'];
    isFridayOpen = json['isFridayOpen'];
    isSaturdayOpen = json['isSaturdayOpen'];
    isSundayOpen = json['isSundayOpen'];
    category = json['category'];
    subCategory = json['subCategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemId'] = this.itemId;
    data['userId'] = this.userId;
    data['images'] = this.images;
    data['title'] = this.title;
    data['description'] = this.description;
    data['price'] = this.price;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['locationDescription'] = this.locationDescription;
    data['businessName'] = this.businessName;
    data['businessDescription'] = this.businessDescription;
    data['phoneNumber'] = this.phoneNumber;
    data['mondayOpeningHours'] = this.mondayOpeningHours;
    data['mondayClosingHours'] = this.mondayClosingHours;
    data['tuesdayOpeningHours'] = this.tuesdayOpeningHours;
    data['tuesdayClosingHours'] = this.tuesdayClosingHours;
    data['wednesdayOpeningHours'] = this.wednesdayOpeningHours;
    data['wednesdayClosingHours'] = this.wednesdayClosingHours;
    data['thursdayOpeningHours'] = this.thursdayOpeningHours;
    data['thursdayClosingHours'] = this.thursdayClosingHours;
    data['fridayOpeningHours'] = this.fridayOpeningHours;
    data['fridayClosingHours'] = this.fridayClosingHours;
    data['saturdayOpeningHours'] = this.saturdayOpeningHours;
    data['saturdayClosingHours'] = this.saturdayClosingHours;
    data['sundayOpeningHours'] = this.sundayOpeningHours;
    data['sundayClosingHours'] = this.sundayClosingHours;
    data['distance'] = this.distance;
    data['userId'] = this.businessId;
    data['dateJoined'] = this.dateJoined;
    data['dateAdded'] = this.dateAdded;
    data['businessProfilePhoto'] = this.merchantPhotoUrl;
    data['inStock'] = this.inStock;
    data['isMondayOpen'] = this.isMondayOpen;
    data['isTuesdayOpen'] = this.isTuesdayOpen;
    data['isWednesdayOpen'] = this.isWednesdayOpen;
    data['isThursdayOpen'] = this.isThursdayOpen;
    data['isFridayOpen'] = this.isFridayOpen;
    data['isSaturdayOpen'] = this.isSaturdayOpen;
    data['isSundayOpen'] = this.isSundayOpen;
    data['category'] = this.category;
    data['subCategory'] = this.subCategory;
    return data;
  }
}

class Location {
  double? lat;
  double? lon;

  Location({this.lat, this.lon});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    return data;
  }
}
