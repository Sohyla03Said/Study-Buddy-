import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =  'http://192.168.206.62';
  static const String tokenKey = 'auth_token';

  // Get stored token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // Store token
  Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  // Remove token
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  // Get headers with authentication
  Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Authentication endpoints
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storeToken(data['access_token']);
      return data;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> register(String email, String password, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'role': role,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  Future<void> logout() async {
    await removeToken();
  }

  // User endpoints
  Future<Map<String, dynamic>> getUserProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/profile'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user profile: ${response.body}');
    }
  }

  // Assessment endpoints
  Future<List<dynamic>> getAssessments() async {
    final response = await http.get(
      Uri.parse('$baseUrl/assessments'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get assessments: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> createAssessment(Map<String, dynamic> assessmentData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/assessments'),
      headers: await getHeaders(),
      body: jsonEncode(assessmentData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create assessment: ${response.body}');
    }
  }

  // Lesson endpoints
  Future<List<dynamic>> getLessons() async {
    final response = await http.get(
      Uri.parse('$baseUrl/lessons'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get lessons: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> createLesson(Map<String, dynamic> lessonData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/lessons'),
      headers: await getHeaders(),
      body: jsonEncode(lessonData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create lesson: ${response.body}');
    }
  }

  // Quiz endpoints
  Future<Map<String, dynamic>> submitQuiz(String quizId, List<Map<String, dynamic>> answers) async {
    final response = await http.post(
      Uri.parse('$baseUrl/quiz/$quizId/submit'),
      headers: await getHeaders(),
      body: jsonEncode({'answers': answers}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to submit quiz: ${response.body}');
    }
  }

  // File upload endpoint
  Future<Map<String, dynamic>> uploadFile(File file, String endpoint) async {
    final token = await getToken();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/$endpoint'),
    );

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('File upload failed: ${response.body}');
    }
  }

  // Progress tracking
  Future<Map<String, dynamic>> updateProgress(String lessonId, double progress) async {
    final response = await http.post(
      Uri.parse('$baseUrl/progress'),
      headers: await getHeaders(),
      body: jsonEncode({
        'lesson_id': lessonId,
        'progress': progress,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update progress: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getProgress(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/progress/$userId'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get progress: ${response.body}');
    }
  }
}