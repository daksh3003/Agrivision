import 'package:agriplant/pages/cart_page.dart';
import 'package:agriplant/pages/explore_page.dart';
import 'package:agriplant/pages/profile_page.dart';
import 'package:agriplant/pages/services_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class SellerHome extends StatefulWidget {
  const SellerHome({super.key});

  @override
  State<SellerHome> createState() => _SellerHomeState();
}

class _SellerHomeState extends State<SellerHome> {
  final pages = [const ExplorePage(), const ServicesPage(), const CartPage()];
  int currentPageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const Drawer(),
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton.filledTonal(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi Wilson 👋🏾",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text("Enjoy our services", style: Theme.of(context).textTheme.bodySmall)
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              icon: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.green.shade100,
                child: Icon(
                  IconlyBold.profile,
                  color: Colors.green.shade900,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
      body: pages[currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentPageIndex,
        onTap: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.home),
            label: "Home",
            activeIcon: Icon(IconlyBold.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.call),
            label: "Marketplace",
            activeIcon: Icon(IconlyBold.call),
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.buy),
            label: "Community",
            activeIcon: Icon(IconlyBold.buy),
          )
        ],
      ),
    );
  }
}
