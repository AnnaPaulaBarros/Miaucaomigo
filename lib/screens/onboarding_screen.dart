import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _paginaAtual = 0;

  final List<Map<String, String>> dadosOnboarding = [
    {
      "titulo": "Olá, eu sou a Aurora!",
      "desc":
          "Seja bem-vindo(a) ao Miaucaomigo! Minha humana, Anna Paula, criou este aplicativo para que, juntos, possamos ajudar animais abandonados a serem vistos, protegidos e encontrarem um lar cheio de amor.",
      "imagem": "assets/ong.png",
    },
    {
      "titulo": "Olá, eu sou o Sheik!",
      "desc":
          "Viu um pet na rua? Tire uma foto na hora! O Miaucaomigo registra o local exato via GPS.",
      "imagem": "assets/localizacao.png",
    },
    {
      "titulo": "Registros de 7 Dias",
      "desc":
          "Para manter a rede sempre atualizada com os últimos passos desse animalzinho, os registros expiram após uma semana. Assim, aguardamos que uma nova pessoa possa avistá-lo e marcar novamente sua localização. Mas fique tranquilo(a): todos os animais continuam aparecendo em nosso feed do Instagram, onde você pode acompanhar cada atualização e torcer pelo resgate.",
      "imagem": "assets/logo.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7CC7E),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => _paginaAtual = index);
                },
                itemCount: dadosOnboarding.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        dadosOnboarding[index]['imagem']!,
                        height: 200,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        dadosOnboarding[index]['titulo']!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7A5948),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: Text(
                          dadosOnboarding[index]['desc']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF8B6D4D),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                dadosOnboarding.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(right: 5),
                  height: 10,
                  width: _paginaAtual == index ? 20 : 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7A5948),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A5948),
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  if (_paginaAtual == dadosOnboarding.length - 1) {
                    Navigator.pushReplacementNamed(context, '/');
                  } else {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  }
                },
                child: Text(
                  _paginaAtual == dadosOnboarding.length - 1
                      ? "COMEÇAR AGORA"
                      : "PRÓXIMO",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
