import 'package:agriplant/newpages/Communty_page.dart';
import 'package:agriplant/pages/marketplace_page.dart';
import 'package:agriplant/pages/profile_page.dart';
import 'package:agriplant/pages/seller/seller_explore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:badges/badges.dart' as badges;
import 'package:agriplant/pages/seller/seller_acccept_chat.dart';


class SellerHome extends StatefulWidget {
  const SellerHome({super.key});

  @override
  State<SellerHome> createState() => _HomePageState();
}

class _HomePageState extends State<SellerHome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String username = 'Loading...';

  final pages = [const SellerExplore(), const MarketplacePage(), SellerSidePage()];

  int currentPageIndex = 0;

  @override
  void initState(){
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try{
      User? user = _auth.currentUser;
      if(user != null){
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if(userDoc.exists) {
          setState(() {
            username = userDoc['name'] ?? 'No name';
          });
        } else {
          setState(() {
            username = 'unknown user';
          });
        }
      }
    } catch(e) {
      print('error fetching user data');
      setState(() {
        username = 'Error Loading Name';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
          icon: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.green.shade50,
            child: Icon(
              IconlyBold.profile,
              color: Colors.green.shade900,
              size: 22,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi $username👋🏾",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text("Enjoy our services", style: Theme.of(context).textTheme.bodySmall)
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton.filledTonal(
              onPressed: () {},
              icon: badges.Badge(
                badgeContent: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                position: badges.BadgePosition.topEnd(top: -15, end: -12),
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: Colors.green,
                ),
                child: const Icon(IconlyBroken.notification),
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
            icon: Icon(Icons.store),
            label: "Marketplace",
            activeIcon: Icon(Icons.store),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chat",
            activeIcon: Icon(Icons.chat),
          ),
        ],
      ),
    );
  }
}
