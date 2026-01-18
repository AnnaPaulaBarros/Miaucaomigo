import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  Future<void> _fazerLogout(BuildContext context) async {
    // Guardamos o navigator antes do await para evitar erro de BuildContext
    final navigator = Navigator.of(context);

    bool confirmar = await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: const Color(0xFFFBE4AD),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(
                color: Color(0xFF7A5948),
                width: 3,
              ),
            ),
            title: const Text(
              "Sair do Miaucaomigo",
              style: TextStyle(
                color: Color(0xFF7A5948),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              "Deseja realmente encerrar a sua sessão?",
              style: TextStyle(color: Color(0xFF7A5948)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text(
                  "CANCELAR",
                  style: TextStyle(color: Colors.brown),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A5948),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  "SAIR",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmar) {
      await FirebaseAuth.instance.signOut();
      navigator.pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7CC7E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7A5948),
        foregroundColor: const Color(0xFFFBE4AD),
        title: const Text(
          "Miaucaomigo",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _fazerLogout(context),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBE4AD),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF7A5948),
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.pets,
                  size: 60,
                  color: Color(0xFF7A5948),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "O que vamos fazer hoje?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A5948),
                ),
              ),
              const SizedBox(height: 40),
              _botaoMenu(
                context,
                "Galeria",
                "Veja os animais encontrados",
                Icons.grid_view_rounded,
                '/galeria',
              ),
              _botaoMenu(
                context,
                "Cadastrar",
                "Registre um novo animal",
                Icons.add_circle_outline_rounded,
                '/cadastrar_pet',
              ),
              _botaoMenu(
                context,
                "Ajuda",
                "Informações e contatos",
                Icons.favorite_border_rounded,
                '/parceiros',
              ),
              _botaoMenu(
                context,
                "Meu Perfil",
                "Configurações da conta",
                Icons.person_outline_rounded,
                '/perfil',
              ),
              const SizedBox(height: 20),
              const Text(
                "Versão 1.0.0",
                style: TextStyle(
                  color: Color(0xFF7A5948),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _botaoMenu(
    BuildContext context,
    String titulo,
    String subtitulo,
    IconData icone,
    String rota,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF7A5948),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, rota),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBE4AD).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icone,
                  size: 30,
                  color: const Color(0xFFFBE4AD),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        color: Color(0xFFFBE4AD),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitulo,
                      style: TextStyle(
                        color: const Color(0xFFFBE4AD).withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Color(0xFFFBE4AD),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
