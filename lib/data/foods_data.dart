import '../models/food_model.dart';

List<FoodModel> getAllFoods() {
  return [
    FoodModel(
      id: '1',
      name: 'Rendang Sapi',
      daerah: 'Sumatera Barat',
      kategoriWilayah: 'Sumatera',
      image:
          'https://images.unsplash.com/photo-1626844131082-256783844137?w=800&auto=format&fit=crop',
      deskripsi:
          'Hidangan daging sapi bercita rasa pedas yang menggunakan campuran dari berbagai bumbu dan rempah-rempah.',
      sejarah:
          'Rendang telah ada sejak dahulu kala dan diakui sebagai salah satu makanan terenak di dunia.',
      bahanUtama: ['Daging sapi', 'Santan', 'Cabai', 'Rempah-rempah'],
      keunikan:
          'Semakin dipanaskan, bumbunya akan semakin meresap dan awet tahan lama.',
      rating: 4.9,
    ),
    FoodModel(
      id: '2',
      name: 'Pempek Kapal Selam',
      daerah: 'Palembang',
      kategoriWilayah: 'Sumatera',
      image:
          'https://images.unsplash.com/photo-1564834724105-918b73d1b9e0?w=800&auto=format&fit=crop',
      deskripsi:
          'Makanan khas dari olahan daging ikan dan tepung kanji, disajikan dengan kuah cuka.',
      sejarah:
          'Berawal dari melimpahnya hasil ikan di Sungai Musi, masyarakat mengolahnya agar tahan lama.',
      bahanUtama: ['Ikan Tenggiri', 'Tepung Sagu', 'Telur', 'Cuko'],
      keunikan:
          'Rasa kuah cuko yang memadukan pedas, asam, dan manis secara bersamaan.',
      rating: 4.8,
    ),
    FoodModel(
      id: '3',
      name: 'Gudeg Nangka',
      daerah: 'Yogyakarta',
      kategoriWilayah: 'Jawa',
      image:
          'https://images.unsplash.com/photo-1548943487-a2e4f43b4850?w=800&auto=format&fit=crop',
      deskripsi:
          'Sayur nangka muda yang dimasak lambat dengan santan dan gula aren.',
      sejarah:
          'Gudeg dipercaya sudah ada sejak awal berdirinya Kasultanan Mataram.',
      bahanUtama: ['Nangka Muda', 'Gula Aren', 'Santan', 'Daun Jati'],
      keunikan:
          'Warnanya yang cokelat kemerahan berasal dari daun jati yang dimasak bersamaan.',
      rating: 4.7,
    ),
  ];
}
