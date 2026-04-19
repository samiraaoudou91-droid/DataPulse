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
      adoptionRate: (json['adoption_rate'] ?? 0).toDouble(),
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'description': description,
    'region': region,
    'impact_level': impactLevel,
    'adoption_rate': adoptionRate,
    'creation_date': creationDate.toIso8601String(),
    'updated_date': updatedDate.toIso8601String(),
  };
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
      adoptionPercentage: (json['adoption_percentage'] ?? 0).toDouble(),
      insightId: json['insight_id'] ?? '',
    );
  }
}

// ============== CHALLENGE MODEL ==============

class Challenge {
  final String id;
  final String title;
  final String description;
  final String? severity;
  final String? affectedTech;
  final String insightId;
  final DateTime createdAt;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    this.severity,
    this.affectedTech,
    required this.insightId,
    required this.createdAt,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      severity: json['severity'],
      affectedTech: json['affected_tech'],
      insightId: json['insight_id'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
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
    final adoptStats = json['adoptionStats'] != null
        ? AdoptionStats.fromJson(json['adoptionStats'][0] ?? {})
        : AdoptionStats(minAdoption: 0, maxAdoption: 100, avgAdoption: 50, medianAdoption: 50);

    return AnalyticsSummary(
      totalInsights: summary['total_insights'] ?? 0,
      totalTechnologies: summary['total_technologies'] ?? 0,
      uniqueRegions: summary['unique_regions'] ?? 0,
      avgAdoptionRate: (summary['avg_adoption_rate'] ?? 0).toDouble(),
      categories: catList,
      regions: regList,
      impactDistribution: impList,
      adoptionStats: adoptStats,
    );
  }
}

class CategoryStat {
  final String category;
  final int count;

  CategoryStat({required this.category, required this.count});

  factory CategoryStat.fromJson(Map<String, dynamic> json) {
    return CategoryStat(
      category: json['category'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}

class RegionStat {
  final String region;
  final int count;

  RegionStat({required this.region, required this.count});

  factory RegionStat.fromJson(Map<String, dynamic> json) {
    return RegionStat(
      region: json['region'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}

class ImpactStat {
  final String impactLevel;
  final int count;

  ImpactStat({required this.impactLevel, required this.count});

  factory ImpactStat.fromJson(Map<String, dynamic> json) {
    return ImpactStat(
      impactLevel: json['impact_level'] ?? '',
      count: json['count'] ?? 0,
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
      minAdoption: (json['min_adoption'] ?? 0).toDouble(),
      maxAdoption: (json['max_adoption'] ?? 100).toDouble(),
      avgAdoption: (json['avg_adoption'] ?? 50).toDouble(),
      medianAdoption: (json['median_adoption'] ?? 50).toDouble(),
    );
  }
}



