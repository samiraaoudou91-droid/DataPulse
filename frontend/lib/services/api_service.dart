import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // À changer avec l'URL de déploiement réelle
  static const String baseUrl = 'https://datapulse-frontend-gjf8.onrender.com/api';

  // Pour production: utiliser l'URL du serveur déployé
  static const String productionUrl = 'https://datapulse-backend-kecz.onrender.com/api';

  static String get apiBaseUrl {
    // À changer en productionUrl lors du déploiement
    return baseUrl;
  }

  // =============== INSIGHTS ===============

  static Future<Map<String, dynamic>> createInsight({
    required String title,
    required String category,
    required String description,
    String? region,
    String impactLevel = 'medium',
    double? adoptionRate,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/insights'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'category': category,
          'description': description,
          'region': region ?? 'Global',
          'impact_level': impactLevel,
          'adoption_rate': adoptionRate ?? 0.0,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur réseau: $e');
    }
  }

  static Future<List<dynamic>> fetchInsights({
    String? category,
    String? region,
    String sortBy = 'creation_date',
  }) async {
    try {
      String url = '$apiBaseUrl/insights?sortBy=$sortBy';
      if (category != null) url += '&category=$category';
      if (region != null) url += '&region=$region';

      final response = await http.get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? [];
      } else {
        throw Exception('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau: $e');
    }
  }

  static Future<Map<String, dynamic>> fetchInsightDetails(String id) async {
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/insights/$id'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? {};
      } else {
        throw Exception('Insight non trouvé');
      }
    } catch (e) {
      throw Exception('Erreur réseau: $e');
    }
  }

  // =============== ANALYTICS ===============

  static Future<Map<String, dynamic>> fetchAnalyticsSummary() async {
    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl/analytics/summary'),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur analytics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau: $e');
    }
  }

  static Future<List<dynamic>> fetchTimeline() async {
    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl/analytics/timeline'),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? [];
      } else {
        throw Exception('Erreur timeline: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau: $e');
    }
  }

  // =============== HEALTH ===============

  static Future<bool> checkHealth() async {
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/health'))
          .timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
