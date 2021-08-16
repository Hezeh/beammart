import 'dart:async';

import 'package:beammart/models/item_results.dart';
import 'package:beammart/models/suggestions.dart';
import 'package:beammart/services/search_api_wrapper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

class SearchService {
  final LatLng location;
  final SearchAPIWrapper apiWrapper;

  SearchService({required this.apiWrapper, required this.location}) {
    _suggestions = _searchTerms.switchMap((query) async* {
      yield await apiWrapper.suggestItems(query);
    });
    _itemResults = _searchTerm.switchMap((query) async* {
      yield await apiWrapper.searchItems(query, location);
    });
  }

  // Input Stream (search terms)
  final _searchTerms = BehaviorSubject<String>();
  final _searchTerm = BehaviorSubject<String>();
  void suggestItem(String query) => _searchTerms.add(query);
  void searchItem(String query) => _searchTerm.add(query);

  Stream<Suggestions>? _suggestions;
  Stream<Suggestions>? get suggestions => _suggestions;

  Stream<ItemResults>? _itemResults;
  Stream<ItemResults>? get results => _itemResults;

  void dispose() {
    _searchTerms.close();
    _searchTerm.close();
  }
}
