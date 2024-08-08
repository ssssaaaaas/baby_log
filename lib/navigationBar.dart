import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'Homepage/HomePage.dart';
import 'Community/CommunityPage.dart';
import 'Mypage/MyPage.dart';
import 'Diary/Calendar.dart';

class navigationBar extends StatefulWidget {
  const navigationBar({super.key});

  @override
  State<navigationBar> createState() => _navigationBarState();
}

class _navigationBarState extends State<navigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    CommunityPage(),
    Calendar(),
    const MyPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              unselectedFontSize: 10,
              selectedFontSize: 10,
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.bold),
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_filled), label: '홈'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.forum_outlined), label: '커뮤니티'),
                BottomNavigationBarItem(
                    icon: Icon(Symbols.child_care), label: '기록'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_2_outlined), label: '마이페이지')
              ],
              currentIndex: _selectedIndex,
              unselectedItemColor: const Color(0XFFB1B8C0),
              selectedItemColor: const Color(0XFFFF9C27),
              onTap: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }
}
