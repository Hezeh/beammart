import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DisplayImagesWidget extends StatelessWidget {
  final List<String>? images;

  const DisplayImagesWidget({Key? key, this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: images!.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(
            left: 2.5,
            right: 2.5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: CachedNetworkImage(
              imageUrl: images![index],
              height: 400,
              width: 400,
              fit: BoxFit.cover,
              imageBuilder: (context, imageProvider) => Container(
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
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        );
      },
    );
  }
}
