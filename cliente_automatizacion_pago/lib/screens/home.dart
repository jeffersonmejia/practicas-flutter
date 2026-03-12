import 'package:flutter/material.dart';
import 'registro_metodo_pago.dart';
import 'ver_pagos.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(

      appBar: AppBar(
        title: const Text("Piloto"),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Icon(
                Icons.account_balance,
                size: 72,
                color: theme.colorScheme.primary,
              ),

              const SizedBox(height: 20),

              const Text(
                "Gestión de Pagos",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 40),

              ElevatedButton.icon(
                icon: const Icon(Icons.add_card),
                label: const Text("Registro"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegistroPagoPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              OutlinedButton.icon(
                icon: const Icon(Icons.payments_outlined),
                label: const Text("Ver pagos"),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: theme.colorScheme.primary,
                  side: BorderSide.none,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VerPagosPage(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
