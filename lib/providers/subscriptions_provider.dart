import 'dart:async';

import 'package:beammart/utils/consumable_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

const String k200TokensId = '200_tokens';
const String k500TokensId = '500_tokens';
const String k1000TokensId = '1000_tokens';
const String k2500TokensId = '2500_tokens';
const String k5000TokensId = '5000_tokens';
const String k10000TokensId = '10000_tokens';
const String kBronzeSubscriptionId = 'subscription_bronze';
const String kSilverSubscriptionId = 'subscription_silver';
const String kGoldSubscriptionId = 'gold_plan';
const List<String> _kProductsIds = <String>[
  k200TokensId,
  k500TokensId,
  k1000TokensId,
  k2500TokensId,
  k5000TokensId,
  k10000TokensId,
  kBronzeSubscriptionId,
  kSilverSubscriptionId,
  kGoldSubscriptionId,
];

class SubscriptionsProvider with ChangeNotifier {
  // final _currentUser = FirebaseAuth.instance.currentUser;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  dynamic _consumables = 0;
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;
  User? _user;

  SubscriptionsProvider(this._user) {
    if (this._user != null) {
      final Stream<List<PurchaseDetails>> purchaseUpdated =
          _inAppPurchase.purchaseStream;
      _subscription = purchaseUpdated.listen((purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList, this._user!.uid);
      }, onDone: () {
        _subscription.cancel();
      }, onError: (error) {
        print(error);
      });
      initStoreInfo();
      notifyListeners();
    }
  }

  // Getters
  StreamSubscription<List<PurchaseDetails>> get subscription => _subscription;
  InAppPurchase get connection => _inAppPurchase;
  List<String> get notFoundIds => _notFoundIds;
  List<ProductDetails> get products => _products;
  List<PurchaseDetails> get purchases => _purchases;
  bool get isAvailable => _isAvailable;
  bool get purchasePending => _purchasePending;
  bool get loading => _loading;
  String? get queryProductError => _queryProductError;
  dynamic get consumables => _consumables;

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      _isAvailable = isAvailable;
      _products = [];
      _purchases = [];
      _notFoundIds = [];
      _consumables = 0;
      _purchasePending = false;
      _loading = false;
      notifyListeners();
      return;
    }

    ProductDetailsResponse productDetailsResponse =
        await _inAppPurchase.queryProductDetails(_kProductsIds.toSet());
    // print("Products Details Resp: ${productDetailsResponse.productDetails.single.id}");

    if (productDetailsResponse.error != null) {
      // print("Product Details Error: ${productDetailsResponse.error!.message}");
      _queryProductError = productDetailsResponse.error!.message;
      _isAvailable = isAvailable;
      _products = productDetailsResponse.productDetails;
      _purchases = [];
      _notFoundIds = productDetailsResponse.notFoundIDs;
      _consumables = 0;
      _purchasePending = false;
      _loading = false;
      notifyListeners();
      return;
    }

    if (productDetailsResponse.productDetails.isEmpty) {
      // print("Product Details is Empty");
      _queryProductError = null;
      _isAvailable = isAvailable;
      _products = productDetailsResponse.productDetails;
      _purchases = [];
      _notFoundIds = productDetailsResponse.notFoundIDs;
      _consumables = 0;
      _purchasePending = false;
      _loading = false;
      notifyListeners();
      return;
    }

    // final QueryPurchaseDetailsResponse purchaseResponse =
    //     await _inAppPurchase.queryPastPurchases();
    // if (purchaseResponse.error != null) {
    //   // handle query past purchase error
    // }
    // final List<PurchaseDetails> verifiedPurchases = [];
    // for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
    //   if (await _verifyPurchase(purchase)) {
    //     verifiedPurchases.add(purchase);
    //   }
    // }
    dynamic consumables = await ConsumableStore.load();
    // print("Consumables: $consumables");
    _isAvailable = isAvailable;
    _products = productDetailsResponse.productDetails;
    // _purchases = verifiedPurchases;
    _notFoundIds = productDetailsResponse.notFoundIDs;
    _consumables = consumables;
    _purchasePending = false;
    _loading = false;
    notifyListeners();
  }

  void _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList, String userId) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _purchasePending = true;
        notifyListeners();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            _deliverProduct(purchaseDetails, userId);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    });
    notifyListeners();
  }

  void _handleError(IAPError error) {
    _purchasePending = false;
    notifyListeners();
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // TODO: IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    // print("Token: ${purchaseDetails.billingClientPurchase!.purchaseToken}");
    // print("PackageName: ${purchaseDetails.billingClientPurchase!.packageName}");
    // print("OrderId: ${purchaseDetails.billingClientPurchase!.orderId}");
    // print(
    //     "Original Json: ${purchaseDetails.billingClientPurchase!.originalJson}");
    // print("Product Id: ${purchaseDetails.productID}");
    // print("Purchase Id: ${purchaseDetails.purchaseID}");
    // print(
    //     "Verification Data: ${purchaseDetails.verificationData.localVerificationData}");
    // final _productId = purchaseDetails.productID;
    // final _token = purchaseDetails.billingClientPurchase!.purchaseToken;
    // final _packageName = purchaseDetails.billingClientPurchase!.packageName;

    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  void _deliverProduct(PurchaseDetails purchaseDetails, String userId) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID == k200TokensId) {
      // Add 200 Tokens to the database
      await ConsumableStore.save(purchaseDetails.productID, 200.0, userId);
      dynamic consumables = await ConsumableStore.load();
      _purchasePending = false;
      _consumables = consumables;
      notifyListeners();
    }
    if (purchaseDetails.productID == k500TokensId) {
      // Add 500 Tokens to the database
      await ConsumableStore.save(purchaseDetails.productID, 500.0, userId);
      dynamic consumables = await ConsumableStore.load();
      _purchasePending = false;
      _consumables = consumables;
      notifyListeners();
    }
    if (purchaseDetails.productID == k1000TokensId) {
      // Add 1000 Tokens to the database
      await ConsumableStore.save(purchaseDetails.productID, 1000.0, userId);
      dynamic consumables = await ConsumableStore.load();
      _purchasePending = false;
      _consumables = consumables;
    }
    if (purchaseDetails.productID == k2500TokensId) {
      // Add 2500 Tokens to the database
      await ConsumableStore.save(purchaseDetails.productID, 2500.0, userId);
      dynamic consumables = await ConsumableStore.load();
      _purchasePending = false;
      _consumables = consumables;
    }
    if (purchaseDetails.productID == k5000TokensId) {
      // Add 5000 Tokens to the database
      await ConsumableStore.save(purchaseDetails.productID, 5000.0, userId);
      dynamic consumables = await ConsumableStore.load();
      _purchasePending = false;
      _consumables = consumables;
    }
    if (purchaseDetails.productID == k10000TokensId) {
      // Add 10000 Tokens to the database
      await ConsumableStore.save(purchaseDetails.productID, 10000.0, userId);
      dynamic consumables = await ConsumableStore.load();
      _purchasePending = false;
      _consumables = consumables;
    }
    if (purchaseDetails.productID == kGoldSubscriptionId) {
      // TODO Change user to premium
      _purchases.add(purchaseDetails);
      _purchasePending = false;
    }
    notifyListeners();
  }

  Future<void> consume(double tokens, String userId) async {
    await ConsumableStore.consume(tokens, userId);
    final dynamic consumables = await ConsumableStore.load();
    _consumables = consumables;
    notifyListeners();
  }
}
