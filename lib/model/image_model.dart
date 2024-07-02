class ImageModel {
  String? id;
  String? characterId;
  String? newCharacterId;
  List<String>? searchTag;
  String? linkUrl;
  int? price;
  int? numberSet;
  String? thumbnail;
  String? name;

  ImageModel(
      {this.id,
        this.characterId,
        this.newCharacterId,
        this.searchTag,
        this.linkUrl,
        this.price,
        this.numberSet,
        this.thumbnail,
        this.name});

  ImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    characterId = json['characterId'];
    newCharacterId = json['newCharacterId'];
    searchTag = json['searchTag'].cast<String>();
    linkUrl = json['linkUrl'];
    price = json['price'];
    numberSet = json['numberSet'];
    thumbnail = json['thumbnail'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['characterId'] = this.characterId;
    data['newCharacterId'] = this.newCharacterId;
    data['searchTag'] = this.searchTag;
    data['linkUrl'] = this.linkUrl;
    data['price'] = this.price;
    data['numberSet'] = this.numberSet;
    data['thumbnail'] = this.thumbnail;
    data['name'] = this.name;
    return data;
  }
}