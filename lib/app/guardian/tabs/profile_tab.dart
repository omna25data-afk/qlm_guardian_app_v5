import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../features/auth/presentation/screens/login_screen.dart';

/// حسابي — الملف الشخصي + الإعدادات
class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return ListView(
      padding: const EdgeInsets.all(16),
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
                  user?.guardian?.fullName ?? user?.name ?? 'الأمين',
                  style: GoogleFonts.tajawal(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (user?.guardian?.registerNumber != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'رقم السجل: ${user!.guardian!.registerNumber}',
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                if (user?.phoneNumber != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      user!.phoneNumber!,
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Menu Items
        _MenuItem(
          icon: Icons.edit_outlined,
          title: 'تعديل الملف الشخصي',
          onTap: () {
            // TODO: Edit profile
          },
        ),
        _MenuItem(
          icon: Icons.sync,
          title: 'المزامنة',
          subtitle: 'آخر مزامنة: غير محدد',
          onTap: () {
            // TODO: Sync
          },
        ),
        _MenuItem(
          icon: Icons.dark_mode_outlined,
          title: 'الوضع الليلي',
          onTap: () {
            // TODO: Toggle dark mode
          },
        ),
        _MenuItem(
          icon: Icons.info_outline,
          title: 'حول التطبيق',
          onTap: () {
            // TODO: About
          },
        ),
        const SizedBox(height: 16),
        _MenuItem(
          icon: Icons.logout,
          title: 'تسجيل الخروج',
          color: AppColors.error,
          onTap: () async {
            await ref.read(authProvider.notifier).logout();
            if (context.mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            }
          },
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? color;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: color ?? AppColors.textSecondary),
        title: Text(
          title,
          style: GoogleFonts.tajawal(fontWeight: FontWeight.w500, color: color),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: GoogleFonts.tajawal(
                  fontSize: 12,
                  color: AppColors.textHint,
                ),
              )
            : null,
        trailing: const Icon(
          Icons.chevron_left,
          size: 20,
          color: AppColors.textHint,
        ),
        onTap: onTap,
      ),
    );
  }
}
