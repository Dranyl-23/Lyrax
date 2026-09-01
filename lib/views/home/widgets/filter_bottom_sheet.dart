import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FilterCriteria {
  final String genre;
  final String riskGrade;
  final double minApy;
  final String payoutFrequency;

  const FilterCriteria({
    required this.genre,
    required this.riskGrade,
    required this.minApy,
    required this.payoutFrequency,
  });

  static const defaultCriteria = FilterCriteria(
    genre: 'All',
    riskGrade: 'All',
    minApy: 8.0,
    payoutFrequency: 'Real-Time (Continuous)',
  );
}

class FilterBottomSheet extends StatefulWidget {
  final FilterCriteria currentCriteria;
  final ValueChanged<FilterCriteria> onApply;

  const FilterBottomSheet({
    super.key,
    required this.currentCriteria,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _selectedGenre;
  late String _selectedRiskGrade;
  late double _minApy;
  late String _payoutFrequency;

  final List<String> genres = ['All', 'Electronic', 'UK Garage', 'Neo-Soul', 'Afrobeats'];
  final List<String> riskGrades = ['All', 'Grade A+', 'Grade A', 'Grade B+'];
  final List<String> frequencies = ['Real-Time (Continuous)', 'Daily Stellar Settlement'];

  @override
  void initState() {
    super.initState();
    _selectedGenre = widget.currentCriteria.genre;
    _selectedRiskGrade = widget.currentCriteria.riskGrade;
    _minApy = widget.currentCriteria.minApy;
    _payoutFrequency = widget.currentCriteria.payoutFrequency;
  }

  void _reset() {
    setState(() {
      _selectedGenre = 'All';
      _selectedRiskGrade = 'All';
      _minApy = 8.0;
      _payoutFrequency = 'Real-Time (Continuous)';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Drag Handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.cardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Title & Reset Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Filter Catalogs & Risk',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPink.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'AI POWERED',
                          style: TextStyle(color: AppColors.primaryPink, fontSize: 8, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: _reset,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textMuted,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(40, 24),
                    ),
                    child: const Text('Reset', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // GENRE FILTER
              const Text(
                'MUSIC GENRE',
                style: TextStyle(color: AppColors.textMuted, fontSize: 9.5, fontWeight: FontWeight.bold, letterSpacing: 0.8),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: genres.map((g) {
                  final bool isSelected = _selectedGenre == g;
                  return ChoiceChip(
                    label: Text(g),
                    selected: isSelected,
                    onSelected: (val) => setState(() => _selectedGenre = g),
                    selectedColor: AppColors.primaryPink.withValues(alpha: 0.2),
                    backgroundColor: AppColors.cardSurfaceElevated,
                    side: BorderSide(
                      color: isSelected ? AppColors.primaryPink : AppColors.cardBorder,
                      width: isSelected ? 1.5 : 1,
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primaryPink : AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),

              // RISK GRADE FILTER
              const Text(
                'AI UNDERWRITE RISK GRADE',
                style: TextStyle(color: AppColors.textMuted, fontSize: 9.5, fontWeight: FontWeight.bold, letterSpacing: 0.8),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: riskGrades.map((grade) {
                  final bool isSelected = _selectedRiskGrade == grade;
                  return ChoiceChip(
                    label: Text(grade),
                    selected: isSelected,
                    onSelected: (val) => setState(() => _selectedRiskGrade = grade),
                    selectedColor: AppColors.primaryPink.withValues(alpha: 0.2),
                    backgroundColor: AppColors.cardSurfaceElevated,
                    side: BorderSide(
                      color: isSelected ? AppColors.primaryPink : AppColors.cardBorder,
                      width: isSelected ? 1.5 : 1,
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primaryPink : AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),

              // MINIMUM APY SLIDER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'MINIMUM ESTIMATED APY',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 9.5, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                  ),
                  Text(
                    '${_minApy.toStringAsFixed(1)}% APY',
                    style: const TextStyle(color: AppColors.primaryPink, fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.primaryPink,
                  inactiveTrackColor: AppColors.cardBorder,
                  thumbColor: AppColors.primaryPink,
                  overlayColor: AppColors.primaryPink.withValues(alpha: 0.2),
                  trackHeight: 3,
                ),
                child: Slider(
                  value: _minApy,
                  min: 5.0,
                  max: 20.0,
                  divisions: 15,
                  onChanged: (val) => setState(() => _minApy = val),
                ),
              ),
              const SizedBox(height: 14),

              // SETTLEMENT FREQUENCY
              const Text(
                'STELLAR SETTLEMENT SPEED',
                style: TextStyle(color: AppColors.textMuted, fontSize: 9.5, fontWeight: FontWeight.bold, letterSpacing: 0.8),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: frequencies.map((freq) {
                  final bool isSelected = _payoutFrequency == freq;
                  return ChoiceChip(
                    label: Text(freq),
                    selected: isSelected,
                    onSelected: (val) => setState(() => _payoutFrequency = freq),
                    selectedColor: AppColors.primaryPink.withValues(alpha: 0.2),
                    backgroundColor: AppColors.cardSurfaceElevated,
                    side: BorderSide(
                      color: isSelected ? AppColors.primaryPink : AppColors.cardBorder,
                      width: isSelected ? 1.5 : 1,
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primaryPink : AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // APPLY BUTTON
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(
                      FilterCriteria(
                        genre: _selectedGenre,
                        riskGrade: _selectedRiskGrade,
                        minApy: _minApy,
                        payoutFrequency: _payoutFrequency,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
