import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../data/models/registry_entry_model.dart';
import '../providers/registry_provider.dart'
    show registryRepositoryProvider, registryEntriesProvider;
import '../widgets/entry_form/parties_section.dart';
import '../widgets/entry_form/dates_section.dart';
import '../widgets/entry_form/fees_section.dart';
import '../widgets/entry_form/guardian_data_section.dart';

/// Screen for adding a new registry entry
class AddEntryScreen extends ConsumerStatefulWidget {
  const AddEntryScreen({super.key});

  @override
  ConsumerState<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends ConsumerState<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Form controllers
  final _subjectController = TextEditingController();
  final _contentController = TextEditingController();
  final _totalAmountController = TextEditingController(text: '0');
  final _paidAmountController = TextEditingController(text: '0');
  final _hijriDateController = TextEditingController();
  final _hijriYearController = TextEditingController();

  // Parties data
  final List<Map<String, String>> _parties = [];

  bool _isSubmitting = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _contentController.dispose();
    _totalAmountController.dispose();
    _paidAmountController.dispose();
    _hijriDateController.dispose();
    _hijriYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة قيد جديد'),
        actions: [
          if (_isSubmitting)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _submitForm,
              child: const Text(
                'حفظ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 3) {
              setState(() => _currentStep++);
            } else {
              _submitForm();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            }
          },
          onStepTapped: (step) => setState(() => _currentStep = step),
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(_currentStep == 3 ? 'حفظ القيد' : 'التالي'),
                  ),
                  if (_currentStep > 0) ...[
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('السابق'),
                    ),
                  ],
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text('بيانات الأمين'),
              content: GuardianDataSection(
                subjectController: _subjectController,
                contentController: _contentController,
              ),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('الأطراف'),
              content: PartiesSection(
                parties: _parties,
                onPartiesChanged: (parties) {
                  setState(() {
                    _parties
                      ..clear()
                      ..addAll(parties);
                  });
                },
              ),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('التواريخ'),
              content: DatesSection(
                hijriDateController: _hijriDateController,
                hijriYearController: _hijriYearController,
              ),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('الرسوم'),
              content: FeesSection(
                totalAmountController: _totalAmountController,
                paidAmountController: _paidAmountController,
              ),
              isActive: _currentStep >= 3,
              state: _currentStep > 3 ? StepState.complete : StepState.indexed,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final subjectError = Validators.required(
      _subjectController.text,
      'الموضوع',
    );
    if (subjectError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(subjectError), backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final entry = RegistryEntryModel(
        uuid: const Uuid().v4(),
        subject: _subjectController.text,
        content: _contentController.text,
        hijriDate: _hijriDateController.text.isEmpty
            ? null
            : _hijriDateController.text,
        hijriYear: int.tryParse(_hijriYearController.text),
        totalAmount: double.tryParse(_totalAmountController.text) ?? 0,
        paidAmount: double.tryParse(_paidAmountController.text) ?? 0,
        date: DateTime.now(),
      );

      final repository = ref.read(registryRepositoryProvider);
      await repository.createEntry(entry);

      // Invalidate the entries list to refresh
      ref.invalidate(registryEntriesProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حفظ القيد بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
