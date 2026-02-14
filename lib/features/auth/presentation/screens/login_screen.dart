import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/admin/admin_shell.dart';
import '../../../../app/guardian/guardian_shell.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _localAuth = LocalAuthentication();
  final _localDataSource = AuthLocalDataSource();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _biometricsAvailable = false;
  String? _errorMessage;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    _loadSavedPreferences();
    _checkBiometrics();
  }

  Future<void> _loadSavedPreferences() async {
    final rememberMe = await _localDataSource.getRememberMe();
    if (rememberMe) {
      final lastId = await _localDataSource.getLastIdentifier();
      if (mounted) {
        setState(() {
          _rememberMe = true;
          if (lastId != null) _identifierController.text = lastId;
        });
      }
    }
  }

  Future<void> _checkBiometrics() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      if (mounted) {
        setState(() {
          _biometricsAvailable = canCheck && isSupported;
        });
      }
    } catch (_) {
      // Biometrics not available
    }
  }

  Future<void> _handleBiometricLogin() async {
    try {
      final didAuth = await _localAuth.authenticate(
        localizedReason: 'ادخل ببصمتك للتسجيل بسرعة',
        biometricOnly: true,
      );

      if (didAuth && mounted) {
        // If biometric succeeds BUT we need credentials, try auto-login
        // with saved identifier + stored token (session restore)
        await ref.read(authProvider.notifier).init();
        final authState = ref.read(authProvider);

        if (authState.isAuthenticated && authState.user != null) {
          _navigateByRole(authState.user!.isAdmin);
        } else {
          setState(() {
            _errorMessage =
                'البصمة ناجحة لكن لا توجد جلسة محفوظة.\nالرجاء تسجيل الدخول أولاً.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'فشل التحقق بالبصمة');
      }
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _errorMessage = null);

    final identifier = _identifierController.text.trim();
    final password = _passwordController.text;

    // Save remember-me preference
    if (_rememberMe) {
      await _localDataSource.saveRememberMe(true);
      await _localDataSource.saveLastIdentifier(identifier);
    } else {
      await _localDataSource.clearRememberMe();
    }

    final success = await ref
        .read(authProvider.notifier)
        .login(identifier, password);

    if (success && mounted) {
      final user = ref.read(authProvider).user;
      if (user != null) {
        _navigateByRole(user.isAdmin);
      }
    }
  }

  void _navigateByRole(bool isAdmin) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => isAdmin ? const AdminShell() : const GuardianShell(),
      ),
    );
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Listen for auth errors
    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        setState(() => _errorMessage = next.error);
      }
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryDark,
              AppColors.primary,
              Color(0xFF234B78),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),

                      // Logo
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/ministry_logo.jpg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'وزارة العدل وحقوق الإنسان',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.accent,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'محكمة السياني الإبتدائية (م - إب)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'إدارة قلم التوثيق',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                          fontFamily: 'Tajawal',
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Login Card
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                  fontFamily: 'Tajawal',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),

                              // Error message
                              if (_errorMessage != null)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.errorLight,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.error.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        color: AppColors.error,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _errorMessage!,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.error,
                                            fontFamily: 'Tajawal',
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => setState(
                                          () => _errorMessage = null,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 18,
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              // Identifier field
                              TextFormField(
                                controller: _identifierController,
                                keyboardType: TextInputType.emailAddress,
                                textDirection: TextDirection.ltr,
                                decoration: InputDecoration(
                                  labelText: 'البريد أو رقم الهاتف',
                                  hintText: 'email@example.com أو 7XXXXXXXX',
                                  prefixIcon: const Icon(Icons.person_outline),
                                  filled: true,
                                  fillColor: AppColors.surfaceVariant,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.border,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 2,
                                    ),
                                  ),
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

                              // Password field
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: 'كلمة المرور',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey[600],
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  filled: true,
                                  fillColor: AppColors.surfaceVariant,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.border,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 2,
                                    ),
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

                              const SizedBox(height: 12),

                              // Remember me row
                              Row(
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      onChanged: (v) =>
                                          setState(() => _rememberMe = v!),
                                      activeColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => setState(
                                      () => _rememberMe = !_rememberMe,
                                    ),
                                    child: Text(
                                      'تذكرني',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // Login button
                              SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: authState.isLoading
                                      ? null
                                      : _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: authState.isLoading
                                      ? const SizedBox(
                                          height: 22,
                                          width: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : Text(
                                          'تسجيل الدخول',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Tajawal',
                                          ),
                                        ),
                                ),
                              ),

                              // Biometric login
                              if (_biometricsAvailable) ...[
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Expanded(child: Divider()),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Text(
                                        'أو',
                                        style: TextStyle(
                                          color: AppColors.textHint,
                                          fontSize: 13,
                                          fontFamily: 'Tajawal',
                                        ),
                                      ),
                                    ),
                                    const Expanded(child: Divider()),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 50,
                                  child: OutlinedButton.icon(
                                    onPressed: authState.isLoading
                                        ? null
                                        : _handleBiometricLogin,
                                    icon: const Icon(
                                      Icons.fingerprint,
                                      size: 24,
                                    ),
                                    label: Text(
                                      'الدخول بالبصمة',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                      side: const BorderSide(
                                        color: AppColors.primary,
                                        width: 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Version
                      Text(
                        'الإصدار 5.0.0',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
