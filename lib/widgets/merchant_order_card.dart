import 'package:beammart/models/order.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/profile_provider.dart';
import 'package:beammart/services/request_delivery_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MerchantOrderCard extends StatelessWidget {
  final Order? order;

  const MerchantOrderCard({
    Key? key,
    this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<AuthenticationProvider>(context);
    final _profileProvider = Provider.of<ProfileProvider>(context);
    return Card(
      margin: EdgeInsets.only(
        top: 5,
        bottom: 10,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      child: Column(
        children: [
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (order!.item!.images != null)
                    ? ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: CachedNetworkImage(
                          imageUrl: order!.item!.images!.first.toString(),
                          imageBuilder: (context, imageProvider) => Container(
                            height: 150,
                            width: 150,
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
                          placeholder: (context, url) {
                            return Shimmer.fromColors(
                              child: Card(
                                child: Container(
                                  width: double.infinity,
                                  height: 300,
                                  color: Colors.white,
                                ),
                              ),
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                            );
                          },
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      )
                    : Container(),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          "${order!.item!.businessName}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          "${order!.quantity} X ${order!.item!.title}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          "Ksh. ${order!.totalOrderAmount}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          (order!.accepted != null)
              ? Container(
                  child: (order!.accepted == true)
                      ? Text("Order Accepted")
                      : Text("Order Rejected"),
                )
              : SizedBox.shrink(),
          (order!.accepted == null)
              ? Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            child: ConstrainedBox(
                          constraints: BoxConstraints.tightFor(
                            width: 150,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_userProvider.user != null) {
                                if (order != null) {
                                  FirebaseFirestore.instance
                                      .collection('profile')
                                      .doc(_userProvider.user!.uid)
                                      .collection('orders')
                                      .doc(order!.orderId)
                                      .set(
                                    {
                                      'accepted': true,
                                    },
                                    SetOptions(
                                      merge: true,
                                    ),
                                  );
                                }
                              }
                            },
                            child: Text("Accept Order"),
                          ),
                        )),
                        Container(
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                              width: 150,
                            ),
                            child: OutlinedButton(
                              onPressed: () {
                                if (_userProvider.user != null) {
                                  if (order != null) {
                                    FirebaseFirestore.instance
                                        .collection('profile')
                                        .doc(_userProvider.user!.uid)
                                        .collection('orders')
                                        .doc(order!.orderId)
                                        .set(
                                      {
                                        'accepted': false,
                                      },
                                      SetOptions(
                                        merge: true,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Text("Reject Order"),
                            ),
                          ),
                        )
                      ]),
                )
              : (order!.delivered != null && order!.delivered == false)
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.call_outlined,
                                ),
                                label: Text("Call Customer"),
                              ),
                            ),
                            Container(
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.chat_bubble_outline_outlined,
                                ),
                                label: Text("Chat With Customer"),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              requestDelivery(
                                order: order,
                                merchantProfile: _profileProvider.profile,
                              );
                            },
                            icon: Icon(
                              Icons.two_wheeler_outlined,
                            ),
                            label: Text("Request Delivery Driver"),
                          ),
                        ),
                        Container(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (_userProvider.user != null) {
                                if (order != null) {
                                  FirebaseFirestore.instance
                                      .collection('profile')
                                      .doc(_userProvider.user!.uid)
                                      .collection('orders')
                                      .doc(order!.orderId)
                                      .set(
                                    {
                                      'delivered': true,
                                      'deliveryTimestamp':
                                          DateTime.now().toIso8601String()
                                    },
                                    SetOptions(
                                      merge: true,
                                    ),
                                  );
                                }
                              }
                            },
                            icon: Icon(
                              Icons.local_shipping_outlined,
                            ),
                            label: Text("Mark As Delivered"),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      child: (order!.accepted == true)
                          ? ListTile(
                              title: Text("Order Delivered"),
                              subtitle: Text(
                                  "${DateTime.parse(order!.deliveryTimestamp as String)}"),
                            )
                          : ListTile(
                              title: Text("Order Was Not Delivered"),
                            ),
                    ),
        ],
      ),
    );
  }
}
