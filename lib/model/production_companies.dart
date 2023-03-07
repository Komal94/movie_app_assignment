class ProductionCompany {
  final int? id;
  final String? name;
  final String? logoPath;

  ProductionCompany({this.id, this.name, this.logoPath});

  factory ProductionCompany.fromJson(Map<String, dynamic> json) {
    return ProductionCompany(
        id: json['id'], name: json['name'], logoPath: json['logo_path']);
  }
}
