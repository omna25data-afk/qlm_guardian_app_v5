import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/theme/app_colors.dart';

/// شاشة التصحيح — لاختبار الاتصال بالخادم
class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  final _apiClient = getIt<ApiClient>();
  String _log = 'Ready to test...';
  bool _isLoading = false;

  void _addLog(String message) {
    setState(() {
      _log += '\n\n$message';
    });
  }

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _log = 'Starting Test...\n';
    });

    try {
      // Test 1: User Endpoint
      _addLog('--- Testing /user ---');
      try {
        final userResponse = await _apiClient.get(
          ApiEndpoints.user.replaceFirst(ApiEndpoints.baseUrl, ''),
        );
        _addLog('Status: ${userResponse.statusCode}');
        _addLog('Body: ${userResponse.data}');
      } catch (e) {
        _addLog('USER ERROR: $e');
      }

      // Test 2: Record Books Endpoint
      _addLog('--- Testing /guardian/record-books ---');
      try {
        final booksResponse = await _apiClient.get('/guardian/record-books');
        _addLog('Status: ${booksResponse.statusCode}');
        final data = booksResponse.data;
        if (data is Map && data.containsKey('data')) {
          final list = data['data'] as List?;
          _addLog('Records count: ${list?.length ?? 0}');
        } else {
          _addLog('Body: $data');
        }
      } catch (e) {
        _addLog('RECORDS ERROR: $e');
      }

      // Test 3: Dashboard
      _addLog('--- Testing /dashboard ---');
      try {
        final dashResponse = await _apiClient.get('/dashboard');
        _addLog('Status: ${dashResponse.statusCode}');
        _addLog(
          'Has meta: ${(dashResponse.data as Map?)?.containsKey('meta')}',
        );
      } catch (e) {
        _addLog('DASHBOARD ERROR: $e');
      }

      // Test 4: API Base URL
      _addLog('--- Config ---');
      _addLog('Base URL: ${ApiEndpoints.baseUrl}');

      _addLog('\n✅ All tests completed.');
    } catch (e) {
      _addLog('FATAL ERROR: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testAdminEndpoints() async {
    setState(() {
      _isLoading = true;
      _log = 'Testing Admin Endpoints...\n';
    });

    try {
      // Admin Dashboard
      _addLog('--- Testing /admin/dashboard ---');
      try {
        final response = await _apiClient.get('/admin/dashboard');
        _addLog('Status: ${response.statusCode}');
        _addLog('Body keys: ${(response.data as Map?)?.keys.toList()}');
      } catch (e) {
        _addLog('ADMIN DASHBOARD ERROR: $e');
      }

      // Admin Guardians
      _addLog('--- Testing /admin/guardians ---');
      try {
        final response = await _apiClient.get('/admin/guardians');
        _addLog('Status: ${response.statusCode}');
        final data = response.data;
        if (data is Map && data.containsKey('data')) {
          final list = data['data'] as List?;
          _addLog('Guardians count: ${list?.length ?? 0}');
        }
      } catch (e) {
        _addLog('ADMIN GUARDIANS ERROR: $e');
      }

      // Admin Areas
      _addLog('--- Testing /admin/areas ---');
      try {
        final response = await _apiClient.get('/admin/areas');
        _addLog('Status: ${response.statusCode}');
      } catch (e) {
        _addLog('ADMIN AREAS ERROR: $e');
      }

      _addLog('\n✅ Admin tests completed.');
    } catch (e) {
      _addLog('FATAL ERROR: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'مصحح الاتصال',
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _testConnection,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.network_check),
                    label: Text(
                      'اختبار عام',
                      style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 50),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _testAdminEndpoints,
                    icon: const Icon(Icons.admin_panel_settings),
                    label: Text(
                      'اختبار الإدارة',
                      style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 50),
                      backgroundColor: AppColors.warning,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Log Output
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.3),
                ),
              ),
              child: SingleChildScrollView(
                reverse: true,
                child: SelectableText(
                  _log,
                  style: GoogleFonts.sourceCodePro(
                    color: Colors.greenAccent,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ),
          // Clear Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () => setState(() => _log = 'Ready to test...'),
                icon: const Icon(Icons.clear_all, size: 18),
                label: Text(
                  'مسح السجل',
                  style: GoogleFonts.tajawal(fontWeight: FontWeight.w600),
                ),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
