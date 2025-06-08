import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TodoService {
  static const String baseUrl =
      "https://todoappbackend-dsx2.onrender.com/api/v1/todos";

  // Helper to get token from SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // Fetch Todos
  static Future<Map<String, List<Map<String, dynamic>>>> fetchTodos() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/todoDashboard"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "cookie": "token=$token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final completed = List<Map<String, dynamic>>.from(
        data['data']['completedTodos'],
      );
      final notCompleted = List<Map<String, dynamic>>.from(
        data['data']['notCompletedTodos'],
      );

      List<Map<String, dynamic>> normalize(
        List<Map<String, dynamic>> todos,
        bool done,
      ) {
        return todos
            .map(
              (todo) => {
                'id': todo['_id'],
                'task': todo['title'],
                'done': done,
                'createdAt': DateTime.now(),
                'updatedAt': null,
              },
            )
            .toList();
      }

      return {
        'completed': normalize(completed, true),
        'notCompleted': normalize(notCompleted, false),
      };
    } else {
      throw Exception("Failed to load todos");
    }
  }

  // ✅ Create Todo (updated to handle nested `data`)
  static Future<Map<String, dynamic>> createTodo(
    String title,
    String description,
  ) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse("$baseUrl/create"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "cookie": "token=$token",
      },
      body: jsonEncode({"title": title, "description": description}),
    );

    // print("📡 Request: $title, $description");
    // print("🔁 Response Code: ${response.statusCode}");
    // print("📦 Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];

      return {
        'id': data['_id'],
        'task': data['title'],
        'done': data['isCompleted'] ?? false,
        'createdAt': DateTime.now(),
        'updatedAt': null,
      };
    } else {
      throw Exception('Failed to create Todo');
    }
  }

  // Update Todo
  static Future<void> updateTodo(
    String id,
    String title,
    String description,
  ) async {
    final token = await _getToken();

    final response = await http.patch(
      Uri.parse("$baseUrl/updateTodo"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "cookie": "token=$token",
      },
      body: jsonEncode({"id": id, "title": title, "description": description}),
    );

    if (response.statusCode != 200) throw Exception("Failed to update todo");
  }

  // Delete Todo
  static Future<void> deleteTodo(String id) async {
    final token = await _getToken();

    final response = await http.delete(
      Uri.parse("$baseUrl/deleteTodo"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "cookie": "token=$token",
      },
      body: jsonEncode({"id": id}),
    );

    if (response.statusCode != 200) throw Exception("Failed to delete todo");
  }

  // Toggle Todo Status
  static Future<void> toggleTodoStatus(String id, bool isCompleted) async {
    final token = await _getToken();

    final response = await http.patch(
      Uri.parse("$baseUrl/toggleStatus"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "cookie": "token=$token",
      },
      body: jsonEncode({"id": id, "isCompleted": isCompleted}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to toggle todo status");
    }
  }
}
