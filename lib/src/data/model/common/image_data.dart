class CommonImageModel {
  String? originalImage;
  String? ogImage;
  String? thumbnail;
  String? bigImage;
  String? bigImageTwo;
  String? mediumImage;
  String? mediumImageTwo;
  String? mediumImageThree;
  String? smallImage;

  CommonImageModel(
      {this.originalImage,
      this.ogImage,
      this.thumbnail,
      this.bigImage,
      this.bigImageTwo,
      this.mediumImage,
      this.mediumImageTwo,
      this.mediumImageThree,
      this.smallImage});

  CommonImageModel.fromJson(Map<String, dynamic> json) {
    originalImage = json['original_image'];
    ogImage = json['og_image'];
    thumbnail = json['thumbnail'];
    bigImage = json['big_image'];
    bigImageTwo = json['big_image_two'];
    mediumImage = json['medium_image'];
    mediumImageTwo = json['medium_image_two'];
    mediumImageThree = json['medium_image_three'];
    smallImage = json['small_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['original_image'] = this.originalImage;
    data['og_image'] = this.ogImage;
    data['thumbnail'] = this.thumbnail;
    data['big_image'] = this.bigImage;
    data['big_image_two'] = this.bigImageTwo;
    data['medium_image'] = this.mediumImage;
    data['medium_image_two'] = this.mediumImageTwo;
    data['medium_image_three'] = this.mediumImageThree;
    data['small_image'] = this.smallImage;
    return data;
  }
}
