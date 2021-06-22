class ClickAnalytics {
  int? searchClicks;
  int? recommendationsClicks;
  int? categoryClicks;
  int? totalClicks;
  int? profileClicks;

  ClickAnalytics(
      {this.searchClicks,
      this.recommendationsClicks,
      this.categoryClicks,
      this.totalClicks,
      this.profileClicks});

  ClickAnalytics.fromJson(Map<String, dynamic> json) {
    searchClicks = json['searchClicks'];
    recommendationsClicks = json['recommendationsClicks'];
    categoryClicks = json['categoryClicks'];
    totalClicks = json['totalClicks'];
    profileClicks = json['profileClicks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['searchClicks'] = this.searchClicks;
    data['recommendationsClicks'] = this.recommendationsClicks;
    data['categoryClicks'] = this.categoryClicks;
    data['totalClicks'] = this.totalClicks;
    data['profileClicks'] = this.profileClicks;
    return data;
  }
}
