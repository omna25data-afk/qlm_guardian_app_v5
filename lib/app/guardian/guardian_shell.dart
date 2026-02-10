import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';

import 'tabs/guardian_dashboard_tab.dart';
import 'tabs/my_records_tab.dart';
import 'tabs/guardian_tools_tab.dart';
import 'tabs/profile_tab.dart';

/// Guardian Shell — واجهة الأمين الشرعي
/// 5 تبويبات: الرئيسية، سجلاتي، إضافة، الأدوات، حسابي (كما في v4)
class GuardianShell extends ConsumerStatefulWidget {
  const GuardianShell({super.key});

  @override
  ConsumerState<GuardianShell> createState() => _GuardianShellState();
}

class _GuardianShellState extends ConsumerState<GuardianShell> {
  int _selectedIndex = 0;

  // 4 صفحات فعلية (إضافة = FAB وليست صفحة)
  final List<Widget> _pages = const [
    GuardianDashboardTab(), // 0: الرئيسية
    MyRecordsTab(), // 1: سجلاتي
    GuardianToolsTab(), // 2: الأدوات (mapped from nav index 3)
    ProfileTab(), // 3: حسابي (mapped from nav index 4)
  ];

  void _onItemTapped(int index) {
    // Index 2 = "إضافة" FAB → opens add entry screen
    if (index == 2) {
      _openAddEntry();
      return;
    }
    // Map bottom nav indices to page indices:
    // nav 0=الرئيسية→page 0, nav 1=سجلاتي→page 1,
    // nav 3=الأدوات→page 2, nav 4=حسابي→page 3
    final pageIndex = index > 2 ? index - 1 : index;
    setState(() => _selectedIndex = pageIndex);
  }

  /// Get the bottom nav index from page index
  int get _navIndex {
    // page 0→nav 0, page 1→nav 1, page 2→nav 3, page 3→nav 4
    return _selectedIndex >= 2 ? _selectedIndex + 1 : _selectedIndex;
  }

  void _openAddEntry() {
    // TODO: Navigate to AddEntryScreen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('إضافة قيد جديد', style: GoogleFonts.tajawal()),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'بوابة الأمين الشرعي',
          style: GoogleFonts.tajawal(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF006400),
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        actions: [
          // Sync indicator
          IconButton(
            icon: const Icon(Icons.sync, color: Colors.white70),
            onPressed: () {
              // TODO: Trigger sync
            },
            tooltip: 'مزامنة',
          ),
          // Profile menu
          PopupMenuButton<String>(
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white24,
                backgroundImage: user?.avatarUrl != null
                    ? NetworkImage(user!.avatarUrl!)
                    : null,
                child: user?.avatarUrl == null
                    ? const Icon(Icons.person, color: Colors.white, size: 20)
                    : null,
              ),
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(
                    'حسابي',
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
              } else if (value == 'profile') {
                setState(() => _selectedIndex = 3); // Go to profile tab
              }
            },
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        selectedItemColor: const Color(0xFF006400),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.tajawal(),
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'سجلاتي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40, color: Color(0xFF006400)),
            label: 'إضافة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_outlined),
            activeIcon: Icon(Icons.build),
            label: 'الأدوات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}
