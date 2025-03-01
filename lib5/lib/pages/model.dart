class Model {
  final String artist_names;
  final String full_title;
  final String header_image_thumbnail_url;
  final String url;

  Model({
    required this.artist_names,
    required this.full_title,
    required this.header_image_thumbnail_url,
    required this.url,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      artist_names: json['artist_names'],
      full_title: json['title'],
      header_image_thumbnail_url: json['header_image_thumbnail_url'],
      url: json['url'],
    );
  }
}