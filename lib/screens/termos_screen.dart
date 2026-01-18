import 'package:flutter/material.dart';

class TermosScreen extends StatelessWidget {
  const TermosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7CC7E),
      appBar: AppBar(
        title: const Text(
          "Termos de Uso",
          style: TextStyle(
            color: Color(0xFF7A5948),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color(0xFF7A5948),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFBE4AD),
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: const Text(
                  "Última atualização: 16 de janeiro de 2026.\n\n"
                  "1. ACEITAÇÃO DOS TERMOS\n"
                  "Ao criar uma conta ou utilizar o aplicativo Miaucaomigo, você declara que leu, compreendeu e concorda integralmente com estes Termos de Uso e com a nossa Política de Privacidade.\n\n"
                  "2. OBJETIVO DO APLICATIVO\n"
                  "O Miaucaomigo é uma plataforma de apoio à adoção responsável de animais, permitindo o cadastro e a visualização de animais, bem como o compartilhamento de informações sobre localização e cuidados, sempre priorizando o bem-estar animal.\n\n"
                  "3. CADASTRO E RESPONSABILIDADE DO USUÁRIO\n"
                  "O usuário compromete-se a fornecer informações verdadeiras, completas e atualizadas, utilizar apenas imagens e conteúdos de sua autoria ou devidamente autorizados, e manter a confidencialidade de seus dados de acesso. O uso indevido da plataforma poderá resultar na suspensão ou exclusão da conta.\n\n"
                  "4. CONTEÚDO INSERIDO PELO USUÁRIO\n"
                  "Todo conteúdo publicado no aplicativo é de inteira responsabilidade do usuário. O Miaucaomigo não se responsabiliza por informações incorretas, imagens inadequadas ou ações tomadas por terceiros com base nesses dados.\n\n"
                  "5. LOCALIZAÇÃO E REGISTROS\n"
                  "O aplicativo pode utilizar dados de localização para indicar onde um animal foi avistado. Os registros possuem caráter temporário e podem expirar após determinado período, com o objetivo de manter as informações atualizadas.\n\n"
                  "6. BEM-ESTAR ANIMAL E CONDUTAS PROIBIDAS\n"
                  "O Miaucaomigo não tolera qualquer forma de maus-tratos a animais. Denúncias ou indícios de abuso, negligência ou uso indevido da plataforma poderão resultar no banimento imediato da conta.\n\n"
                  "7. PRIVACIDADE E PROTEÇÃO DE DADOS\n"
                  "Os dados pessoais coletados são tratados conforme a Lei Geral de Proteção de Dados (Lei nº 13.709/2018 – LGPD) e de acordo com a nossa Política de Privacidade.\n\n"
                  "8. LIMITAÇÃO DE RESPONSABILIDADE\n"
                  "O Miaucaomigo atua como uma plataforma intermediária e não garante a adoção efetiva dos animais, a veracidade absoluta das informações fornecidas por usuários ou a conduta de terceiros, ONGs ou adotantes.\n\n"
                  "9. ALTERAÇÕES DOS TERMOS\n"
                  "Estes Termos de Uso podem ser atualizados a qualquer momento. O uso contínuo do aplicativo após alterações implica na aceitação automática da versão atualizada.\n\n"
                  "10. CONTATO\n"
                  "Em caso de dúvidas ou solicitações, entre em contato pelo e-mail: miaucaomigo@gmail.com",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF7A5948),
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 20,
            ),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B6D4D),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "ENTENDI",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
