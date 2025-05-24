class Album {
  final int userId; // Menyimpan ID pengguna yang memiliki album ini
  final int id;     
  final String title; 

  const Album({
    required this.userId, // Properti wajib diisi saat membuat objek Album
    required this.id,
    required this.title,
    
  });
  factory Album.fromJson(Map<String, dynamic> json) {
  return Album(
    userId: json['userId'], // Mengambil nilai 'userId' dari JSON dan mengisi ke konstruktor
    id: json['id'],         
    title: json['title'],   
  );
}

}
