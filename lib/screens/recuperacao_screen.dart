import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:miaucaomigo/widgets/pdf_input.dart';
import 'package:miaucaomigo/widgets/base_layout.dart';

class RecuperacaoScreen extends StatefulWidget {
  const RecuperacaoScreen({super.key});

  @override
  State<RecuperacaoScreen> createState() => _RecuperacaoScreenState();
}

class _RecuperacaoScreenState extends State<RecuperacaoScreen> {
  final _email = TextEditingController();
  bool _loading = false;

  Future<void> _resetar() async {
    final emailText = _email.text.trim();

    if (emailText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, insira seu email"),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailText,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Link enviado para o seu email!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao enviar email: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7CC7E),
      body: BaseLayout(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_reset,
                size: 80,
                color: Color(0xFF7A5948),
              ),
              const SizedBox(height: 20),
              const Text(
                "Recuperar Senha",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A5948),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 10,
                ),
                child: Text(
                  "Enviaremos um link de redefinição para o seu e-mail cadastrado.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.brown),
                ),
              ),
              const SizedBox(height: 30),
              PdfInput(
                hint: "Digite seu e-mail",
                controller: _email,
              ),
              const SizedBox(height: 30),
              _loading
                  ? const CircularProgressIndicator(
                      color: Color(0xFF7A5948),
                    )
                  : ElevatedButton(
                      onPressed: _resetar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7A5948),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(280, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        "ENVIAR LINK",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF7A5948),
                ),
                child: const Text(
                  "Voltar para o Login",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
