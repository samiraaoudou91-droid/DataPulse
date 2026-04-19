import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CreateInsightScreen extends StatefulWidget {
  const CreateInsightScreen({Key? key}) : super(key: key);

  @override
  State<CreateInsightScreen> createState() => _CreateInsightScreenState();
}

class _CreateInsightScreenState extends State<CreateInsightScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _adoptionRateController;

  String _selectedCategory = 'AI';
  String _selectedRegion = 'Global';
  String _selectedImpactLevel = 'medium';

  bool _isLoading = false;
  String? _successMessage;
  String? _errorMessage;

  final List<String> _categories = [
    'AI', 'Cybersecurity', 'IoT', 'Cloud', 'Blockchain',
    'Mobile', 'Web', 'DevOps', 'Data Science', 'AR/VR', 'Quantum', 'Other'
  ];

  final List<String> _regions = [
    'Global', 'Africa', 'Europe', 'Asia', 'Americas', 'Middle East', 'Oceania'
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _adoptionRateController = TextEditingController(text: '50');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _adoptionRateController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final adoptionRate = double.tryParse(_adoptionRateController.text) ?? 0;

      final result = await ApiService.createInsight(
        title: _titleController.text,
        category: _selectedCategory,
        description: _descriptionController.text,
        region: _selectedRegion,
        impactLevel: _selectedImpactLevel,
        adoptionRate: adoptionRate,
      );

      setState(() {
        _successMessage = '✨ Insight créé avec succès!';
        _isLoading = false;
        _titleController.clear();
        _descriptionController.clear();
        _adoptionRateController.text = '50';
        _selectedCategory = 'AI';
        _selectedRegion = 'Global';
        _selectedImpactLevel = 'medium';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Insight créé avec succès! 🎉'),
          backgroundColor: Colors.green[600],
          duration: const Duration(seconds: 3),
        ),
      );

      // Réinitialiser le message après 3 secondes
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        setState(() => _successMessage = null);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un Insight'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_successMessage != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    border: Border.all(color: Colors.green.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green[400]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _successMessage!,
                          style: TextStyle(color: Colors.green[300]),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    border: Border.all(color: Colors.red.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[400]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red[300]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // Title Field
              _buildSectionTitle('Titre'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: _buildInputDecoration('Ex: IA dans la santé en Afrique'),
                maxLength: 255,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Le titre est requis';
                  if (value!.length < 3) return 'Minimum 3 caractères';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Category
              _buildSectionTitle('Catégorie'),
              const SizedBox(height: 8),
              _buildDropdownField(
                value: _selectedCategory,
                items: _categories,
                onChanged: (value) => setState(() => _selectedCategory = value!),
              ),
              const SizedBox(height: 24),

              // Region
              _buildSectionTitle('Région'),
              const SizedBox(height: 8),
              _buildDropdownField(
                value: _selectedRegion,
                items: _regions,
                onChanged: (value) => setState(() => _selectedRegion = value!),
              ),
              const SizedBox(height: 24),

              // Impact Level
              _buildSectionTitle('Niveau d\'Impact'),
              const SizedBox(height: 8),
              _buildSegmentedButtons(),
              const SizedBox(height: 24),

              // Description
              _buildSectionTitle('Description'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: _buildInputDecoration('Décrivez l\'insight détaillé...'),
                maxLines: 6,
                minLines: 4,
                maxLength: 2000,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'La description est requise';
                  if (value!.length < 10) return 'Minimum 10 caractères';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Adoption Rate
              _buildSectionTitle('Taux d\'Adoption (%)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _adoptionRateController,
                decoration: _buildInputDecoration('0-100'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Le taux est requis';
                  final rate = double.tryParse(value!);
                  if (rate == null || rate < 0 || rate > 100) {
                    return 'Entrez une valeur entre 0 et 100';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    disabledBackgroundColor: Colors.grey[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: _isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      strokeWidth: 2,
                    ),
                  )
                      : const Icon(Icons.send),
                  label: Text(
                    _isLoading ? 'Envoi en cours...' : 'Créer l\'Insight',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.cyan,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.cyan.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.cyan.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.cyan),
      ),
      contentPadding: const EdgeInsets.all(16),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.cyan.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: value,
        items: items.map((item) => DropdownMenuItem(
          value: item,
          child: Text(item),
        )).toList(),
        onChanged: onChanged,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: Colors.grey[900],
      ),
    );
  }

  Widget _buildSegmentedButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ['low', 'medium', 'high'].map((level) {
          final isSelected = _selectedImpactLevel == level;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                level.toUpperCase(),
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.cyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedImpactLevel = level);
              },
              selectedColor: Colors.cyan,
              backgroundColor: Colors.grey[800],
            ),
          );
        }).toList(),
      ),
    );
  }
}











