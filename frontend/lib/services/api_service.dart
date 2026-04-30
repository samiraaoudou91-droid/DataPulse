import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {

  static const String productionUrl = 'https://datapulse-backend-kecz.onrender.com/api';

  static String get apiProductionUrl {
    // À changer en productionUrl lors du déploiement
    return productionUrl;
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
        Uri.parse('$apiProductionUrl/insights'),
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
      String url = '$apiProductionUrl/insights?sortBy=$sortBy';
      if (category != null && category != 'Toutes') url += '&category=$category';
      if (region != null) url += '&region=$region';

      final response = await http.get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> rawInsights = data['data'] ?? [];

        // --- CORRECTION ICI : Conversion sécurisée du texte en nombre ---
        return rawInsights.map((item) {
          if (item['adoption_rate'] != null) {
            // On transforme la String "50.00..." en double 50.0
            item['adoption_rate'] = double.tryParse(item['adoption_rate'].toString()) ?? 0.0;
          }
          return item;
        }).toList();
        
      } else {
        throw Exception('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau ou conversion: $e');
    }
  }

static Future<Map<String, dynamic>> fetchInsightDetails(String id) async {
  try {
    final response = await http.get(Uri.parse('$apiProductionUrl/insights/$id'))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final insight = data['data'] ?? {};

      // Même correction ici pour éviter le crash sur la page de détails
      if (insight['adoption_rate'] != null) {
        insight['adoption_rate'] = double.tryParse(insight['adoption_rate'].toString()) ?? 0.0;
      }
      
      return insight;
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
        Uri.parse('$apiProductionUrl/analytics/summary'),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        // CORRECTION : On s'assure que les chiffres du résumé sont bien des nombres
        if (data['average_adoption'] != null) {
          data['average_adoption'] = double.tryParse(data['average_adoption'].toString()) ?? 0.0;
        }
        return data;
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
        Uri.parse('$apiProductionUrl/analytics/timeline'),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> timeline = responseData['data'] ?? [];

        // CORRECTION : Conversion pour chaque point du graphique (Timeline)
        return timeline.map((point) {
          if (point['avg_adoption'] != null) {
            point['avg_adoption'] = double.tryParse(point['avg_adoption'].toString()) ?? 0.0;
          }
          return point;
        }).toList();
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
      final response = await http.get(Uri.parse('$apiProductionUrl/health'))
          .timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
