import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class VisualizarMapaScreen extends StatelessWidget {
  final Map<String, dynamic> petData;

  const VisualizarMapaScreen({super.key, required this.petData});

  @override
  Widget build(BuildContext context) {
    // Extraindo os dados com valores padrão para evitar erros de null
    final String nome = petData['nome'] ?? 'Pet';
    final double latitude = (petData['latitude'] as num?)?.toDouble() ?? 0.0;
    final double longitude = (petData['longitude'] as num?)?.toDouble() ?? 0.0;
    final String localizacao =
        petData['localizacao'] ?? 'Endereço não informado';
    final String referencia = petData['referencia'] ?? '';
    final String imagemUrl = petData['imagemUrl'] ?? '';

    // Função para abrir o Google Maps
    Future<void> _abrirMapaExterno() async {
      // Padrão de URL para abrir o Google Maps em coordenadas específicas
      final String googleMapsUrl =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

      try {
        // Tentamos abrir no aplicativo externo (Google Maps ou Apple Maps)
        await launchUrlString(
          googleMapsUrl,
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        // Caso falhe, tentamos abrir no navegador padrão
        try {
          await launchUrlString(
            googleMapsUrl,
            mode: LaunchMode.platformDefault,
          );
        } catch (err) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Não foi possível abrir o mapa.")),
            );
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7CC7E),
      appBar: AppBar(
        title: Text(
          nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF7A5948),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Container da Imagem do Pet
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xFFFBE4AD),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFF7A5948), width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: imagemUrl.isNotEmpty
                    ? Image.network(
                        imagemUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFF7A5948)),
                          );
                        },
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.broken_image,
                          size: 80,
                          color: Color(0xFF7A5948),
                        ),
                      )
                    : const Icon(Icons.pets,
                        size: 80, color: Color(0xFF7A5948)),
              ),
            ),
            const SizedBox(height: 25),

            // Informações de Localização
            Card(
              color: const Color(0xFFFBE4AD),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(color: Color(0xFF7A5948), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.location_on, color: Color(0xFF7A5948)),
                        SizedBox(width: 8),
                        Text(
                          "Localização",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7A5948),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFF7A5948)),
                    Text(
                      localizacao,
                      style: const TextStyle(fontSize: 16, color: Colors.brown),
                    ),
                    if (referencia.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        "Ponto de referência: $referencia",
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Botão Principal
            ElevatedButton.icon(
              onPressed: _abrirMapaExterno,
              icon: const Icon(Icons.directions, color: Colors.white),
              label: const Text(
                'VER ROTA NO GOOGLE MAPS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7A5948),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Isso abrirá o aplicativo de mapas do seu celular.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Color(0xFF7A5948)),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
