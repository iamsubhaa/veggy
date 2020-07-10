class Product{
  String id;
  String name;
  String unit;
  int price;
  int stock;
  int off;
  String image;
  Product({this.id,this.name,this.unit,this.price,this.stock,this.off,this.image});
  factory Product.fromJSON(Map<String,dynamic> json){
    return Product(
      id: json['id'].toString(),
      name: json['name'].toString(),
      unit: json['unit'].toString(),
      price: json['price'],
      stock: json['stock'],
      off: json['off'],
      image: json['image'].toString()
    );
  }
}