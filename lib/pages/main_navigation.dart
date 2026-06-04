import 'package:flutter/material.dart';
import 'home_page.dart';
import 'loan_page.dart';
import 'notification_page.dart';
import 'profile_page.dart';
import 'rooms_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  final pages = const [
    HomePage(),
    RoomsPage(),
    LoanPage(),
    NotificationPage(),
    ProfilePage(),
  ];

  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color brightRed = Color(0xFFE51C23);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 82,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 18,
                offset: const Offset(0, -6),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(22),
              topRight: Radius.circular(22),
            ),
          ),
          child: Row(
            children: [
              _navItem(
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Beranda',
              ),
              _navItem(
                index: 1,
                icon: Icons.meeting_room_outlined,
                activeIcon: Icons.meeting_room_rounded,
                label: 'Ruangan',
              ),
              _mainLoanButton(),
              _navItem(
                index: 3,
                icon: Icons.notifications_none_outlined,
                activeIcon: Icons.notifications_rounded,
                label: 'Notifikasi',
              ),
              _navItem(
                index: 4,
                icon: Icons.person_outline,
                activeIcon: Icons.person_rounded,
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final bool isSelected = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            currentIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                size: 23,
                color: isSelected ? brightRed : Colors.grey,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  color: isSelected ? brightRed : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mainLoanButton() {
    final bool isSelected = currentIndex == 2;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            currentIndex = 2;
          });
        },
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          height: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFD32F2F),
                      Color(0xFFF44336),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primaryRed.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
                child: Icon(
                  isSelected
                      ? Icons.assignment_rounded
                      : Icons.assignment_outlined,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Pinjam',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: isSelected ? brightRed : primaryRed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}