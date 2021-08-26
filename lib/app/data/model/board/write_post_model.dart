class WritePostModel {
  String title;
  String description;
  String unnamed;

  WritePostModel({
    this.title,
    this.description,
    this.unnamed,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data["unnamed"] = this.unnamed;
    return data;
  }
}
