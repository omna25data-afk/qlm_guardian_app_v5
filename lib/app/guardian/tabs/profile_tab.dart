import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../features/auth/presentation/screens/login_screen.dart';
import '../../../features/profile/presentation/screens/profile_screen.dart';

/// تبويب حسابي — واجهة الأمين الشرعي
class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(
                      0xFF006400,
                    ).withValues(alpha: 0.1),
                    backgroundImage: user?.avatarUrl != null
                        ? NetworkImage(user!.avatarUrl!)
                        : null,
                    child: user?.avatarUrl == null
                        ? const Icon(
                            Icons.person,
                            size: 40,
                            color: Color(0xFF006400),
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.guardian?.fullName ?? user?.name ?? 'الأمين الشرعي',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (user?.guardian?.registerNumber != null)
                    Text(
                      'رقم السجل: ${user!.guardian!.registerNumber}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  if (user?.phoneNumber != null ||
                      user?.guardian?.phoneNumber != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        user?.phoneNumber ?? user?.guardian?.phoneNumber ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textHint,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Menu Items
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.person_outline,
                  title: 'الملف الشخصي',
                  subtitle: 'عرض وتعديل بياناتك الشخصية',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                ),
                const Divider(height: 1, indent: 56),
                _buildMenuItem(
                  context,
                  icon: Icons.sync,
                  title: 'المزامنة',
                  subtitle: 'مزامنة البيانات مع الخادم',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'جاري المزامنة...',
                          style: TextStyle(fontFamily: 'Tajawal'),
                        ),
                        backgroundColor: AppColors.info,
                      ),
                    );
                  },
                ),
                const Divider(height: 1, indent: 56),
                _buildMenuItem(
                  context,
                  icon: Icons.info_outline,
                  title: 'حول التطبيق',
                  subtitle: 'معلومات الإصدار',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AboutDialog(
                        applicationName: 'بوابة الأمين الشرعي',
                        applicationVersion: 'الإصدار 5.0.0',
                        applicationIcon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF006400,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.gavel,
                            color: Color(0xFF006400),
                            size: 40,
                          ),
                        ),
                        children: [
                          Text(
                            'تطبيق إدارة القيود والسجلات والتوثيق للأمناء الشرعيين.',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Logout
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(
                      'تسجيل الخروج',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    content: Text(
                      'هل أنت متأكد من تسجيل الخروج؟',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(
                          'إلغاء',
                          style: TextStyle(fontFamily: 'Tajawal'),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text(
                          'خروج',
                          style: TextStyle(
                            color: AppColors.error,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  }
                }
              },
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: Text(
                'تسجيل الخروج',
                style: TextStyle(color: AppColors.error, fontFamily: 'Tajawal'),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF006400).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF006400), size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          fontFamily: 'Tajawal',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
          fontFamily: 'Tajawal',
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey[400],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
