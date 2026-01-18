import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _isLoading = false;
  bool _senhaVisivel = false;

  final _bordaEstilizada = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(
      color: Color(0xFF7A5948),
      width: 2,
    ),
  );

  // --- RECUPERAR SENHA ---
  Future<void> _recuperarSenha() async {
    final TextEditingController emailRecuperarController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFBE4AD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF7A5948), width: 3),
        ),
        title: const Text(
          "Recuperar Senha",
          style:
              TextStyle(color: Color(0xFF7A5948), fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Digite seu e-mail para receber o link de redefinição.",
              style: TextStyle(color: Color(0xFF7A5948)),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: emailRecuperarController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "E-mail cadastrado",
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.5),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xFF7A5948)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      const BorderSide(color: Color(0xFF7A5948), width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text("Cancelar", style: TextStyle(color: Colors.brown)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7A5948)),
            onPressed: () async {
              if (emailRecuperarController.text.isNotEmpty) {
                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(
                    email: emailRecuperarController.text.trim(),
                  );

                  // Proteção para o diálogo
                  if (!context.mounted) return;

                  Navigator.of(context).pop();
                  _mensagem("E-mail enviado! Verifique sua caixa.");
                } catch (e) {
                  if (!context.mounted) return;
                  _mensagem("Erro: Verifique o e-mail digitado.");
                }
              }
            },
            child: const Text("Enviar", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --- LOGIN ---
  Future<void> _login() async {
    final String email = _emailController.text.trim();
    final String senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      _mensagem("Preencha todos os campos!");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // Verificação de segurança após await
      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed('/menu');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _tratarErroFirebase(e);
    } catch (e) {
      if (!mounted) return;
      _mensagem("Erro inesperado ao realizar login.");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _tratarErroFirebase(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        _mensagem("E-mail não encontrado.");
        break;
      case 'wrong-password':
        _mensagem("Senha incorreta.");
        break;
      case 'invalid-email':
        _mensagem("Formato de e-mail inválido.");
        break;
      case 'user-disabled':
        _mensagem("Este usuário foi desativado.");
        break;
      default:
        _mensagem("Erro ao entrar: ${e.message}");
    }
  }

  void _mensagem(String texto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        backgroundColor: const Color(0xFF7A5948),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7CC7E),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color(0xFFF7CC7E),
                borderRadius: BorderRadius.circular(45),
                border: Border.all(color: const Color(0xFF7A5948), width: 4),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset('assets/logo.png',
                    height: 220, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Miaucaomigo",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A5948)),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFFBE4AD),
                prefixIcon: const Icon(Icons.email, color: Color(0xFF7A5948)),
                hintText: "E-mail",
                enabledBorder: _bordaEstilizada,
                focusedBorder: _bordaEstilizada.copyWith(
                    borderSide:
                        const BorderSide(color: Color(0xFF7A5948), width: 3)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _senhaController,
              obscureText: !_senhaVisivel,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFFBE4AD),
                prefixIcon: const Icon(Icons.lock, color: Color(0xFF7A5948)),
                suffixIcon: IconButton(
                  icon: Icon(
                      _senhaVisivel ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xFF7A5948)),
                  onPressed: () =>
                      setState(() => _senhaVisivel = !_senhaVisivel),
                ),
                hintText: "Senha",
                enabledBorder: _bordaEstilizada,
                focusedBorder: _bordaEstilizada.copyWith(
                    borderSide:
                        const BorderSide(color: Color(0xFF7A5948), width: 3)),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _recuperarSenha,
                child: const Text("Esqueci a senha",
                    style: TextStyle(
                        color: Color(0xFF7A5948), fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7A5948),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(color: Colors.white))
                  : const Text("ENTRAR",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // CORREÇÃO PARA A LINHA 129:
                // Mesmo em funções síncronas dentro do build, o Flutter
                // recomenda garantir que o widget está montado antes de navegar.
                if (mounted) {
                  Navigator.pushNamed(context, '/cadastro');
                }
              },
              child: const Text(
                "Ainda não tem conta? Clique aqui",
                style: TextStyle(
                    color: Color(0xFF7A5948),
                    decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
