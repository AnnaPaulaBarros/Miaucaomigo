import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocalizacaoScreen extends StatelessWidget {
  const LocalizacaoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7CC7E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFF7A5948),
        ),
        title: const Text(
          "Miaucaomigo",
          style: TextStyle(
            color: Color(0xFF7A5948),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFF7A5948),
              child: Icon(
                Icons.location_on,
                size: 40,
                color: Color(0xFFF7CC7E),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Localização",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7A5948),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF8B6D4D),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                // Coleção correta: 'animais'
                stream: FirebaseFirestore.instance
                    .collection('animais')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFBE4AD),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "Sem ocorrências recentes.",
                        style: TextStyle(
                          color: Color(0xFFFBE4AD),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.only(
                      top: 40,
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: Color(0xFFFBE4AD),
                      thickness: 0.3,
                    ),
                    itemBuilder: (context, index) {
                      final pet = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;

                      return ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(
                                pet['urlImagem'] ?? '',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          pet['tipo'] ?? 'Miauamigo perdido',
                          style: const TextStyle(
                            color: Color(0xFFFBE4AD),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "Visto em: ${pet['localizacao'] ?? 'Localização ignorada'}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFFBE4AD),
                            fontSize: 12,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFFFBE4AD),
                          size: 14,
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/visualizar-mapa',
                            arguments: pet,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
