import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart'; // Importante para links de site

class OngsScreen extends StatefulWidget {
  const OngsScreen({super.key});

  @override
  State<OngsScreen> createState() => _OngsScreenState();
}

class _OngsScreenState extends State<OngsScreen> {
  final _nomeController = TextEditingController();
  final _msgController = TextEditingController();
  final PageController _pageController = PageController();

  // Lista atualizada com Site ou Endereço
  final List<Map<String, String>> listaOngs = [
    {
      "nome": "Idapaisagismo - Gramados e arborização para o seu animalzinho",
      "site": "https://www.idapaisagismo.com",
    },
    {
      "nome": "ALPA's - ONG para você ajudar",
      "site": "https://www.instagram.com/alpasongpl",
    },
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    _msgController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // Função para abrir links de site
  Future<void> _abrirSite(String url) async {
    try {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Erro ao abrir site: $e");
    }
  }

  Future<void> _fazerLigacao(String telefone) async {
    final Uri telUri = Uri(scheme: 'tel', path: telefone);
    try {
      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
      }
    } catch (e) {
      debugPrint("Erro ao ligar: $e");
    }
  }

  Future<void> _enviarEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'miaucaomigo@gmail.com',
      query:
          'subject=Nova ONG: ${_nomeController.text}&body=${_msgController.text}',
    );
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      }
    } catch (e) {
      debugPrint("Erro ao enviar email: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7CC7E),
      appBar: AppBar(
        title: const Text(
          "Miaucaomigo",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF7A5948),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Denunciar Maus-Tratos ⚠️",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A5948)),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFFBE4AD),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF7A5948), width: 2),
              ),
              child: Column(
                children: [
                  const Text(
                    "Em caso de maus-tratos, procurar as autoridades mais próximas.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF7A5948), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _botaoInformacao(
                          "A vida desse animalzinho depende de você!",
                          Icons.info),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),
            const Text(
              "Amigos do Miaucaomigo",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A5948)),
            ),
            const SizedBox(height: 15),

            // CARROSSEL AJUSTADO
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Color(0xFF7A5948), size: 30),
                    onPressed: () => _pageController.previousPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: listaOngs.length,
                      itemBuilder: (context, index) {
                        final ong = listaOngs[index];
                        final temEndereco = ong.containsKey('endereco');
                        final temSite = ong.containsKey('site');

                        return InkWell(
                          onTap: () {
                            if (temSite) {
                              _abrirSite(ong["site"]!);
                            } else {
                              _fazerLigacao(ong["tel"]!);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7A5948),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  ong["nome"]!.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Color(0xFFFBE4AD),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                if (temEndereco)
                                  Text(
                                    ong["endereco"]!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                if (temSite)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      ong["site"]!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Color(0xFFFBE4AD),
                                          fontSize: 12,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(temSite ? Icons.language : Icons.phone,
                                        color: const Color(0xFFFBE4AD),
                                        size: 16),
                                    const SizedBox(width: 5),
                                    Text(
                                      temSite ? "VISITAR SITE" : ong["tel"]!,
                                      style: const TextStyle(
                                          color: Color(0xFFFBE4AD),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios_outlined,
                        color: Color(0xFF7A5948), size: 30),
                    onPressed: () => _pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),
            const Text("Dicas de Cuidado",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7A5948))),
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFBE4AD),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF7A5948), width: 2),
              ),
              child: const Text(
                "• Ofereça água limpa e alimentação adequada.\n"
                "• Mantenha as vacinas e vermifugação em dia.\n"
                "• Castração evita o abandono e ajuda na saúde do animal.\n"
                "• Cuidado com a exposição ao sol: lembre-se que você usa calçado, ele não.\n"
                "• Evite guizos/coleiras: o barulho constante pode causar stress e medo.",
                style: TextStyle(
                    color: Color(0xFF7A5948),
                    fontSize: 15,
                    height: 1.6,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 35),
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                hintText: "Assunto da mensagem...",
                filled: true,
                fillColor: const Color(0xFFFBE4AD),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _enviarEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A5948),
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("SOLICITAR INFORMAÇÃO",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _botaoInformacao(String label, IconData icone) {
    return ElevatedButton.icon(
      onPressed: () {
        // Aqui pode abrir um dialog ou outra tela com orientações
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7A5948),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      icon: Icon(icone, size: 20),
      label: Text(label),
    );
  }
}
