import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/ai_underwrite_result.dart';
import '../../services/ai_underwriting_service.dart';
import '../home/widgets/circular_gauge_widget.dart';

class AIScannerView extends StatefulWidget {
  const AIScannerView({super.key});

  @override
  State<AIScannerView> createState() => _AIScannerViewState();
}

class _AIScannerViewState extends State<AIScannerView> {
  final _service = AIUnderwritingService();

  final _artistController = TextEditingController(text: 'Luna Ray');
  final _titleController = TextEditingController(text: 'Midnight Echoes (EP)');
  final _listenersController = TextEditingController(text: '142500');
  final _ageController = TextEditingController(text: '18');
  String _selectedGenre = 'Indie Electronic / Synthwave';

  bool _isAnalyzing = false;
  AIUnderwriteResult? _result;

  @override
  void initState() {
    super.initState();
    // Run default analysis on init for instant polish
    _runAnalysis(simulate: false);
  }

  Future<void> _runAnalysis({bool simulate = true}) async {
    setState(() => _isAnalyzing = true);
    final double listeners = double.tryParse(_listenersController.text) ?? 100000;
    final double age = double.tryParse(_ageController.text) ?? 12;

    final res = await _service.underwriteCatalog(
      artistName: _artistController.text.trim().isEmpty ? 'Luna Ray' : _artistController.text.trim(),
      trackOrAlbum: _titleController.text.trim().isEmpty ? 'Catalog 2026' : _titleController.text.trim(),
      monthlyListeners: listeners,
      catalogAgeMonths: age,
      genre: _selectedGenre,
      simulateDelay: simulate,
    );

    if (mounted) {
      setState(() {
        _result = res;
        _isAnalyzing = false;
      });
    }
  }

  void _loadPreset(Map<String, dynamic> preset) {
    setState(() {
      _artistController.text = preset['artist'];
      _titleController.text = preset['title'];
      _listenersController.text = (preset['listeners'] as double).toInt().toString();
      _ageController.text = (preset['months'] as double).toInt().toString();
      _selectedGenre = preset['genre'];
    });
    _runAnalysis(simulate: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'LyraX AI Underwriter',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPink.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.primaryPink, width: 0.5),
                            ),
                            child: const Text(
                              'CORE AI',
                              style: TextStyle(color: AppColors.primaryPink, fontSize: 8.5, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Predictive streaming cash flow modeling & risk grading',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.cardBorderGlowing),
                    ),
                    child: const Icon(Icons.auto_awesome, color: AppColors.primaryPink, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Quick Presets Bar
              const Text(
                'ONE-TAP DEMO PRESETS',
                style: TextStyle(color: AppColors.textMuted, fontSize: 9.5, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: AIUnderwritingService.presetDemoCatalogs.map((preset) {
                    final bool isCurrent = _artistController.text == preset['artist'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        onPressed: () => _loadPreset(preset),
                        backgroundColor: isCurrent ? AppColors.primaryPink.withValues(alpha: 0.2) : AppColors.cardSurface,
                        side: BorderSide(
                          color: isCurrent ? AppColors.primaryPink : AppColors.cardBorder,
                        ),
                        label: Row(
                          children: [
                            Icon(
                              Icons.album,
                              size: 13,
                              color: isCurrent ? AppColors.primaryPink : AppColors.textMuted,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${preset['artist']} (${preset['genre'].toString().split('/').first.trim()})',
                              style: TextStyle(
                                color: isCurrent ? Colors.white : AppColors.textSecondary,
                                fontSize: 11,
                                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Input Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _inputField('Artist / Creator', _artistController, Icons.person),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _inputField('Catalog / EP Title', _titleController, Icons.music_note),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _inputField('Monthly Listeners', _listenersController, Icons.headphones, isNumber: true),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _inputField('Catalog Age (Mos)', _ageController, Icons.calendar_today, isNumber: true),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: _isAnalyzing ? null : () => _runAnalysis(simulate: true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPink,
                          foregroundColor: Colors.white,
                          elevation: 6,
                          shadowColor: AppColors.primaryPink.withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: _isAnalyzing
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.auto_awesome, size: 16),
                                  SizedBox(width: 8),
                                  Text(
                                    'Run AI Catalog Underwriting',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // AI Valuation Results Section
              if (_result != null) ...[
                // Top Result Banner with Risk Grade & Advance
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1E1428), Color(0xFF13131A)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorderGlowing, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'FAIR CASH ADVANCE APPROVED',
                                style: TextStyle(color: AppColors.primaryPink, fontSize: 9.5, fontWeight: FontWeight.bold, letterSpacing: 0.6),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${_result!.fairAdvanceUsd.toStringAsFixed(0)} USDC',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                'Backed by 12-Mo Projected: \$${_result!.projected12MoRevenueUsd.toStringAsFixed(0)}',
                                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                              ),
                            ],
                          ),
                          CircularGaugeWidget(
                            percentage: _result!.riskScore,
                            size: 64,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(color: AppColors.cardBorder, height: 1),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _statItem('RISK GRADE', _result!.riskGrade, isPink: true),
                          _statItem('INVESTOR APY', '${_result!.suggestedApy.toStringAsFixed(1)}%'),
                          _statItem('DECAY RATE', '${_result!.decayRateAnnualPercent.toStringAsFixed(1)}%/yr'),
                          _statItem('CONFIDENCE', '${_result!.confidenceScore.toStringAsFixed(1)}%'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // AI Thesis Explainable Report Box
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.cardSurface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.psychology, size: 16, color: AppColors.primaryPink),
                          SizedBox(width: 6),
                          Text(
                            'LyraX AI Underwriting Thesis',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _result!.aiThesisSummary,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5, height: 1.45),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // AI Smart Contract Split Allocation Map
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.cardSurface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'AI Split-Sheet Soroban Mapping',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'AUTO-VERIFIED',
                            style: TextStyle(color: AppColors.successGreen, fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ..._result!.suggestedSplits.map((split) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(split.name, style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600)),
                                    Text('${split.role} • ${split.stellarAddress}', style: const TextStyle(color: AppColors.textMuted, fontSize: 9.5)),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryPink.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${split.percentage.toStringAsFixed(0)}%',
                                    style: const TextStyle(color: AppColors.primaryPink, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Deploy Soroban Contract Button
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Minted Soroban Royalty Token for ${_result!.trackOrAlbum} on Stellar Testnet!'),
                          backgroundColor: AppColors.primaryPink,
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryPink, width: 1.5),
                      foregroundColor: AppColors.primaryPink,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.token, size: 16),
                        SizedBox(width: 8),
                        Text('Tokenize & Deploy Soroban Pool on Stellar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller, IconData icon, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.cardSurfaceElevated,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              prefixIcon: Icon(icon, size: 14, color: AppColors.textMuted),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _statItem(String label, String value, {bool isPink = false}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 9, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: isPink ? AppColors.primaryPink : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
