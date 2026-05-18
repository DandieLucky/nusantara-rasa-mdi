class FoodModel {
  final String id;
  final String name;
  final String daerah;
  final String kategoriWilayah;
  final String image;
  final String deskripsi;
  final String sejarah;
  final List<String> bahanUtama;
  final String keunikan;
  final double rating;
  final bool isFavorite;

  FoodModel({
    required this.id,
    required this.name,
    required this.daerah,
    required this.kategoriWilayah,
    required this.image,
    required this.deskripsi,
    required this.sejarah,
    required this.bahanUtama,
    required this.keunikan,
    required this.rating,
    this.isFavorite = false,
  });

  FoodModel copyWith({bool? isFavorite}) {
    return FoodModel(
      id: id,
      name: name,
      daerah: daerah,
      kategoriWilayah: kategoriWilayah,
      image: image,
      deskripsi: deskripsi,
      sejarah: sejarah,
      bahanUtama: bahanUtama,
      keunikan: keunikan,
      rating: rating,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
