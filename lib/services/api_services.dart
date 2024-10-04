// api_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = "AIzaSyAtkKiiDLF7EogK4LCoaV-aoMwxY56ys6M"; // Substitua pela sua chave de API

  Future<void> getUserLocation(Function(Position?) onUpdateLocation) async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        // Handle the case when the permission is denied
        throw Exception('Permissão de localização negada.');
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      onUpdateLocation(position);
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao obter localização: $e');
      }
    }
  }

  Future<void> placeSuggestion({
    required String input,
    required String sessionToken,
    required Position? userLocation,
    required Function(List<dynamic>) onUpdateLocationList,
  }) async {
    try {
      if (userLocation == null) {
        return; // Não faz a solicitação se a localização do usuário não estiver disponível
      }

      String baseUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json";
      String location = "${userLocation.latitude},${userLocation.longitude}";
      String radius = "50000"; // Raio em metros (50 km, ajuste conforme necessário)

      // Escape input to prevent URL encoding issues
      String escapedInput = Uri.encodeComponent(input);

      String request = '$baseUrl?input=$escapedInput&key=$apiKey&sessiontoken=$sessionToken&location=$location&radius=$radius';

      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (kDebugMode) {
          print(data);
        }
        onUpdateLocationList(data['predictions'] ?? []);
      } else {
        throw Exception("Falha ao carregar dados");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro na sugestão de local: $e');
      }
    }
  }
}
