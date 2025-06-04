import 'package:http/http.dart' as http;
import 'dart:convert';

class TodoService {
  static const String baseUrl = "https://todoappbackend-dsx2.onrender.com/api/v1/todos";

  static Future<List<Map<String, dynamic>>> fetchTodos() async {
    final response = await http.get(Uri.parse("$baseUrl/todoDashboard"));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception("Failed to load todos");
    }
  }

  static Future<void> createTodo(String title, String description) async {
    final response = await http.post(
      Uri.parse("$baseUrl/create"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"title": title, "description": description}),
    );
    if (response.statusCode != 201) throw Exception("Failed to create todo");
  }

  static Future<void> updateTodo(String id, String title, String description) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/updateTodo"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id, "title": title, "description": description}),
    );
    if (response.statusCode != 200) throw Exception("Failed to update todo");
  }

  static Future<void> deleteTodo(String id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/deleteTodo"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id}),
    );
    if (response.statusCode != 200) throw Exception("Failed to delete todo");
  }

  static Future<void> toggleTodoStatus(String id, bool isCompleted) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/toggleStatus"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id, "isCompleted": isCompleted}),
    );
    if (response.statusCode != 200) throw Exception("Failed to toggle todo status");
  }
}
