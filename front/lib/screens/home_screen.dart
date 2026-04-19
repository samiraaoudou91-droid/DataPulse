



















import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/models.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> _insightsFuture;
  String? _selectedCategory;
  String? _selectedRegion;
  final List<String> _categories = [
    'AI', 'Cybersecurity', 'IoT', 'Cloud', 'Blockchain',
    'Mobile', 'Web', 'DevOps', 'Data Science', 'AR/VR'
  ];
  final List<String> _regions = ['Global', 'Africa', 'Europe', 'Asia', 'Americas'];

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  void _loadInsights() {
    _insightsFuture = ApiService.fetchInsights(
      category: _selectedCategory,
      region: _selectedRegion,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.cyan, Colors.purple],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.show_chart, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              'DataPulse',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.cyan,
              ),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Filters
          _buildFilterBar(),
          // Insights List
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _insightsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildShimmerLoading();
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                        const SizedBox(height: 16),
                        Text('Erreur: ${snapshot.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => setState(() => _loadInsights()),
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  );
                }

                final insights = snapshot.data ?? [];
                if (insights.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[500]),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun insight trouvé',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => setState(() => _loadInsights()),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: insights.length,
                    itemBuilder: (context, index) {
                      final insight = Insight.fromJson(insights[index]);
                      return _buildInsightCard(context, insight);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildFilterChip(
            label: 'Catégorie',
            value: _selectedCategory,
            options: _categories,
            onChanged: (val) {
              setState(() => _selectedCategory = val);
              _loadInsights();
            },
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Région',
            value: _selectedRegion,
            options: _regions,
            onChanged: (val) {
              setState(() => _selectedRegion = val);
              _loadInsights();
            },
          ),
          if (_selectedCategory != null || _selectedRegion != null) ...[
            const SizedBox(width: 8),
            Chip(
              label: const Text('Réinitialiser'),
              onDeleted: () {
                setState(() {
                  _selectedCategory = null;
                  _selectedRegion = null;
                });
                _loadInsights();
              },
              backgroundColor: Colors.red.withOpacity(0.2),
              deleteIconColor: Colors.red,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return PopupMenuButton<String>(
      initialValue: value,
      onSelected: onChanged,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: null,
          child: Text('Tous les $label'),
        ),
        ...options.map((opt) => PopupMenuItem(
          value: opt,
          child: Text(opt),
        )),
      ],
      child: Chip(
        label: Text('$label: ${value ?? "Tous"}'),
        backgroundColor: Colors.cyan.withOpacity(0.15),
        labelStyle: const TextStyle(color: Colors.cyan),
      ),
    );
  }

  Widget _buildInsightCard(BuildContext context, Insight insight) {
    final impactColor = _getImpactColor(insight.impactLevel);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.grey[900]?.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.cyan.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        insight.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        insight.category,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: impactColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    insight.impactLevel.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: impactColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Description
            Text(
              insight.description,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStat(
                  icon: Icons.location_on_outlined,
                  label: insight.region,
                  context: context,
                ),
                _buildStat(
                  icon: Icons.trending_up,
                  label: '${insight.adoptionRate.toStringAsFixed(1)}%',
                  context: context,
                ),
                _buildStat(
                  icon: Icons.schedule,
                  label: timeago.format(insight.creationDate),
                  context: context,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String label,
    required BuildContext context,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.cyan),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (_, index) => Container(
          height: 150,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Color _getImpactColor(String level) {
    switch (level.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}
