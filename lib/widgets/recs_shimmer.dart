import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RecsShimmer extends StatelessWidget {
  const RecsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Shimmer.fromColors(
        baseColor: Colors.white,
        highlightColor: Colors.pink,
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 30,
                      width: 200,
                      color: Colors.white,
                    ),
                  ),
                  trailing: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 30,
                      width: 70,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  height: 280,
                  child: ListView.builder(
                    itemCount: 3,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        margin: EdgeInsets.all(10),
                        height: 200,
                        width: 200,
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
