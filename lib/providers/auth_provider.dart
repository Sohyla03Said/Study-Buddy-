import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  // Replace with your actual FastAPI backend URL
  static const String _baseUrl = 'http://localhost:8000'; // Update this

  UserModel? _userModel;
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel? get userModel => _userModel;
  String? get userRole => _userModel?.role.toString().split('.').last;
  Map<String, dynamic>? get userData => _userModel?.toMap();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null && _userModel != null;
  bool get isStudent => _userModel?.role == UserRole.student;
  bool get isTeacher => _userModel?.role == UserRole.teacher;
  bool get isAdmin => _userModel?.role == UserRole.admin;
  String? get token => _token;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');

    if (_token != null) {
      await _loadUserData();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'full_name': fullName,
          'role': role.toString().split('.').last,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _token = data['access_token'];

        // Save token to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);

        await _loadUserData();
        return true;
      } else {
        final error = jsonDecode(response.body);
        _setError(error['detail'] ?? 'Registration failed');
        return false;
      }
    } catch (e) {
      _setError('Network error: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'username': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['access_token'];

        // Save token to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);

        await _loadUserData();
        return true;
      } else {
        final error = jsonDecode(response.body);
        _setError(error['detail'] ?? 'Login failed');
        return false;
      }
    } catch (e) {
      _setError('Network error: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _setError(null);

      // For Google Sign-In with FastAPI, you'll need to implement OAuth2 flow
      // This is a placeholder - you'll need to integrate with Google Sign-In package
      // and send the Google token to your FastAPI backend

      _setError('Google Sign-In not implemented yet');
      return false;
    } catch (e) {
      _setError('Google sign in failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUpWithGoogle({
    required String googleIdToken,
    required UserRole role,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/google-signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'google_token': googleIdToken,
          'role': role.toString().split('.').last,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _token = data['access_token'];

        // Save token to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);

        await _loadUserData();
        return true;
      } else {
        final error = jsonDecode(response.body);
        _setError(error['detail'] ?? 'Google sign up failed');
        return false;
      }
    } catch (e) {
      _setError('Google sign up failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      _setLoading(true);

      // Optional: Call logout endpoint if your API has one
      if (_token != null) {
        await http.post(
          Uri.parse('$_baseUrl/auth/logout'),
          headers: _headers,
        );
      }

      _token = null;
      _userModel = null;
      _errorMessage = null;

      // Clear stored data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('userRole');
      await prefs.remove('userId');

      notifyListeners();
    } catch (e) {
      _setError('Sign out failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadUserData() async {
    if (_token == null) return;

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/auth/me'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _userModel = UserModel.fromMap(data);
        notifyListeners();
      } else if (response.statusCode == 401) {
        // Token expired or invalid
        await signOut();
        _setError('Session expired. Please login again.');
      } else {
        _setError('Failed to load user data');
      }
    } catch (e) {
      _setError('Error loading user data: ${e.toString()}');
    }
  }

  Future<bool> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? institution,
    String? profileImageUrl,
  }) async {
    try {
      if (_token == null || _userModel == null) {
        _setError('User not authenticated');
        return false;
      }

      _setLoading(true);
      _setError(null);

      Map<String, dynamic> updates = {};
      if (fullName != null) updates['full_name'] = fullName;
      if (phoneNumber != null) updates['phone_number'] = phoneNumber;
      if (institution != null) updates['institution'] = institution;
      if (profileImageUrl != null) updates['profile_image_url'] = profileImageUrl;

      final response = await http.put(
        Uri.parse('$_baseUrl/auth/profile'),
        headers: _headers,
        body: jsonEncode(updates),
      );

      if (response.statusCode == 200) {
        await _loadUserData();
        return true;
      } else {
        final error = jsonDecode(response.body);
        _setError(error['detail'] ?? 'Failed to update profile');
        return false;
      }
    } catch (e) {
      _setError('Failed to update profile: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final error = jsonDecode(response.body);
        _setError(error['detail'] ?? 'Failed to send reset email');
        return false;
      }
    } catch (e) {
      _setError('Failed to send reset email: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      if (_token == null) {
        _setError('User not authenticated');
        return false;
      }

      _setLoading(true);
      _setError(null);

      final response = await http.put(
        Uri.parse('$_baseUrl/auth/change-password'),
        headers: _headers,
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final error = jsonDecode(response.body);
        _setError(error['detail'] ?? 'Failed to change password');
        return false;
      }
    } catch (e) {
      _setError('Failed to change password: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteAccount() async {
    try {
      if (_token == null) return false;

      _setLoading(true);
      _setError(null);

      final response = await http.delete(
        Uri.parse('$_baseUrl/auth/delete-account'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        _token = null;
        _userModel = null;

        // Clear stored data
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token');
        await prefs.remove('userRole');
        await prefs.remove('userId');

        notifyListeners();
        return true;
      } else {
        final error = jsonDecode(response.body);
        _setError(error['detail'] ?? 'Failed to delete account');
        return false;
      }
    } catch (e) {
      _setError('Failed to delete account: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshToken() async {
    try {
      if (_token == null) return;

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/refresh'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['access_token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);

        notifyListeners();
      } else {
        // If refresh fails, sign out
        await signOut();
      }
    } catch (e) {
      // If refresh fails, sign out
      await signOut();
    }
  }

  // Helper method to make authenticated requests
  Future<http.Response> authenticatedRequest(
      String method,
      String endpoint, {
        Map<String, dynamic>? body,
        Map<String, String>? additionalHeaders,
      }) async {
    final headers = Map<String, String>.from(_headers);
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    final uri = Uri.parse('$_baseUrl$endpoint');
    http.Response response;

    switch (method.toUpperCase()) {
      case 'GET':
        response = await http.get(uri, headers: headers);
        break;
      case 'POST':
        response = await http.post(
          uri,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
        break;
      case 'PUT':
        response = await http.put(
          uri,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
        break;
      case 'DELETE':
        response = await http.delete(uri, headers: headers);
        break;
      default:
        throw Exception('Unsupported HTTP method: $method');
    }

    // Handle token expiration
    if (response.statusCode == 401) {
      await refreshToken();
      // Retry the request with the new token
      headers['Authorization'] = 'Bearer $_token';
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
      }
    }

    return response;
  }
}