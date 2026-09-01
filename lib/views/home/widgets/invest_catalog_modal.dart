import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/catalog_position.dart';
import '../../../../services/stellar_service.dart';

class InvestCatalogModal extends StatefulWidget {
  final CatalogPosition position;
  final VoidCallback? onInvestmentSuccess;

  const InvestCatalogModal({
    super.key,
    required this.position,
    this.onInvestmentSuccess,
  });

  @override
  State<InvestCatalogModal> createState() => _InvestCatalogModalState();
}

class _InvestCatalogModalState extends State<InvestCatalogModal> {
  final _stellarService = StellarService();
  final _amountController = TextEditingController(text: '250');
  double _amount = 250.0;
  bool _isProcessing = false;
  Map<String, dynamic>? _txResult;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      final val = double.tryParse(_amountController.text) ?? 0.0;
      if (val != _amount) {
        setState(() => _amount = val);
      }
    });
  }

  void _addAmount(double add) {
    setState(() {
      _amount += add;
      _amountController.text = _amount.toStringAsFixed(0);
    });
  }

  void _setMax() {
    setState(() {
      _amount = _stellarService.usdcBalance;
      _amountController.text = _amount.toStringAsFixed(0);
    });
  }

  Future<void> _executeInvestment() async {
    if (_amount <= 0 || _amount > _stellarService.usdcBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid USDC amount within your balance')),
      );
      return;
    }

    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 1400)); // Simulate Soroban invocation

    final res = _stellarService.investInCatalog(
      catalogId: widget.position.id,
      usdcAmount: _amount,
      catalogTotalValuation: widget.position.exposureUsd,
      apyPercent: widget.position.roiPercent + 5.0, // Blended APY
    );

    if (mounted) {
      setState(() {
        _isProcessing = false;
        _txResult = res;
      });
      widget.onInvestmentSuccess?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double poolOwnership = widget.position.exposureUsd > 0
        ? (_amount / widget.position.exposureUsd * 100)
        : 0.0;
    final double dailyYield = (_amount * ((widget.position.roiPercent + 5.0) / 100)) / 365;
    final double annualYield = _amount * ((widget.position.roiPercent + 5.0) / 100);

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
              // Drag handle
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

              if (_txResult != null)
                _buildSuccessView()
              else ...[
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Buy Royalty Shares',
                                style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryPink.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'SEP-41',
                                  style: TextStyle(color: AppColors.primaryPink, fontSize: 8.5, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${widget.position.title} • ${widget.position.artist}',
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.cardSurfaceElevated,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.cardBorderGlowing),
                      ),
                      child: Text(
                        '${(widget.position.roiPercent + 5.0).toStringAsFixed(1)}% APY',
                        style: const TextStyle(color: AppColors.primaryPink, fontSize: 11.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Amount Input Box
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.cardSurfaceElevated,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'INVESTMENT AMOUNT',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 9.5, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Balance: \$${_stellarService.usdcBalance.toStringAsFixed(2)} USDC',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            '\$',
                            style: TextStyle(color: AppColors.primaryPink, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: TextField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                hintText: '0',
                                hintStyle: TextStyle(color: AppColors.textMuted),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.cardSurface,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'USDC',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Quick Pills
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _quickPill('+\$50', () => _addAmount(50)),
                            _quickPill('+\$100', () => _addAmount(100)),
                            _quickPill('+\$250', () => _addAmount(250)),
                            _quickPill('+\$500', () => _addAmount(500)),
                            _quickPill('MAX', _setMax, isSpecial: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Auto-Calculation Breakdown Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.cardSurfaceElevated,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorderGlowing),
                  ),
                  child: Column(
                    children: [
                      _calcRow('Royalty Tokens Received', '${(_amount * 10).toStringAsFixed(0)} SEP-41 Shares'),
                      const SizedBox(height: 8),
                      _calcRow('Catalog Ownership Pool', '${poolOwnership.toStringAsFixed(3)}%'),
                      const SizedBox(height: 8),
                      _calcRow('Est. Daily Streaming Payout', '+\$${dailyYield.toStringAsFixed(3)} USDC / day', isPink: true),
                      const SizedBox(height: 8),
                      _calcRow('Est. Annual Return', '+\$${annualYield.toStringAsFixed(2)} USDC (${(widget.position.roiPercent + 5.0).toStringAsFixed(1)}% APY)'),
                      const SizedBox(height: 8),
                      const Divider(color: AppColors.cardBorder, height: 1),
                      const SizedBox(height: 8),
                      _calcRow('Stellar Network Gas Fee', '< \$0.00001 XLM (Instant Settlement)', isMuted: true),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Confirm Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _executeInvestment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPink,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            'Confirm Investment (\$$_amount USDC)',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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

  Widget _buildSuccessView() {
    return Column(
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
          'Investment Confirmed on Stellar!',
          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Minted ${_txResult!['shareTokensMinted']} SEP-41 Royalty Shares',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cardSurfaceElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Soroban Transaction Hash', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _txResult!['txHash']));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Transaction hash copied to clipboard!')),
                      );
                    },
                    child: const Icon(Icons.copy, size: 12, color: AppColors.primaryPink),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${_txResult!['txHash'].toString().substring(0, 24)}...',
                style: const TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'monospace'),
              ),
              const SizedBox(height: 8),
              const Divider(color: AppColors.cardBorder, height: 1),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Stellar Explorer', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _txResult!['explorerUrl']));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied Stellar Expert URL!')),
                      );
                    },
                    child: const Row(
                      children: [
                        Text('View on Stellar.Expert', style: TextStyle(color: AppColors.primaryPink, fontSize: 10.5, fontWeight: FontWeight.bold)),
                        SizedBox(width: 3),
                        Icon(Icons.open_in_new, size: 11, color: AppColors.primaryPink),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
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
    );
  }

  Widget _quickPill(String label, VoidCallback onTap, {bool isSpecial = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isSpecial ? AppColors.primaryPink.withValues(alpha: 0.2) : AppColors.cardSurface,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSpecial ? AppColors.primaryPink : AppColors.cardBorder,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSpecial ? AppColors.primaryPink : AppColors.textSecondary,
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _calcRow(String label, String value, {bool isPink = false, bool isMuted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isMuted ? AppColors.textMuted : AppColors.textSecondary,
            fontSize: 10.5,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isPink ? AppColors.primaryPink : (isMuted ? AppColors.textMuted : Colors.white),
            fontSize: 11,
            fontWeight: isPink ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
