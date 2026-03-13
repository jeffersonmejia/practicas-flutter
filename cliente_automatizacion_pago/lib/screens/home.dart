import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<void> loginGoogle() async {
    try {

      print("BOTON PRESIONADO");

      final GoogleSignInAccount? googleUser =
          await GoogleSignIn().signIn();

      print("Usuario Google: $googleUser");

      if (googleUser == null) {
        print("LOGIN CANCELADO POR EL USUARIO");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print("ACCESS TOKEN: ${googleAuth.accessToken}");
      print("ID TOKEN: ${googleAuth.idToken}");

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      print("LOGIN FIREBASE OK");
      print("USER: ${userCredential.user?.email}");

      setState(() {});

    } catch (e, stack) {

      print("ERROR GOOGLE LOGIN: $e");
      print(stack);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error iniciando sesión con Google"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de pagos"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Icon(
                Icons.account_circle,
                size: 90,
                color: theme.colorScheme.primary,
              ),

              const SizedBox(height: 24),

              const Text(
                "Gestión de Pagos",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 40),

              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text("Iniciar sesión con Google"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
                onPressed: loginGoogle,
              ),

              const SizedBox(height: 20),

              if (user != null)
                Text(
                  "Sesión activa: ${user.email}",
                  textAlign: TextAlign.center,
                ),

            ],
          ),
        ),
      ),
    );
  }
}