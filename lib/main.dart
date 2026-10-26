import 'package:flutter/material.dart';

void main() {
  runApp(const CalmSpaceApp());
}

class CalmSpaceApp extends StatelessWidget {
  const CalmSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalmSpace',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class MoodEntry {
  final String mood;
  final String note;
  final String date;

  MoodEntry({required this.mood, required this.note, required this.date});
}

List<MoodEntry> globalMoodList = [
  MoodEntry(mood: 'Tenang 😌', note: 'Hari ini cukup produktif dan santai.', date: 'Hari ini'),
  MoodEntry(mood: 'Cemas 😰', note: 'Banyak tugas menumpuk menjelang deadline.', date: 'Kemarin'),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CalmSpace - Beranda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Halo, Selamat Datang! 🌿',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Bagaimana kondisi mentalmu hari ini? Luangkan waktu sejenak untuk refleksi.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const InfoCard(
              title: 'Tips Hari Ini', 
              subtitle: 'Lakukan pernapasan dalam selama 2 menit jika mulai merasa lelah.',
              color: Colors.tealAccent,
            ),
            const SizedBox(height: 12),
            const InfoCard(
              title: 'Kutipan Positif', 
              subtitle: '"Kamu sudah berjuang dengan baik sampai detik ini."',
              color: Colors.orangeAccent,
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryScreen()),
                );
              },
              icon: const Icon(Icons.list),
              label: const Text('Lihat Riwayat Catatan Mood'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddMoodScreen()),
                );
                (context as Element).markNeedsBuild();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, 
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.add),
              label: const Text('Catat Mood Baru'),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      // Menggunakan withValues menggantikan withOpacity agar bersih dari deprecation
      color: color.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Emosi'),
      ),
      body: globalMoodList.isEmpty
          ? const Center(child: Text('Belum ada catatan mood.'))
          : ListView.builder(
              itemCount: globalMoodList.length,
              itemBuilder: (context, index) {
                final item = globalMoodList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.favorite, color: Colors.white),
                    ),
                    title: Text(item.mood, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${item.note}\n(${item.date})'),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}

class AddMoodScreen extends StatefulWidget {
  const AddMoodScreen({super.key});

  @override
  State<AddMoodScreen> createState() => _AddMoodScreenState();
}

class _AddMoodScreenState extends State<AddMoodScreen> {
  final _formKey = GlobalKey<FormState>();
  
  String _selectedMood = 'Tenang 😌';
  final TextEditingController _noteController = TextEditingController();

  final List<String> _moodOptions = ['Tenang 😌', 'Senang 😊', 'Cemas 😰', 'Sedih 😢', 'Marah 😡'];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Catatan Baru'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Pilih Kondisi Emosi:', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                // Menggunakan initialValue sesuai update Flutter terbaru
                initialValue: _selectedMood,
                items: _moodOptions.map((String mood) {
                  return DropdownMenuItem<String>(
                    value: mood,
                    child: Text(mood),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMood = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text('Catatan / Pemicu:', style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  hintText: 'Misal: Banyak tugas kuliah hari ini...',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Catatan tidak boleh kosong!';
                  }
                  return null;
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      globalMoodList.add(
                        MoodEntry(
                          mood: _selectedMood,
                          note: _noteController.text,
                          date: 'Baru saja',
                        ),
                      );
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Catatan berhasil disimpan!')),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, 
                  foregroundColor: Colors.white,
                ),
                child: const Text('Simpan Catatan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}