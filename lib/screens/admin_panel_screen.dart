import 'dart:ui';
import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';

class AdminPanelScreen extends StatefulWidget {
  final int userId;
  const AdminPanelScreen({super.key, required this.userId});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  List<Map<String, dynamic>> _foods = [];
  bool _isLoading = true;
  String _searchQuery = '';

  final Color rustRed = const Color(0xFFA84A3B);
  final Color textDark = const Color(0xFF3E2723);

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  Future<void> _loadFoods() async {
    setState(() => _isLoading = true);
    final foods = _searchQuery.isEmpty
        ? await DatabaseHelper.instance.getAllMakanan()
        : await DatabaseHelper.instance.searchMakanan(_searchQuery);
    setState(() {
      _foods = foods;
      _isLoading = false;
    });
  }

  void _showFoodForm({Map<String, dynamic>? food}) {
    final isEdit = food != null;
    final nameC = TextEditingController(text: food?['name'] ?? '');
    final daerahC = TextEditingController(text: food?['daerah'] ?? '');
    final imgC = TextEditingController(text: food?['img'] ?? '');
    final descC = TextEditingController(text: food?['description'] ?? '');
    final historyC = TextEditingController(text: food?['history'] ?? '');
    final ingredientsC = TextEditingController(text: food?['ingredients'] ?? '');
    final servingC = TextEditingController(text: food?['serving'] ?? '');
    final cultureC = TextEditingController(text: food?['culture'] ?? '');
    final bestTimeC = TextEditingController(text: food?['best_time'] ?? '');
    final traditionC = TextEditingController(text: food?['tradition'] ?? '');
    String selectedKategori = food?['kategori'] ?? 'Makanan Berat';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Color(0xFFFAF8F4),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: rustRed,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEdit ? '✏️ Edit Makanan' : '➕ Tambah Makanan',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  // Form
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _formField('Nama Makanan *', nameC),
                          _formField('Daerah Asal *', daerahC),
                          const SizedBox(height: 12),
                          const Text('Kategori *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: selectedKategori,
                                items: ['Makanan Berat', 'Camilan', 'Minuman']
                                    .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13))))
                                    .toList(),
                                onChanged: (v) => setModalState(() => selectedKategori = v!),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _formField('URL/Path Gambar *', imgC),
                          _formField('Deskripsi *', descC, maxLines: 3),
                          _formField('Sejarah', historyC, maxLines: 2),
                          _formField('Bahan Utama', ingredientsC),
                          _formField('Cara Penyajian', servingC),
                          _formField('Budaya', cultureC),
                          _formField('Waktu Terbaik', bestTimeC),
                          _formField('Tradisi', traditionC),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: rustRed,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () async {
                                if (nameC.text.isEmpty || daerahC.text.isEmpty || imgC.text.isEmpty || descC.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Field bertanda * wajib diisi!'), backgroundColor: Colors.red),
                                  );
                                  return;
                                }
                                final data = {
                                  'name': nameC.text, 'daerah': daerahC.text, 'kategori': selectedKategori,
                                  'img': imgC.text, 'description': descC.text, 'history': historyC.text,
                                  'ingredients': ingredientsC.text, 'serving': servingC.text,
                                  'culture': cultureC.text, 'best_time': bestTimeC.text, 'tradition': traditionC.text,
                                  'taste_gurih': '3', 'taste_pedas': '3', 'taste_manis': '3', 'taste_asam': '2',
                                };
                                if (isEdit) {
                                  await DatabaseHelper.instance.updateMakanan(food!['id'], data);
                                } else {
                                  await DatabaseHelper.instance.insertMakanan(data);
                                }
                                if (mounted) Navigator.pop(context);
                                _loadFoods();
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(isEdit ? 'Makanan berhasil diperbarui!' : 'Makanan berhasil ditambahkan!'),
                                      backgroundColor: const Color(0xFF4CAF50),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                isEdit ? 'Simpan Perubahan' : 'Tambah Makanan',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _formField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF3E2723))),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: controller, maxLines: maxLines,
              style: const TextStyle(fontSize: 13),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Map<String, dynamic> food) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hapus Makanan?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Apakah Anda yakin ingin menghapus "${food['name']}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await DatabaseHelper.instance.deleteMakanan(food['id']);
              if (mounted) Navigator.pop(ctx);
              _loadFoods();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Makanan berhasil dihapus!'), backgroundColor: Color(0xFF4CAF50)),
                );
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.admin_panel_settings, color: rustRed, size: 28),
                      const SizedBox(width: 8),
                      const Text('Admin Panel', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF3E2723))),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: rustRed.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                        child: Text('${_foods.length} data', style: TextStyle(color: rustRed, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Search bar
                  Container(
                    height: 44,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                    child: TextField(
                      onChanged: (v) { _searchQuery = v; _loadFoods(); },
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Cari makanan...', hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.search, size: 20),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // List makanan
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _foods.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.restaurant, size: 60, color: Colors.grey.shade300),
                              const SizedBox(height: 12),
                              Text('Belum ada data makanan', style: TextStyle(color: Colors.grey.shade500)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _foods.length,
                          itemBuilder: (context, index) {
                            final food = _foods[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 55, height: 55, color: Colors.grey.shade200,
                                    child: food['img'].toString().startsWith('http')
                                        ? Image.network(food['img'], fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.restaurant, color: Colors.grey))
                                        : Image.asset(food['img'], fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.restaurant, color: Colors.grey)),
                                  ),
                                ),
                                title: Text(food['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                subtitle: Text('${food['daerah']} • ${food['kategori']}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: rustRed, size: 20),
                                      onPressed: () => _showFoodForm(food: food),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                      onPressed: () => _confirmDelete(food),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFoodForm(),
        backgroundColor: rustRed,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
