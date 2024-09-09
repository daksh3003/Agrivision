
  import 'package:agriplant/data/LocaleString.dart';
import 'package:agriplant/pages/landing_page.dart';
  import 'package:flutter/material.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'package:firebase_core/firebase_core.dart';
  import 'firebase_options.dart';
  import 'package:get/get.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(MainApp());
  }



  class MainApp extends StatelessWidget {

    const MainApp({super.key});



    @override
    Widget build(BuildContext context) {
      return GetMaterialApp(
        translations: LocaleString(),
        locale: Locale('hi','IN'),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
          textTheme: GoogleFonts.nunitoTextTheme(),
        ),
        home: LandingPage(),
      );
    }
  }
