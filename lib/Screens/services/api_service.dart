
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000";

  // SIGNUP API
  static Future<Map<String, dynamic>> signup(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/signup"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "email": email.trim(),
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(data);
      }

      throw Exception(data["detail"] ?? "Signup failed");
    } catch (e) {
      print("SIGNUP ERROR: $e");
      rethrow;
    }
  }

  // LOGIN API
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "email": email.trim(),
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(data);
      }

      throw Exception(data["detail"] ?? "Login failed");
    } catch (e) {
      print("LOGIN ERROR: $e");
      rethrow;
    }
  }

  // ADD TASK API - SAVE TASK IN MYSQL
  static Future<void> addTask({
    required String title,
    required String description,
    required DateTime dueDate,
    required String priority,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/tasks"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "title": title,
          "description": description,
          "due_date": dueDate.toIso8601String().split('T')[0],
          "priority": priority,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("TASK SAVED SUCCESSFULLY");
        print(response.body);
        return;
      }

      throw Exception(data["detail"] ?? "Task save failed");
    } catch (e) {
      print("ADD TASK ERROR: $e");
      rethrow;
    }
  }

  // GET TASKS API - FETCH TASKS FROM MYSQL
  static Future<List<Map<String, dynamic>>> getTasks(
      String token) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/tasks"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(data);
      }

      throw Exception(data["detail"] ?? "Could not load tasks");
    } catch (e) {
      print("GET TASKS ERROR: $e");
      rethrow;
    }
  }
}
