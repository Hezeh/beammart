import 'package:beammart/models/item_recommendations.dart';
import 'package:beammart/services/recommendations_service.dart';
import 'package:beammart/widgets/web_recs_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:beammart/widgets/recs_shimmer.dart';

class WebHomeScreen extends StatelessWidget {
  const WebHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getWebRecs(context),
        builder: (BuildContext context,
            AsyncSnapshot<ItemRecommendations> snapshot) {
          if ((snapshot.hasData)) {
            if (snapshot.data!.recommendations!.length < 1) {
              return Center(
                child: Text(
                  'Sorry, No Products posted yet',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.recommendations!.length,
              itemBuilder: (context, index) {
                return WebRecsCard(
                  index: index,
                  snapshot: snapshot,
                );
              },
            );
          } else {
            return RecsShimmer();
          }
        },
      ),
    );
  }
}
