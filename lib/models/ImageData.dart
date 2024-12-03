class ImageData {
  final int id;
  final String imageUrl;

  ImageData({required this.id, required this.imageUrl});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      id: json['id'],
      imageUrl: json['image_url'],
    );
  }
}