import 'package:beammart/screens/category_view_all.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection('categories').get(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return GridView.builder(
            itemCount: snapshot.data!.docs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              mainAxisExtent: 200,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CategoryViewAll(
                        categoryName: snapshot.data!.docs[index].data()['categoryName'],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: GridTile(
                      footer: GridTileBar(
                        backgroundColor: Colors.black54,
                        title: Text(
                          snapshot.data!.docs[index].data()['categoryName'],
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            snapshot.data!.docs[index].data()['categoryImage'],
                        imageBuilder: (context, imageProvider) => Container(
                          height: 300,
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
                                height: 400,
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
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
