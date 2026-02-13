import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/screens/login_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with gradient and avatar
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF006400), Color(0xFF228B22)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: user?.avatarUrl != null
                            ? NetworkImage(user!.avatarUrl!)
                            : null,
                        child: user?.avatarUrl == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Color(0xFF006400),
                              )
                            : null,
                      ),
                      const SizedBox(height: 16),
                      // Name
                      Text(
                        user?.guardian?.fullName ??
                            user?.name ??
                            'الأمين الشرعي',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Register Number
                      if (user?.guardian?.registerNumber != null)
                        Text(
                          'رقم السجل: ${user!.guardian!.registerNumber}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Status Cards and Info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // License Status
                  _buildStatusCard(
                    context,
                    icon: Icons.verified_user,
                    title: 'حالة الترخيص',
                    status: user?.guardian?.licenseStatus ?? 'غير محدد',
                    color: _getStatusColor(user?.guardian?.licenseStatus),
                  ),
                  const SizedBox(height: 12),
                  // Card Status
                  _buildStatusCard(
                    context,
                    icon: Icons.credit_card,
                    title: 'حالة البطاقة',
                    status: user?.guardian?.cardStatus ?? 'غير محدد',
                    color: _getStatusColor(user?.guardian?.cardStatus),
                  ),
                  const SizedBox(height: 24),

                  // Info Section
                  _buildInfoSection(context, user),

                  const SizedBox(height: 24),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await ref.read(authProvider.notifier).logout();
                        if (context.mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: Text(
                        'تسجيل الخروج',
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String status,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, dynamic user) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'معلومات الحساب',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
            const Divider(),
            _buildInfoRow(
              Icons.phone,
              'رقم الجوال',
              user?.phoneNumber ?? user?.guardian?.phoneNumber ?? '-',
            ),
            _buildInfoRow(
              Icons.badge,
              'رقم السجل',
              user?.guardian?.registerNumber ?? '-',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(color: Colors.grey[600], fontFamily: 'Tajawal'),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    if (status.contains('ساري') || status.contains('نشط')) {
      return Colors.green;
    }
    if (status.contains('قريب')) return Colors.orange;
    if (status.contains('منتهي')) return Colors.red;
    return Colors.grey;
  }
}
