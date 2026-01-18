import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  // Controllers
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  // Estados
  bool _isLoading = false;
  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;
  bool _aceitouTermos = false;

  // --- CADASTRO ---
  Future<void> _cadastrar() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();
    final confirma = _confirmarSenhaController.text.trim();

    if (email.isEmpty || senha.isEmpty || confirma.isEmpty) {
      _mensagem("Por favor, preencha todos os campos!");
      return;
    }

    if (senha != confirma) {
      _mensagem("As senhas não coincidem!");
      return;
    }

    if (!_aceitouTermos) {
      _mensagem("Você precisa aceitar os Termos de Uso.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Cria o usuário no Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // 2. ENVIA E-MAIL DE VERIFICAÇÃO (Adicionado aqui)
      // Isso ajuda a validar a conta e resolver problemas de permissão no futuro
      await userCredential.user?.sendEmailVerification();

      _mensagem(
          "Conta criada! Verifique seu e-mail para confirmar o cadastro.");

      if (mounted) {
        // Redireciona para o menu após o sucesso
        Navigator.pushReplacementNamed(context, '/menu');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _mensagem("Este e-mail já está registrado.");
      } else if (e.code == 'weak-password') {
        _mensagem("A senha deve ter pelo menos 6 caracteres.");
      } else if (e.code == 'invalid-email') {
        _mensagem("O formato do e-mail é inválido.");
      } else {
        _mensagem("Erro: ${e.message}");
      }
    } catch (_) {
      _mensagem("Ocorreu um erro inesperado.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- MENSAGEM ---
  void _mensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        backgroundColor: const Color(0xFF8B6D4D),
        duration: const Duration(
            seconds: 4), // Aumentado para dar tempo de ler sobre o e-mail
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7CC7E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF7A5948)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            Image.asset(
              'assets/localizacao.png',
              height: 220,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            const Text(
              "Criar Conta",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7A5948),
              ),
            ),
            const SizedBox(height: 25),

            // EMAIL
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFFBE4AD),
                prefixIcon: const Icon(Icons.email, color: Color(0xFF7A5948)),
                hintText: "E-mail",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // SENHA
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
                    color: const Color(0xFF7A5948),
                  ),
                  onPressed: () =>
                      setState(() => _senhaVisivel = !_senhaVisivel),
                ),
                hintText: "Senha",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // CONFIRMAR SENHA
            TextField(
              controller: _confirmarSenhaController,
              obscureText: !_confirmarSenhaVisivel,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFFBE4AD),
                prefixIcon:
                    const Icon(Icons.lock_outline, color: Color(0xFF7A5948)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _confirmarSenhaVisivel
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: const Color(0xFF7A5948),
                  ),
                  onPressed: () => setState(
                      () => _confirmarSenhaVisivel = !_confirmarSenhaVisivel),
                ),
                hintText: "Repetir Senha",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // TERMOS
            Row(
              children: [
                Checkbox(
                  value: _aceitouTermos,
                  activeColor: const Color(0xFF8B6D4D),
                  onChanged: (val) => setState(() => _aceitouTermos = val!),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/termos'),
                    child: const Text(
                      "Li e aceito os Termos e Condições",
                      style: TextStyle(
                        color: Color(0xFF7A5948),
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // BOTÃO
            ElevatedButton(
              onPressed: _isLoading ? null : _cadastrar,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B6D4D),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "CADASTRAR",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
