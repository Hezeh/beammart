class ImpressionsAnalyticsData {
  int? searchImpressions;
  int? recommendationsImpressions;
  int? categoryImpressions;
  int? totalImpressions;
  int? profileImpressions;

  ImpressionsAnalyticsData({
    this.searchImpressions,
    this.recommendationsImpressions,
    this.categoryImpressions,
    this.totalImpressions,
    this.profileImpressions,
  });

  ImpressionsAnalyticsData.fromJson(Map<String, dynamic> json) {
    searchImpressions = json['searchImpressions'];
    recommendationsImpressions = json['recommendationsImpressions'];
    categoryImpressions = json['categoryImpressions'];
    totalImpressions = json['totalImpressions'];
    profileImpressions = json['profilePageImpressions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['searchImpressions'] = this.searchImpressions;
    data['recommendationsImpressions'] = this.recommendationsImpressions;
    data['categoryImpressions'] = this.categoryImpressions;
    data['totalImpressions'] = this.totalImpressions;
    data['profilePageImpressions'] = this.profileImpressions;
    return data;
  }
}
