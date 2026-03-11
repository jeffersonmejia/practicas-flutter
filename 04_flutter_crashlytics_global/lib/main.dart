import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // Captura errores de framework Flutter (widgets, render, layout)
  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  };

  // Captura errores fuera del framework (engine, platform channels)
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Captura errores asincrónicos globales
  runZonedGuarded(() {
    runApp(const MyApp());
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CrashTestPage(),
    );
  }
}

class CrashTestPage extends StatelessWidget {
  const CrashTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crashlytics Global Test")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Error de lógica en UI
            ElevatedButton(
              onPressed: () {
                throw Exception("UI logic error");
              },
              child: const Text("UI Logic Error"),
            ),

            // Error asincrónico
            ElevatedButton(
              onPressed: () {
                Future.delayed(
                  const Duration(seconds: 1),
                  () => throw Exception("Async Error"),
                );
              },
              child: const Text("Async Error"),
            ),

            // Error de render/layout
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BrokenLayoutPage(),
                  ),
                );
              },
              child: const Text("Render/Layout Error"),
            ),

            // Crash fatal directo
            ElevatedButton(
              onPressed: () {
                FirebaseCrashlytics.instance.crash();
              },
              child: const Text("Fatal Crash"),
            ),
          ],
        ),
      ),
    );
  }
}

class BrokenLayoutPage extends StatelessWidget {
  const BrokenLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Broken Layout")),
      body: Row(
        children: const [
          Expanded(
            child: Text(
              "This text will overflow and cause a render/layout error "
              "because it is extremely long and constrained.",
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Another long text that will break layout constraints "
              "inside a Row with limited width.",
            ),
          ),
        ],
      ),
    );
  }
}