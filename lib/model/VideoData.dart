class VideoData {
  String title;
  String url;
  VideoData({this.title, this.url});
  VideoData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    url = json['url'];
  }
}
