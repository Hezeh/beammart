import 'package:beammart/models/category_items.dart';
import 'package:beammart/models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<CategoryItems> getMerchantItems(String? merchantId) async {
  // final response = await http.get(
  //   Uri(
  //     scheme: 'https',
  //     host: 'api.beammart.app',
  //     path: 'merchant/$merchantId'
  //   ),
  // );
  // final jsonResponse = CategoryItems.fromJson(json.decode(response.body));
  // if (response.statusCode == 200) {
  //   print(jsonResponse);
  //   return jsonResponse;
  // }

  final _db = FirebaseFirestore.instance.collection('items');

  // Filter by category
  final _items = await _db.where('userId', isEqualTo: merchantId).get();

  final List<Item> _listOfItems = [];

  _items.docs.forEach((item) {
    // Convert each item to Item Data Type
    final _data = item.data();
    final _location = Location(
      lat: _data['location'].latitude,
      lon: _data['location'].longitude,
    );
    final _formattedItem = Item(
      itemId: _data['itemId'],
      userId: _data['userId'],
      images: _data['imageUrls'],
      title: _data['title'],
      description: _data['description'],
      price: _data['price'],
      location: _location,
      locationDescription: _data['locationDescription'],
      businessName: _data['businessName'],
      businessDescription: _data['businessDescription'],
      phoneNumber: _data['phoneNumber'],
      mondayOpeningHours: _data['mondayOpeningHours'],
      mondayClosingHours: _data['mondayClosingHours'],
      tuesdayOpeningHours: _data['tuesdayOpeningHours'],
      tuesdayClosingHours: _data['tuesdayClosingHours'],
      wednesdayOpeningHours: _data['wednesdayOpeningHours'],
      wednesdayClosingHours: _data['wednesdayClosingHours'],
      thursdayOpeningHours: _data['thursdayOpeningHours'],
      thursdayClosingHours: _data['thursdayClosingHours'],
      fridayOpeningHours: _data['fridayOpeningHours'],
      fridayClosingHours: _data['fridayClosingHours'],
      saturdayOpeningHours: _data['saturdayOpeningHours'],
      saturdayClosingHours: _data['saturdayClosingHours'],
      sundayOpeningHours: _data['sundayOpeningHours'],
      sundayClosingHours: _data['sundayClosingHours'],
      distance: _data['distance'],
      businessId: _data['userId'],
      dateJoined: _data['dateJoined'],
      dateAdded: _data['dateAdded'],
      merchantPhotoUrl: _data['businessProfilePhoto'],
      inStock: _data['inStock'],
      isMondayOpen: _data['isMondayOpen'],
      isTuesdayOpen: _data['isTuesdayOpen'],
      isWednesdayOpen: _data['isWednesdayOpen'],
      isThursdayOpen: _data['isThursdayOpen'],
      isFridayOpen: _data['isFridayOpen'],
      isSaturdayOpen: _data['isSaturdayOpen'],
      isSundayOpen: _data['isSundayOpen'],
      category: _data['category'],
      subCategory: _data['subCategory'],
    );
    _listOfItems.add(_formattedItem);
  });

  final _catItems = CategoryItems(items: _listOfItems);

  if (_listOfItems.length != 0) {
    return _catItems;
  }

  return CategoryItems();
}
