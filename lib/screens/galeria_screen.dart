import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'visualizar_mapa_screen.dart';

class GaleriaScreen extends StatefulWidget {
  const GaleriaScreen({super.key});

  @override
  State<GaleriaScreen> createState() => _GaleriaScreenState();
}

class _GaleriaScreenState extends State<GaleriaScreen> {
  String filtroSelecionado = 'Todos';
  final List<String> categorias = [
    'Todos',
    'Cachorro',
    'Cadela',
    'Gato',
    'Gata'
  ];

  @override
  void initState() {
    super.initState();
    _limparRegistrosExpirados();
  }

  // Apaga automaticamente postagens com mais de 7 dias
  Future<void> _limparRegistrosExpirados() async {
    final limiteSeteDias = DateTime.now().subtract(const Duration(days: 7));
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('pets')
          .where('dataCriacao', isLessThan: Timestamp.fromDate(limiteSeteDias))
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      debugPrint("Erro na limpeza automática: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance.collection('pets');

    if (filtroSelecionado != 'Todos') {
      query = query.where('tipo', isEqualTo: filtroSelecionado);
    }

    query = query.orderBy('dataCriacao', descending: true);

    return Scaffold(
      backgroundColor: const Color(0xFFF7CC7E),
      appBar: AppBar(
        title: const Text(
          "Miaucaomigo",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF7A5948),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFiltros(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                      child: Text(
                          "Erro ao carregar pets. Verifique o índice no Firebase."));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF7A5948)),
                  );
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return const Center(
                    child: Text("Nenhum pet encontrado nesta categoria."),
                  );
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return _buildPetCard(data);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltros() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        children: categorias.map((cat) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(cat),
              selected: filtroSelecionado == cat,
              selectedColor: const Color(0xFF7A5948),
              backgroundColor: const Color(0xFFFBE4AD),
              labelStyle: TextStyle(
                color: filtroSelecionado == cat
                    ? Colors.white
                    : const Color(0xFF7A5948),
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onSelected: (bool selected) {
                setState(() {
                  filtroSelecionado = cat;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPetCard(Map<String, dynamic> data) {
    String nome = data['nome'] ?? "Sem nome";
    String imagem = data['imagemUrl'] ?? "";
    String raca = data['raca'] ?? "Não informada";

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFBE4AD),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFF7A5948), width: 1.5),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(23)),
            child: imagem.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imagem,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF7A5948),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(
                        Icons.error,
                        size: 60,
                        color: Colors.red,
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 250,
                    child: Icon(Icons.pets, size: 80, color: Color(0xFF7A5948)),
                  ),
          ),
          ListTile(
            title: Text(
              nome,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF7A5948)),
            ),
            subtitle: Text("Raça: $raca"),
            trailing: IconButton(
              icon: const Icon(Icons.share, color: Color(0xFF7A5948)),
              onPressed: () {
                Share.share(
                  '🐾 Ajude o $nome! Encontrei este amiguinho no Miaucaomigo.\nVeja a foto: $imagem',
                  subject: 'Pet Encontrado!',
                );
              },
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VisualizarMapaScreen(petData: data),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: const BoxDecoration(
                color: Color(0xFF7A5948),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                ),
              ),
              child: const Text(
                "VER NO MAPA",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
