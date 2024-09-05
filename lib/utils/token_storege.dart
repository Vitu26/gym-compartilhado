import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Save the bearer token to SharedPreferences
Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('bearer_token', token);
  debugPrint('Token saved: $token');
}


Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('bearer_token');

  final response = await http.get(
    Uri.parse('https://developerxpb.com.br/api/ping'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 401) {

    return await _refreshBearerToken();
  }
  return prefs.getString('bearer_token');
}


Future<String?> _refreshBearerToken() async {
  try {
    final response = await http.post(
      Uri.parse('https://developerxpb.com.br/api/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'secret':
            'PbFpGjwWNsOlWGyOcXIQD7MXhyLvlqV7I7jkBRCVv4RfdsmSSMdhsnr62t5sjjmF'
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];
      await saveToken(token);
      return token;
    } else {
      debugPrint(
          'Failed to refresh token, status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    debugPrint('Error refreshing token: $e');
    return null;
  }
}
