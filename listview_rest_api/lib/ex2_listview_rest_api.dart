import 'package:flutter/material.dart';
import 'job_listview.dart'; // Import file yang berisi tampilan daftar pekerjaan

void main() {
  runApp(const MyApp()); // Menjalankan aplikasi dengan widget utama MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Portal',
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Job Portal'), // Judul pada AppBar
        ),
        body: const Center(
          child: JobsListView(), // Memanggil widget yang menampilkan daftar pekerjaan
        ),
      ),
      debugShowCheckedModeBanner: false, // Menghilangkan banner "debug" di pojok kanan atas
    );
  }
}
