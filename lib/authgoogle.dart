import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthGoogle extends StatefulWidget {
  const AuthGoogle({super.key});

  @override
  State<AuthGoogle> createState() => _AuthGoogleState();
}

class _AuthGoogleState extends State<AuthGoogle> {

final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;


//funçaõ para logar no google
Future<UserCredential> signInWithGoogle() async {

  //provedor de autenticação
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
        
  // fazer login via google
  final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
  );

  return await auth.signInWithCredential(credential);
}


// função para deslogar do Google
Future<void> signOutGoogle() async {
  await googleSignIn.signOut();
  await FirebaseAuth.instance.signOut();
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        maxWidth: 1200,
        minWidth: 480,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(480, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
        ],
        background: Container(color: Colors.white,)),
        home: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll){
            overScroll.disallowIndicator();
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
            title: const Text('Auth Google'),),
            body: Center(
              child: ElevatedButton(
                onPressed: () async {
                final UserCredential userCredential = await signInWithGoogle();
                final User user = userCredential.user!;
                if (kDebugMode) {
                  print('User: ${user.displayName}');
                }
              },
              child: const Text('Login with Google'),
              ),
            ),
          )
        ),
    );
  }
}