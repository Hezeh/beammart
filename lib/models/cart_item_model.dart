class CartItemModel {
  String? itemId;
  String? merchantId;
  String? title;
  String? description;
  int quantity;

  CartItemModel({
    this.itemId,
    this.merchantId,
    this.title,
    this.description,
    this.quantity = 1
  });
}
