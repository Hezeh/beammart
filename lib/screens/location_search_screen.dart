import 'package:beammart/models/place_search.dart';
import 'package:beammart/services/places_service.dart';
import 'package:flutter/material.dart';

class LocationSearchScreen extends SearchDelegate {
  final placesService = PlacesService();

  List<PlaceSearch> placeResults = [];

  searchPlaces(String searchTerm) async {
    placeResults = await placesService.getAutocomplete(searchTerm);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return query.isEmpty
        ? []
        : <Widget>[
            IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            ),
          ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
   searchPlaces(query);
    // TODO: Save to Hive DB & Firestore when user clicks on a search suggestion
    // TODO: Show a list of previous suggestions
    // return InkWell(
    //   onTap: () {
    //     close(context, "Suggested Address");
    //   },
    //   child: ListTile(
    //     title: Text("Suggested Location"),
    //   ),
    // );
    return ListView.builder(
      itemCount: placeResults.length,
      itemBuilder: (context, index) {
        return InkWell(
          child: ListTile(
            title: Text("${placeResults[index].description}"),
          ),
          onTap: () {
            close(context, placeResults[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    searchPlaces(query);
    // TODO: Save to Hive DB & Firestore when user clicks on a search suggestion
    // TODO: Show a list of previous suggestions
    // return InkWell(
    //   onTap: () {
    //     close(context, "Suggested Address");
    //   },
    //   child: ListTile(
    //     title: Text("Suggested Location"),
    //   ),
    // );
    return ListView.builder(
      itemCount: placeResults.length,
      itemBuilder: (context, index) {
        return InkWell(
          child: ListTile(
            title: Text("${placeResults[index].description}"),
          ),
          onTap: () {
            close(context, placeResults[index]);
          },
        );
      },
    );
  }
}
