import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/ai_underwrite_result.dart';
import '../../services/ai_underwriting_service.dart';
import '../../services/stellar_service.dart';
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
                    const SizedBox(height: 12),
                    // OCR Split Sheet Upload Button
                    SizedBox(
                      width: double.infinity,
                      height: 38,
                      child: OutlinedButton(
                        onPressed: _showOcrScanModal,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.cardBorderGlowing),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.document_scanner, size: 15, color: AppColors.primaryPink),
                            SizedBox(width: 8),
                            Text(
                              'Scan & Parse Split Sheet PDF (OCR AI)',
                              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
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

                // DRAW ADVANCE VIA STELLAR ANCHOR / MONEYGRAM
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => _showAnchorCashDrawModal(_result!.fairAdvanceUsd),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPink,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_balance, size: 16),
                        SizedBox(width: 8),
                        Text('Draw Advance to Bank / Cash (Stellar Anchor)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Deploy Soroban Contract Button
                SizedBox(
                  width: double.infinity,
                  height: 44,
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

  void _showOcrScanModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _OcrScanningModal(
        onScanComplete: (scannedArtist, scannedTitle, scannedListeners, scannedSplits) {
          setState(() {
            _artistController.text = scannedArtist;
            _titleController.text = scannedTitle;
            _listenersController.text = scannedListeners;
          });
          _runAnalysis(simulate: true);
        },
      ),
    );
  }

  void _showAnchorCashDrawModal(double advanceAmount) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _AnchorCashDrawModal(
        advanceAmount: advanceAmount,
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

/// Simulated OCR Split Sheet Scanner Modal
class _OcrScanningModal extends StatefulWidget {
  final Function(String artist, String title, String listeners, List<String> splits) onScanComplete;

  const _OcrScanningModal({required this.onScanComplete});

  @override
  State<_OcrScanningModal> createState() => _OcrScanningModalState();
}

class _OcrScanningModalState extends State<_OcrScanningModal> {
  int _scanStep = 0;
  bool _isFinished = false;

  final List<String> _scanSteps = [
    'Parsing DistroKid royalty split agreement (PDF)...',
    'Scanning collaborator signatures & ISRC metadata...',
    'Extracting: 60% Artist, 30% Investor Pool, 10% Producer...',
    'Validating non-exclusive territory & recoupment terms...',
    'Soroban smart contract parameters generated successfully!',
  ];

  @override
  void initState() {
    super.initState();
    _startScanSimulation();
  }

  Future<void> _startScanSimulation() async {
    for (int i = 0; i < _scanSteps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 650));
      if (mounted) {
        setState(() {
          _scanStep = i;
          if (i == _scanSteps.length - 1) {
            _isFinished = true;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: const BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.document_scanner, color: AppColors.primaryPink, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'AI Split Sheet OCR Engine',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('GEMINI MULTIMODAL', style: TextStyle(color: AppColors.primaryPink, fontSize: 8.5, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Scanning Radar Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardSurfaceElevated,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.cardBorderGlowing),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryPink.withValues(alpha: 0.15),
                        ),
                        child: Icon(
                          _isFinished ? Icons.check_circle : Icons.document_scanner,
                          color: AppColors.primaryPink,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isFinished ? 'Contract Verified' : 'AI Processing Document...',
                              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _scanSteps[_scanStep],
                              style: const TextStyle(color: AppColors.primaryPink, fontSize: 10.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (_scanStep + 1) / _scanSteps.length,
                      backgroundColor: AppColors.cardBorder,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryPink),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Scanned Splits Preview
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cardSurfaceElevated,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DETECTED SPLIT MAP (SOROBAN COMPATIBLE)', style: TextStyle(color: AppColors.textMuted, fontSize: 9.5, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Luna Ray (Master Rights)', style: TextStyle(color: Colors.white, fontSize: 11)),
                      Text('60% Share', style: TextStyle(color: AppColors.primaryPink, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('LyraX Investor Vault (Collateral)', style: TextStyle(color: Colors.white, fontSize: 11)),
                      Text('30% Share', style: TextStyle(color: AppColors.primaryPink, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Kairo Beats (Production / Mix)', style: TextStyle(color: Colors.white, fontSize: 11)),
                      Text('10% Share', style: TextStyle(color: AppColors.primaryPink, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Apply Button
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: _isFinished
                    ? () {
                        widget.onScanComplete(
                          'Luna Ray (Verified OCR)',
                          'Midnight Echoes (Deluxe)',
                          '184000',
                          ['60%', '30%', '10%'],
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Populated catalog parameters from scanned split sheet!'),
                            backgroundColor: AppColors.primaryPink,
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  _isFinished ? 'Apply Scanned Splits to Soroban' : 'AI Extracting Document...',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stellar Anchor Cash Draw Modal (SEP-24 / MoneyGram)
class _AnchorCashDrawModal extends StatefulWidget {
  final double advanceAmount;

  const _AnchorCashDrawModal({required this.advanceAmount});

  @override
  State<_AnchorCashDrawModal> createState() => _AnchorCashDrawModalState();
}

class _AnchorCashDrawModalState extends State<_AnchorCashDrawModal> {
  final _stellarService = StellarService();
  int _selectedMethodIndex = 0;
  bool _isProcessing = false;
  Map<String, dynamic>? _drawResult;

  final List<Map<String, dynamic>> _methods = [
    {
      'title': 'UK Faster Payments / SEPA Bank Transfer',
      'desc': 'Direct wire to UK Bank (Sort code: 60-00-01 • Acc: ***892)',
      'icon': Icons.account_balance,
      'speed': 'Instant (2.4s)',
    },
    {
      'title': 'MoneyGram Cash Pickup',
      'desc': 'Pick up physical cash at 400k+ global locations with ID',
      'icon': Icons.local_atm,
      'speed': 'Ready in 5 mins',
    },
    {
      'title': 'Stellar Self-Custody USDC Wallet',
      'desc': 'Hold directly on Stellar Testnet address',
      'icon': Icons.wallet,
      'speed': 'Instant (2.8s)',
    },
  ];

  Future<void> _executeCashDraw() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 1400));

    final res = _stellarService.drawCashAdvanceViaAnchor(
      advanceAmountUsd: widget.advanceAmount,
      offRampMethod: _methods[_selectedMethodIndex]['title'],
    );

    if (mounted) {
      setState(() {
        _isProcessing = false;
        _drawResult = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
              const SizedBox(height: 14),

              if (_drawResult != null) ...[
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryPink.withValues(alpha: 0.15),
                          border: Border.all(color: AppColors.primaryPink),
                        ),
                        child: const Icon(Icons.check, color: AppColors.primaryPink, size: 28),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Cash Advance Disbursed via Stellar Anchor!',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${widget.advanceAmount.toStringAsFixed(0)} USDC Settled to ${_methods[_selectedMethodIndex]['title'].toString().split('/').first.trim()}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.cardSurfaceElevated,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Column(
                          children: [
                            _receiptRow('Anchor Reference', _drawResult!['anchorTxId']),
                            const SizedBox(height: 6),
                            _receiptRow('Settlement Speed', '${_drawResult!['settlementTimeSeconds']} seconds'),
                            const SizedBox(height: 6),
                            _receiptRow('Network Fee', '\$0.00 (Stellar Subsidized)'),
                            const SizedBox(height: 6),
                            _receiptRow('Protocol', 'SEP-24 Interactive Anchor'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryPink,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stellar Anchor Cash-Out',
                          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Instant fiat off-ramp via SEP-24 / MoneyGram',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 10.5),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.primaryPink),
                      ),
                      child: const Text(
                        'SEP-24',
                        style: TextStyle(color: AppColors.primaryPink, fontSize: 9.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Advance Amount Banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.cardSurfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.cardBorderGlowing),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'APPROVED ADVANCE',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${widget.advanceAmount.toStringAsFixed(0)} USDC',
                        style: const TextStyle(color: AppColors.primaryPink, fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Method Selection
                const Text(
                  'SELECT OFF-RAMP METHOD',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 9.5, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                ),
                const SizedBox(height: 8),
                ...List.generate(_methods.length, (index) {
                  final bool isSelected = _selectedMethodIndex == index;
                  final m = _methods[index];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedMethodIndex = index),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryPink.withValues(alpha: 0.15) : AppColors.cardSurfaceElevated,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryPink : AppColors.cardBorder,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(m['icon'] as IconData, size: 20, color: isSelected ? AppColors.primaryPink : AppColors.textMuted),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  m['title'] as String,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  m['desc'] as String,
                                  style: const TextStyle(color: AppColors.textMuted, fontSize: 9.5),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            m['speed'] as String,
                            style: const TextStyle(color: AppColors.primaryPink, fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // Confirm Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _executeCashDraw,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPink,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isProcessing
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text(
                            'Confirm & Disburse Advance',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _receiptRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

