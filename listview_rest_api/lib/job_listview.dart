import 'dart:convert'; 
import 'dart:async'; 
import 'package:flutter/material.dart'; // UI Flutter
import 'package:http/http.dart' as http; // Untuk akses HTTP (API)
import 'job.dart'; 

// Widget utama yang menggunakan StatefulWidget agar bisa update tampilan
class JobsListView extends StatefulWidget {
  const JobsListView({super.key});

  @override
  State<JobsListView> createState() => _JobsListViewState();
}

class _JobsListViewState extends State<JobsListView> {
  late Future<List<Job>> jobListFuture; // Menyimpan hasil Future dari API
  String? selectedJobTitle; // Menyimpan nama pekerjaan yang dipilih

  @override
  void initState() {
    super.initState();
    jobListFuture = fetchJobData(); // Inisialisasi dengan memanggil API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Job>>(
        future: jobListFuture, 
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Jika ada error, tampilkan pesan error
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }

          // Ambil data dari snapshot
          final jobs = snapshot.data ?? [];

        
          if (jobs.isEmpty) {
            return const Center(child: Text("Belum ada data pekerjaan."));
          }

          // Tampilkan daftar pekerjaan dalam ListView
          return ListView.separated(
            itemCount: jobs.length, // Jumlah item
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, index) {
              final job = jobs[index]; 
              return ListTile(
                leading: const Icon(Icons.work_outline, color: Colors.indigo), // Icon 
                title: Text(
                  job.position, // Nama posisi
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(job.company), 
                onTap: () {
                  setState(() {
                    selectedJobTitle = job.position; // Simpan pilihan
                  });
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: selectedJobTitle != null
          ? Container(
              padding: const EdgeInsets.all(14),
              color: Colors.black87, 
              child: Text(
                "Anda memilih: $selectedJobTitle", 
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : null, 
    );
  }

  // Fungsi untuk mengambil data dari API
  Future<List<Job>> fetchJobData() async {
    try {
      final url = Uri.parse('https://mock-json-service.glitch.me'); // URL API
      final response = await http.get(url).timeout(const Duration(seconds: 5)); 

      if (response.statusCode == 200) {
        final List<dynamic> jsonResult = json.decode(response.body); 
        return jsonResult.map((e) => Job.fromJson(e)).toList(); 
      } else {
        return getOfflineJobs(); 
      }
    } catch (_) {
      return getOfflineJobs(); 
    }
  }

  // Data lokal jika API gagal
  List<Job> getOfflineJobs() {
    return [
      Job(id: 101, position: 'Software Engineer', company: 'Apple', description: ''),
      Job(id: 102, position: 'Software Engineering Manager', company: 'Google', description: ''),
      Job(id: 103, position: 'System Engineer', company: 'Microsoft', description: ''),
      Job(id: 104, position: 'Data Scientist', company: 'DBS', description: ''),
      Job(id: 105, position: 'ReactJS Developer', company: 'Smart', description: ''),
    ];
  }
}
