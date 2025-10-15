import 'package:flutter/material.dart';

const Color primaryColor = Colors.deepPurple;
const Color accentColor = Color(0xFFFFA726);
const Color backgroundColor = Color(0xfff7f7f7);

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  int _selectedIndex = 0;

  // final List<Widget> _pages = <Widget>[
  //   const HomeScreen(),
  //   const MyActivityScreen(),
  //   const ProfileScreen(),
  // ]

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      // body: Center(
      //   child: _pages.elementAt(_selectedIndex)
      // ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label : 'Home',
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in),
            activeIcon: Icon(Icons.assignment_turned_in_outlined),
            label : 'My Activity',
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label : 'Profile',
            ),

        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 8,
        ),
    );
  }
}


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(children: [
      Container(
        width: double.infinity,
        height: screenHeight*0.25,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          )
        ),
        padding: const EdgeInsets.only(top: 50,left: 20,right: 20, bottom: 20 ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'JobFound',
              style : TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildSearchBox(),
          ],
        ),
      ),
    ],);


    
  }
}