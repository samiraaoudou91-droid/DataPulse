// ============== INSIGHT MODEL ==============

class Insight {
  final String id;
  final String title;
  final String category;
  final String description;
  final String region;
  final String impactLevel;
  final double adoptionRate;
  final DateTime creationDate;
  final DateTime updatedDate;
  final List<Technology>? technologies;
  final List<Challenge>? challenges;

  Insight({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.region,
    required this.impactLevel,
    required this.adoptionRate,
    required this.creationDate,
    required this.updatedDate,
    this.technologies,
    this.challenges,
  });

  factory Insight.fromJson(Map<String, dynamic> json) {
    return Insight(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      region: json['region'] ?? 'Global',
      impactLevel: json['impact_level'] ?? 'medium',
      // CORRECTION : double.tryParse gère le texte "50.00"
      adoptionRate: double.tryParse(json['adoption_rate']?.toString() ?? '0') ?? 0.0,
      creationDate: json['creation_date'] != null
          ? DateTime.parse(json['creation_date'])
          : DateTime.now(),
      updatedDate: json['updated_date'] != null
          ? DateTime.parse(json['updated_date'])
          : DateTime.now(),
      technologies: (json['technologies'] as List?)
          ?.map((e) => Technology.fromJson(e))
          .toList(),
      challenges: (json['challenges'] as List?)
          ?.map((e) => Challenge.fromJson(e))
          .toList(),
    );
  }
}

// ============== TECHNOLOGY MODEL ==============

class Technology {
  final String id;
  final String name;
  final String category;
  final String? maturityLevel;
  final double adoptionPercentage;
  final String insightId;

  Technology({
    required this.id,
    required this.name,
    required this.category,
    this.maturityLevel,
    required this.adoptionPercentage,
    required this.insightId,
  });

  factory Technology.fromJson(Map<String, dynamic> json) {
    return Technology(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      maturityLevel: json['maturity_level'],
      // CORRECTION
      adoptionPercentage: double.tryParse(json['adoption_percentage']?.toString() ?? '0') ?? 0.0,
      insightId: json['insight_id'] ?? '',
    );
  }
}

// ============== ANALYTICS SUMMARY ==============

class AnalyticsSummary {
  final int totalInsights;
  final int totalTechnologies;
  final int uniqueRegions;
  final double avgAdoptionRate;
  final List<CategoryStat> categories;
  final List<RegionStat> regions;
  final List<ImpactStat> impactDistribution;
  final AdoptionStats adoptionStats;

  AnalyticsSummary({
    required this.totalInsights,
    required this.totalTechnologies,
    required this.uniqueRegions,
    required this.avgAdoptionRate,
    required this.categories,
    required this.regions,
    required this.impactDistribution,
    required this.adoptionStats,
  });

  factory AnalyticsSummary.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] ?? {};
    final catList = (json['categories'] as List?)
        ?.map((e) => CategoryStat.fromJson(e))
        .toList() ?? [];
    final regList = (json['regions'] as List?)
        ?.map((e) => RegionStat.fromJson(e))
        .toList() ?? [];
    final impList = (json['impactDistribution'] as List?)
        ?.map((e) => ImpactStat.fromJson(e))
        .toList() ?? [];
    
    // CORRECTION : on vérifie si la liste n'est pas vide avant de prendre [0]
    final adoptStatsData = (json['adoptionStats'] as List?)?.isNotEmpty == true 
        ? json['adoptionStats'][0] 
        : {};

    return AnalyticsSummary(
      totalInsights: int.tryParse(summary['total_insights']?.toString() ?? '0') ?? 0,
      totalTechnologies: int.tryParse(summary['total_technologies']?.toString() ?? '0') ?? 0,
      uniqueRegions: int.tryParse(summary['unique_regions']?.toString() ?? '0') ?? 0,
      // CORRECTION
      avgAdoptionRate: double.tryParse(summary['avg_adoption_rate']?.toString() ?? '0') ?? 0.0,
      categories: catList,
      regions: regList,
      impactDistribution: impList,
      adoptionStats: AdoptionStats.fromJson(adoptStatsData),
    );
  }
}

class AdoptionStats {
  final double minAdoption;
  final double maxAdoption;
  final double avgAdoption;
  final double medianAdoption;

  AdoptionStats({
    required this.minAdoption,
    required this.maxAdoption,
    required this.avgAdoption,
    required this.medianAdoption,
  });

  factory AdoptionStats.fromJson(Map<String, dynamic> json) {
    return AdoptionStats(
      // CORRECTION SYSTEMATIQUE
      minAdoption: double.tryParse(json['min_adoption']?.toString() ?? '0') ?? 0.0,
      maxAdoption: double.tryParse(json['max_adoption']?.toString() ?? '100') ?? 100.0,
      avgAdoption: double.tryParse(json['avg_adoption']?.toString() ?? '50') ?? 50.0,
      medianAdoption: double.tryParse(json['median_adoption']?.toString() ?? '50') ?? 50.0,
    );
  }
}

// Les classes CategoryStat, RegionStat et ImpactStat ne changent pas 
// car elles utilisent des entiers (int) qui sont généralement bien gérés.



