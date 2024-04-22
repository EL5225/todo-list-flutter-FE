import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

var apiUrl = dotenv.env["API_URL"];

Future<dynamic> getTodos() async {
  final response = await http.get(
    Uri.parse("$apiUrl/todos"),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data;
  } else {
    throw Exception('Failed to load todos');
  }
}

Future<dynamic> getTodoById(String id) async {
  final response = await http.get(
    Uri.parse("$apiUrl/todos/$id"),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data;
  } else {
    throw Exception('Failed to load todo');
  }
}

Future<dynamic> createTodo(String title) async {
  final response = await http.post(
    Uri.parse("$apiUrl/todos"),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'title': title}),
  );

  if (response.statusCode == 201) {
    final data = jsonDecode(response.body);
    return data;
  } else {
    throw Exception('Failed to create todo');
  }
}

Future<dynamic> updateTodo(String id, String title) async {
  final response = await http.patch(
    Uri.parse("$apiUrl/todos/$id"),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'title': title}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data;
  } else {
    throw Exception('Failed to load todo');
  }
}

Future<dynamic> doneTodo(String id) async {
  final response = await http.get(
    Uri.parse("$apiUrl/todos/$id/complete"),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data;
  } else {
    throw Exception('Failed to complete todo');
  }
}

Future<dynamic> deleteTodo(String id) async {
  final response = await http.delete(
    Uri.parse("$apiUrl/todos/$id"),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data;
  } else {
    throw Exception('Failed to delete todo');
  }
}
