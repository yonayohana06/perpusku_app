import '../models/borrowing_detail_model.dart';
import '../models/borrowing_model.dart';
import '../services/borrowing_api_service.dart';

class BorrowingRepository {
  final BorrowingApiService borrowingApiService;

  BorrowingRepository({required this.borrowingApiService});

  Future<List<BorrowingModel>> getAllBorrowing() async {
    final response = await borrowingApiService.getAllBorrowing();
    final List data = response.data['data'] ?? [];
    return data.map((json) => BorrowingModel.fromJson(json)).toList();
  }

  Future<void> createBorrowing(Map<String, dynamic> data) async {
    // Memanggil API Service, jika gagal akan dilempar ke Cubit lewat ApiException
    await borrowingApiService.createBorrowing(data);
  }

  Future<BorrowingDetailModel> getBorrowingDetail(String id) async {
    final response = await borrowingApiService.getBorrowingDetail(id);
    final data = response.data['data'];
    return BorrowingDetailModel.fromJson(data);
  }

  Future<void> updateBorrowing(Map<String, dynamic> data) async {
    await borrowingApiService.updateBorrowing(data);
  }

  Future<void> deleteBorrowing(String id) async {
    await borrowingApiService.deleteBorrowing({"id_peminjaman": id});
  }
}
