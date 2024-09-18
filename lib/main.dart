import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_youtube_clone/firebase_options.dart';

import 'package:flutter_youtube_clone/cores/widgets/loader.dart';
import 'package:flutter_youtube_clone/features/auth/pages/username_page.dart';
import 'package:flutter_youtube_clone/features/auth/pages/login_page.dart';
import 'package:flutter_youtube_clone/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoginPage();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          final currentUser = FirebaseAuth.instance.currentUser!;
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(currentUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return UsernamePage(
                    currentUser.displayName!,
                    currentUser.email!,
                    currentUser.photoURL!,
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Loader();
                }
                debugPrint(currentUser.toString());
                return const HomePage();
              });
        },
      ),
    );
  }
}
