import 'package:flutter/material.dart';
import '../../../../../core/utils/currency_utils.dart';
import '../../../../../core/utils/validators.dart';

/// Fees section of the entry form
/// Contains total and paid amount fields with remaining calculation
class FeesSection extends StatefulWidget {
  final TextEditingController totalAmountController;
  final TextEditingController paidAmountController;

  const FeesSection({
    super.key,
    required this.totalAmountController,
    required this.paidAmountController,
  });

  @override
  State<FeesSection> createState() => _FeesSectionState();
}

class _FeesSectionState extends State<FeesSection> {
  double _remaining = 0;

  @override
  void initState() {
    super.initState();
    widget.totalAmountController.addListener(_calculateRemaining);
    widget.paidAmountController.addListener(_calculateRemaining);
  }

  void _calculateRemaining() {
    final total = double.tryParse(widget.totalAmountController.text) ?? 0;
    final paid = double.tryParse(widget.paidAmountController.text) ?? 0;
    setState(() => _remaining = CurrencyUtils.remaining(total, paid));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.totalAmountController,
          decoration: const InputDecoration(
            labelText: 'المبلغ الإجمالي',
            suffixText: 'ر.ي',
            prefixIcon: Icon(Icons.attach_money),
            border: OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: Validators.amount,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: widget.paidAmountController,
          decoration: const InputDecoration(
            labelText: 'المبلغ المدفوع',
            suffixText: 'ر.ي',
            prefixIcon: Icon(Icons.payment),
            border: OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: Validators.amount,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _remaining <= 0
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المتبقي:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                CurrencyUtils.formatYER(_remaining),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _remaining <= 0 ? Colors.green : Colors.orange,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
