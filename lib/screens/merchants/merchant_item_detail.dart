import 'package:beammart/models/merchant_item.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/screens/merchants/merchant_add_product_images.dart';
import 'package:beammart/widgets/merchants/merchant_item_analytics.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';

class MerchantItemDetail extends StatefulWidget {
  final MerchantItem? item;
  final String itemId;
  static const routeName = '/item-detail';

  MerchantItemDetail({
    Key? key,
    this.item,
    required this.itemId,
  }) : super(key: key);

  @override
  _MerchantItemDetailState createState() => _MerchantItemDetailState();
}

class _MerchantItemDetailState extends State<MerchantItemDetail> {
  final TextEditingController _editTitleController = TextEditingController();
  final TextEditingController _editDescController = TextEditingController();
  final TextEditingController _editPriceController = TextEditingController();
  final _itemDetailFormKey = GlobalKey<FormState>();
  bool? _inStock;

  @override
  void dispose() {
    _editDescController.dispose();
    _editTitleController.dispose();
    _editPriceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _editTitleController.text = widget.item!.title!;
    _editDescController.text = widget.item!.description!;
    _editPriceController.text = widget.item!.price.toString();
    _inStock = widget.item!.inStock;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<AuthenticationProvider>(context);
    // final _subsProvider = Provider.of<SubscriptionsProvider>(context);
    createItemDynamicLink() async {
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://beammart.page.link',
        link: Uri.parse(
            'https://beammart.page.link/item?id=${widget.itemId}&shop_id=${_userProvider.user!.uid}'),
        androidParameters: AndroidParameters(
          packageName: 'com.beammart.beammart',
          minimumVersion: 125,
        ),
        iosParameters: IosParameters(
          bundleId: 'com.beammart.ios',
          minimumVersion: '1.0.1',
          appStoreId: '123456789',
        ),
        googleAnalyticsParameters: GoogleAnalyticsParameters(
          campaign: 'example-promo',
          medium: 'social',
          source: 'orkut',
        ),
        itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
          providerToken: '123456',
          campaignToken: 'example-promo',
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: widget.item!.title,
          description: widget.item!.description,
          imageUrl: Uri.parse('${widget.item!.images!.first}'),
        ),
      );

      // final Uri dynamicUrl = await parameters.buildUrl();
      // print("Dynamic Url: $dynamicUrl");

      final ShortDynamicLink shortDynamicLink =
          await parameters.buildShortLink();
      final Uri shortUrl = shortDynamicLink.shortUrl;
      await Share.share(
        'Get the Beammart App and discover products sold nearby: $shortUrl',
      );
      print("Short Dynamic Url: $shortUrl");
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Item Details'),
          actions: [
            // TextButton(
            //   onPressed: () {
            //     if (_itemDetailFormKey.currentState!.validate()) {
            //       final String _userId = _userProvider.user!.uid;
            //       final DocumentReference _doc = FirebaseFirestore.instance
            //           .collection('profile')
            //           .doc(_userId)
            //           .collection('items')
            //           .doc(widget.itemId);

            //       _doc.set({
            //         'title': _editTitleController.text,
            //         'description': _editDescController.text,
            //         'price': double.parse(_editPriceController.text),
            //         'inStock': _inStock
            //       }, SetOptions(merge: true));

            //       Navigator.of(context).pop();
            //     }
            //   },
            //   child: Text(
            //     'Save',
            //     style: TextStyle(
            //       color: Colors.pink,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            IconButton(
              onPressed: () {
                createItemDynamicLink();
                // Share.share(
                //   'Get the Beammart App and discover products sold nearby: https://beammart.page.link/item?id=${widget.itemId}&shop_id=${_userProvider.user!.uid}',
                // );
              },
              icon: Icon(
                Icons.share_outlined,
              ),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.edit_outlined,
                ),
                child: Semantics(
                  child: Text('Edit'),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.analytics_outlined,
                ),
                child: Semantics(
                  child: Text('Analytics'),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Form(
              key: _itemDetailFormKey,
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.all(15),
                    child: Center(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AddImagesScreen(
                                editing: true,
                                itemId: widget.itemId,
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.add_outlined,
                        ),
                        label: Text('Add Photos'),
                      ),
                    ),
                  ),
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('profile')
                        .doc(_userProvider.user!.uid)
                        .collection('items')
                        .doc(widget.itemId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Container(
                        height: 400,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                            childAspectRatio: 1.3,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.data()!['images'].length,
                          itemBuilder: (context, index) {
                            List<dynamic> _removeList = [];
                            _removeList
                                .add(snapshot.data!.data()!['images'][index]);
                            return Container(
                              padding: EdgeInsets.all(10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: GridTile(
                                  footer: (snapshot.data!
                                              .data()!['images']
                                              .length >
                                          1)
                                      ? GridTileBar(
                                          backgroundColor: Colors.black45,
                                          trailing: IconButton(
                                            icon: Icon(
                                                Icons.delete_outline_outlined),
                                            onPressed: () {
                                              if (_removeList.isNotEmpty) {
                                                FirebaseFirestore.instance
                                                    .collection('profile')
                                                    .doc(
                                                        _userProvider.user!.uid)
                                                    .collection('items')
                                                    .doc(widget.itemId)
                                                    .set(
                                                  {
                                                    'images':
                                                        FieldValue.arrayRemove(
                                                            _removeList)
                                                  },
                                                  SetOptions(merge: true),
                                                );
                                              }
                                            },
                                          ),
                                        )
                                      : Container(),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.data()!['images']
                                        [index],
                                    height: 500,
                                    width: 200,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center,
                                          colorFilter: ColorFilter.mode(
                                            Colors.white,
                                            BlendMode.colorBurn,
                                          ),
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                      child: Card(
                                        child: Container(
                                          width: double.infinity,
                                          height: 300,
                                          color: Colors.white,
                                        ),
                                      ),
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _editTitleController,
                      autocorrect: true,
                      enableSuggestions: true,
                      maxLines: 3,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'Edit Title',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _editDescController,
                      autocorrect: true,
                      enableSuggestions: true,
                      maxLines: 4,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'Edit Description',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _editPriceController,
                      autocorrect: true,
                      enableSuggestions: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'Edit Price',
                      ),
                    ),
                  ),
                  MergeSemantics(
                    child: ListTile(
                      title: Text('Item in Stock'),
                      trailing: CupertinoSwitch(
                        value: _inStock!,
                        onChanged: (bool value) {
                          setState(() {
                            _inStock = value;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          _inStock = !_inStock!;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 25,
                      left: 10,
                      right: 10,
                      bottom: 10,
                    ),
                    height: 80,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_itemDetailFormKey.currentState!.validate()) {
                          final String _userId = _userProvider.user!.uid;
                          final DocumentReference _doc = FirebaseFirestore
                              .instance
                              .collection('profile')
                              .doc(_userId)
                              .collection('items')
                              .doc(widget.itemId);

                          _doc.set({
                            'title': _editTitleController.text,
                            'description': _editDescController.text,
                            'price': double.parse(_editPriceController.text),
                            'inStock': _inStock
                          }, SetOptions(merge: true));

                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        'Save',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: ItemAnalyticsWidget(
                itemId: widget.itemId,
              ),
            )
          ],
        ),
      ),
    );
  }
}
