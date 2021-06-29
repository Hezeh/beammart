import 'package:beammart/models/merchant_item.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/profile_provider.dart';
import 'package:beammart/screens/login_screen.dart';
import 'package:beammart/screens/merchants/merchant_add_product_images.dart';
import 'package:beammart/screens/merchants/merchant_item_detail.dart';
import 'package:beammart/screens/merchants/profile_screen.dart';
import 'package:beammart/screens/merchants/tokens_screen.dart';
import 'package:beammart/widgets/merchants/merchant_left_drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MerchantHomeScreen extends StatefulWidget {
  static const routeName = '/Screen';

  @override
  _MerchantHomeScreenState createState() => _MerchantHomeScreenState();
}

class _MerchantHomeScreenState extends State<MerchantHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<int>? itemsLength;

  Future<int> getCollectionLength(String uid) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('profile')
        .doc(uid)
        .collection('items')
        .get();
    final int _itemsLength = querySnapshot.size;
    return _itemsLength;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<AuthenticationProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<AuthenticationProvider>(context);
    final _loading = context.watch<ProfileProvider>().loading;
    final _profile = context.watch<ProfileProvider>().profile;

    if (_userProvider.user == null) {
      return LoginScreen(
        showCloseIcon: true,
      );
    } else {
      if (_loading) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        if (_profile != null) {
          final Stream<QuerySnapshot> items = FirebaseFirestore.instance
              .collection('profile')
              .doc(_userProvider.user!.uid)
              .collection('items')
              .orderBy('dateAdded', descending: true)
              .snapshots();
          return Scaffold(
            key: _scaffoldKey,
            drawer: LeftDrawer(),
            bottomNavigationBar: BottomAppBar(
              color: Colors.pink,
              shape: const CircularNotchedRectangle(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.menu_outlined),
                    iconSize: 30.0,
                    onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                  ),
                  IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.exit_to_app_outlined),
                    iconSize: 30.0,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: HomePage(
                items: items,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterDocked,
            floatingActionButton: FloatingActionButton.extended(
              icon: Icon(Icons.add),
              backgroundColor: Colors.pink,
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddImagesScreen(),
                  ),
                );
              },
              label: Text("Post Item"),
            ),
          );
        }
        return ProfileScreen();
      }
    }
  }
}

class HomePage extends StatelessWidget {
  final Stream<QuerySnapshot> items;

  const HomePage({Key? key, required this.items}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<AuthenticationProvider>(context);

    final Stream<DocumentSnapshot> _tokens = FirebaseFirestore.instance
        .collection('profile')
        .doc(_userProvider.user!.uid)
        .snapshots();

    return ListView(
      children: [
        StreamBuilder(
          stream: _tokens,
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snap) {
            if (!snap.hasData) {
              return LinearProgressIndicator();
            }
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.pink,
                  width: 5,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.toll_outlined,
                        size: 40,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                  Container(
                    child: (snap.data!.data()!.containsKey('tokensBalance'))
                        ? Text(
                            "Tokens: ${snap.data!['tokensBalance']}",
                          )
                        : Text("Tokens: 0"),
                  ),
                  Container(
                    child: ElevatedButton(
                      child: Text('Buy More'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TokensScreen(),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ),
        StreamBuilder<QuerySnapshot>(
          stream: items,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('An error occurred while loading the app'),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                return (snapshot.data!.docs.isNotEmpty)
                    ? GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(
                          left: 5,
                          right: 5,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250,
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GridTile(
                                footer: GridTileBar(
                                  backgroundColor: Colors.black38,
                                  trailing: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_outline_outlined,
                                        ),
                                        onPressed: () => showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Confirm Delete'),
                                              content: const Text(
                                                'Do you really want to delete this product?',
                                              ),
                                              actions: [
                                                OutlinedButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text('Cancel'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    snapshot.data!.docs[index]
                                                        .reference
                                                        .delete();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'Delete',
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  title: Text(
                                      '${snapshot.data!.docs[index].data()['title']}'),
                                ),
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MerchantItemDetail(
                                        item: MerchantItem.fromJson(
                                          snapshot.data!.docs[index].data(),
                                        ),
                                        itemId: snapshot.data!.docs[index].id,
                                      ),
                                      settings: RouteSettings(
                                        name: 'MerchantItemDetailScreen',
                                      ),
                                    ),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.docs[index]
                                        .data()['images']
                                        .first,
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
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Card(
                                        child: Container(
                                          width: double.infinity,
                                          height: 300,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        margin: EdgeInsets.only(
                          top: 200,
                        ),
                        child: Container(
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Colors.pink,
                                Colors.purple,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "You haven't posted anything yet.",
                              style: GoogleFonts.gelasio(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
              }
            }
            return Container(
              margin: EdgeInsets.only(
                top: 100,
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ],
    );
  }
}
