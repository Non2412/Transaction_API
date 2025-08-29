import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TimesationController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _transactions = [];
  
  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get transactions => _transactions;

  // API Configuration
  static const String baseUrl = 'https://transactions-cs.vercel.app';
  static const String apiKey = 'YOUR_API_KEY_HERE'; // ใส่ API Key ของคุณที่นี่

  // Headers สำหรับ API requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey', // หรือใช้ X-API-Key แทน
    // 'X-API-Key': apiKey, // ใช้อันนี้แทนถ้า API ต้องการ X-API-Key
  };

  // สร้างธุรกรรมใหม่
  Future<bool> createTransaction({
    required String name,
    required String desc,
    required double amount,
    required int type,
    String? date,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final transactionData = {
        'name': name,
        'desc': desc,
        'amount': amount,
        'type': type,
        'date': date ?? DateTime.now().toIso8601String().split('T')[0],
      };

      final response = await http.post(
        Uri.parse('$baseUrl/api/transaction'),
        headers: _headers,
        body: json.encode(transactionData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          // เพิ่มธุรกรรมใหม่ลงใน list
          _transactions.add({
            ...transactionData,
            'id': responseData['id'] ?? DateTime.now().millisecondsSinceEpoch,
          });
          notifyListeners();
          return true;
        } else {
          _setError(responseData['message'] ?? 'เกิดข้อผิดพลาดในการสร้างธุรกรรม');
          return false;
        }
      } else if (response.statusCode == 401) {
        _setError('ไม่มีสิทธิ์เข้าถึง กรุณาตรวจสอบ API Key');
        return false;
      } else {
        _setError('เกิดข้อผิดพลาด: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _setError('เกิดข้อผิดพลาดในการเชื่อมต่อ: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ดึงรายการธุรกรรมทั้งหมด
  Future<void> fetchTransactions() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/transactions'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          _transactions = List<Map<String, dynamic>>.from(responseData['data']);
          notifyListeners();
        } else {
          _setError(responseData['message'] ?? 'ไม่สามารถดึงข้อมูลได้');
        }
      } else if (response.statusCode == 401) {
        _setError('ไม่มีสิทธิ์เข้าถึง กรุณาตรวจสอบ API Key');
      } else {
        _setError('เกิดข้อผิดพลาด: ${response.statusCode}');
      }
    } catch (e) {
      _setError('เกิดข้อผิดพลาดในการเชื่อมต่อ: $e');
    } finally {
      _setLoading(false);
    }
  }

  // อัพเดทธุรกรรม
  Future<bool> updateTransaction({
    required String id,
    required String name,
    required String desc,
    required double amount,
    required int type,
    String? date,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final transactionData = {
        'name': name,
        'desc': desc,
        'amount': amount,
        'type': type,
        'date': date ?? DateTime.now().toIso8601String().split('T')[0],
      };

      final response = await http.put(
        Uri.parse('$baseUrl/api/transaction/$id'),
        headers: _headers,
        body: json.encode(transactionData),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          // อัพเดท transaction ใน list
          final index = _transactions.indexWhere((t) => t['id'].toString() == id);
          if (index != -1) {
            _transactions[index] = {...transactionData, 'id': id};
            notifyListeners();
          }
          return true;
        } else {
          _setError(responseData['message'] ?? 'เกิดข้อผิดพลาดในการอัพเดท');
          return false;
        }
      } else if (response.statusCode == 401) {
        _setError('ไม่มีสิทธิ์เข้าถึง กรุณาตรวจสอบ API Key');
        return false;
      } else {
        _setError('เกิดข้อผิดพลาด: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _setError('เกิดข้อผิดพลาดในการเชื่อมต่อ: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ลบธุรกรรม
  Future<bool> deleteTransaction(String id) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/transaction/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          // ลบ transaction จาก list
          _transactions.removeWhere((t) => t['id'].toString() == id);
          notifyListeners();
          return true;
        } else {
          _setError(responseData['message'] ?? 'เกิดข้อผิดพลาดในการลบ');
          return false;
        }
      } else if (response.statusCode == 401) {
        _setError('ไม่มีสิทธิ์เข้าถึง กรุณาตรวจสอบ API Key');
        return false;
      } else {
        _setError('เกิดข้อผิดพลาด: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _setError('เกิดข้อผิดพลาดในการเชื่อมต่อ: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // คำนวณยอดรวม
  double getTotalIncome() {
    return _transactions
        .where((t) => t['type'] == 1) // รายรับ
        .fold(0.0, (sum, t) => sum + (t['amount'] as num).toDouble());
  }

  double getTotalExpense() {
    return _transactions
        .where((t) => t['type'] == -1) // รายจ่าย
        .fold(0.0, (sum, t) => sum + (t['amount'] as num).toDouble());
  }

  double getBalance() {
    return getTotalIncome() - getTotalExpense();
  }

  // ฟิลเตอร์ธุรกรรมตามประเภท
  List<Map<String, dynamic>> getTransactionsByType(int type) {
    return _transactions.where((t) => t['type'] == type).toList();
  }

  // ฟิลเตอร์ธุรกรรมตามวันที่
  List<Map<String, dynamic>> getTransactionsByDate(String date) {
    return _transactions.where((t) => t['date'] == date).toList();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }
}