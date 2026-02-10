import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';

// Placeholder tabs — will be replaced with real implementations
import 'tabs/admin_dashboard_tab.dart';
import 'tabs/guardians_tab.dart';
import 'tabs/records_tab.dart';
import 'tabs/reports_tab.dart';
import 'tabs/admin_settings_tab.dart';

/// Admin Shell — واجهة رئيس القلم
/// 5 تبويبات: الرئيسية، الأمناء، السجلات، التقارير، الأدوات
class AdminShell extends ConsumerStatefulWidget {
  const AdminShell({super.key});

  @override
  ConsumerState<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends ConsumerState<AdminShell> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    AdminDashboardTab(),
    GuardiansTab(),
    RecordsTab(),
    ReportsTab(),
    AdminSettingsTab(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final isWide = MediaQuery.of(context).size.width > 400;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        toolbarHeight: isWide ? 72 : 60,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'مرحباً، ${user?.name ?? "الرئيس"}',
                style: GoogleFonts.tajawal(
                  fontSize: isWide ? 18 : 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              Text(
                'رئيس قلم التوثيق',
                style: GoogleFonts.tajawal(
                  fontSize: isWide ? 12 : 10,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        actions: [
          // Notifications
          _AppBarIcon(
            icon: Icons.notifications_outlined,
            onPressed: () {
              // TODO: Notifications
            },
          ),
          const SizedBox(width: 4),
          // Profile / Logout
          PopupMenuButton<String>(
            offset: const Offset(0, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CircleAvatar(
                radius: isWide ? 20 : 16,
                backgroundColor: Colors.white24,
                backgroundImage: user?.avatarUrl != null
                    ? NetworkImage(user!.avatarUrl!)
                    : null,
                child: user?.avatarUrl == null
                    ? Icon(
                        Icons.person,
                        color: Colors.white,
                        size: isWide ? 22 : 18,
                      )
                    : null,
              ),
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(
                    'الملف الشخصي',
                    style: GoogleFonts.tajawal(fontSize: 14),
                  ),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: Text(
                    'الإعدادات',
                    style: GoogleFonts.tajawal(fontSize: 14),
                  ),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.error),
                  title: Text(
                    'تسجيل الخروج',
                    style: GoogleFonts.tajawal(
                      fontSize: 14,
                      color: AppColors.error,
                    ),
                  ),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
            onSelected: (value) async {
              if (value == 'logout') {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: _buildBottomNav(isWide),
    );
  }

  Widget _buildBottomNav(bool isWide) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                index: 0,
                icon: Icons.dashboard_outlined,
                activeIcon: Icons.dashboard,
                label: 'الرئيسية',
                isSelected: _selectedIndex == 0,
                isWide: isWide,
                onTap: _onItemTapped,
              ),
              _NavItem(
                index: 1,
                icon: Icons.group_outlined,
                activeIcon: Icons.group,
                label: 'الأمناء',
                isSelected: _selectedIndex == 1,
                isWide: isWide,
                onTap: _onItemTapped,
              ),
              _NavItem(
                index: 2,
                icon: Icons.source_outlined,
                activeIcon: Icons.source,
                label: 'السجلات',
                isSelected: _selectedIndex == 2,
                isWide: isWide,
                onTap: _onItemTapped,
              ),
              _NavItem(
                index: 3,
                icon: Icons.analytics_outlined,
                activeIcon: Icons.analytics,
                label: 'التقارير',
                isSelected: _selectedIndex == 3,
                isWide: isWide,
                onTap: _onItemTapped,
              ),
              _NavItem(
                index: 4,
                icon: Icons.build_outlined,
                activeIcon: Icons.build,
                label: 'الأدوات',
                isSelected: _selectedIndex == 4,
                isWide: isWide,
                onTap: _onItemTapped,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Animated bottom nav item (matching v4 style)
class _NavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final bool isWide;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.isWide,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 14 : 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primary : Colors.grey,
              size: isWide ? 24 : 20,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.tajawal(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: isWide ? 13 : 11,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// AppBar icon button
class _AppBarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _AppBarIcon({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 22),
        onPressed: onPressed,
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      ),
    );
  }
}
