class ConsumerAddress {
  String? addressName;
  double? addressLon;
  double? addressLat;
  String? placeId;
  String? addressDescription;

  ConsumerAddress({
    this.addressName,
    this.addressLon,
    this.addressLat,
    this.placeId,
    this.addressDescription,
  });

  ConsumerAddress.fromJson(Map<String, dynamic> json) {
    addressName = json['addressName'];
    addressLon = json['addressLon'];
    addressLat = json['addressLat'];
    placeId = json['placeId'];
    addressDescription = json['addressDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addressName'] = this.addressName;
    data['addressLat'] = this.addressLat;
    data['addressLon'] = this.addressLon;
    data['addressDescription'] = this.addressDescription;
    data['placeId'] = this.placeId;
    return data;
  }
}
