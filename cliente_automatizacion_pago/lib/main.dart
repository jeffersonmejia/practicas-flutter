import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home.dart';
import 'theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("Firebase failed to initialize: $e");
  }

  // Inicializar Supabase principal
  try {
    await Supabase.initialize(
      url: 'https://tdcogdgrpyqhznlmyhnf.supabase.co',
      anonKey: 'sb_publishable_RbZ6EgwHAZH39ISfsekCEA_wtsj1p1v',
    );
    print("Supabase initialized successfully");
  } catch (e) {
    print("Supabase failed to initialize: $e");
  }

  // Inicializar nueva instancia de Supabase llamada apiDeuna
  try {
    await Supabase.initialize(
      url: 'https://tdcogdgrpyqhznlmyhnf.supabase.co',
      anonKey: 'sb_publishable_RbZ6EgwHAZH39ISfsekCEA_wtsj1p1v',
      name: 'apiDeuna', // Nombre único para usarla por separado
    );
    print("Supabase apiDeuna initialized successfully");
  } catch (e) {
    print("Supabase apiDeuna failed to initialize: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Piloto - Pagos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomePage(),
    );
  }
}
