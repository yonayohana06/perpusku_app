class ApiEndpoints {
  static const String baseUrl = 'http://10.0.2.2:8001/api/v1';

  // --- Auth Endpoints ---
  static const String login = '/login';
  // --- Books Endpoints ---
  static const String books = '/buku';
  // --- Master Data Endpoints (Admin) ---
  static const String bookCategories = '/admin/buku/jenbuk';
  static const String authors = '/admin/buku/author';
  static const String publishers = '/admin/buku/penbuk';
  // --- Peminjaman Endpoints (Admin) ---
  static const String borrowing = '/admin/peminjaman';
  static const String fines = '/admin/denda';
}
