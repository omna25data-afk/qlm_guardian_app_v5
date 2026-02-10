import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/admin/admin_shell.dart';
import '../../../../app/guardian/guardian_shell.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authProvider.notifier)
        .login(_phoneController.text.trim(), _passwordController.text);

    if (success && mounted) {
      final user = ref.read(authProvider).user;

      if (user != null && user.isAdmin) {
        // Admin roles redirect to Admin Dashboard
        // TODO: Import AdminDashboardScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AdminShell()),
        );
      } else {
        // Others redirect to Guardian Shell
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const GuardianShell()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Show error snackbar
    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo/Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(
                      Icons.gavel_rounded,
                      size: 50,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    'إدارة الأمناء',
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'تسجيل الدخول',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Login identifier Field (email or phone)
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.emailAddress,
                    textDirection: TextDirection.ltr,
                    decoration: const InputDecoration(
                      labelText: 'البريد أو رقم الهاتف',
                      hintText: 'email@example.com أو 7XXXXXXXX',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البريد أو رقم الهاتف';
                      }
                      if (value.length < 5) {
                        return 'البيانات المُدخلة غير صحيحة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال كلمة المرور';
                      }
                      if (value.length < 4) {
                        return 'كلمة المرور قصيرة جداً';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Login Button
                  ElevatedButton(
                    onPressed: authState.isLoading ? null : _handleLogin,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: authState.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.textOnPrimary,
                                ),
                              ),
                            )
                          : const Text('تسجيل الدخول'),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Version
                  Text(
                    'الإصدار 5.0.0',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
