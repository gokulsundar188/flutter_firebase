class FirebaseModel {
  String version;
  String url;

  FirebaseModel({this.version, this.url});

  FirebaseModel.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['url'] = this.url;
    return data;
  }
}
