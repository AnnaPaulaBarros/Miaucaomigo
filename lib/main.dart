import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Telas
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/cadastro_screen.dart';
import 'screens/termos_screen.dart';
import 'screens/cadastrar_pet_screen.dart';
import 'screens/galeria_screen.dart';
import 'screens/localizacao_screen.dart';
import 'screens/visualizar_mapa_screen.dart';
import 'screens/perfil_screen.dart';
import 'screens/ongs_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MiaucaomigoApp());
}

class MiaucaomigoApp extends StatelessWidget {
  const MiaucaomigoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Miaucaomigo',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF7A5948),
        scaffoldBackgroundColor: const Color(0xFFF7CC7E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF7A5948),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/': (context) => const LoginScreen(),
        '/menu': (context) => const MenuScreen(),
        '/cadastro': (context) => const CadastroScreen(),
        '/termos': (context) => const TermosScreen(),
        '/cadastrar_pet': (context) => const CadastroPetScreen(),
        '/galeria': (context) => const GaleriaScreen(),
        '/localizacao': (context) => const LocalizacaoScreen(),
        '/perfil': (context) => const PerfilScreen(),
        '/parceiros': (context) => const OngsScreen(),
      },
      onGenerateRoute: (settings) {
        // Correção do nome da rota para bater com a Galeria
        if (settings.name == '/visualizar_mapa') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => VisualizarMapaScreen(petData: args),
          );
        }
        return null;
      },
    );
  }
}
