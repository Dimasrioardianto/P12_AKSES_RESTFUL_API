import 'dart:async'; // Untuk mendukung fitur async dan Future
import 'dart:convert'; // Untuk jsonDecode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Library HTTP
import 'album.dart'; // Import file model Album

// Fungsi untuk mengambil data dari API
Future<Album> fetchAlbum() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
  );

  if (response.statusCode == 200) {
    // Jika berhasil, parse JSON menjadi objek Album
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // Jika gagal, lemparkan exception
    throw Exception('Failed to load album');
  }
}

void main() {
  runApp(const MyApp()); // Jalankan aplikasi
}

// Stateful widget utama aplikasi
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

// State dari MyApp
class _MyAppState extends State<MyApp> {
  late Future<Album> futureAlbum; // Menyimpan Future dari Album

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum(); // Inisialisasi fetch data API
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum, // Future yang akan dibuild
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Jika data berhasil dimuat
                return Text(snapshot.data!.title);
              } else if (snapshot.hasError) {
                // Jika terjadi error
                return Text('${snapshot.error}');
              }

              // Default: tampilkan loading spinner
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
