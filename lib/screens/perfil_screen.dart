import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final _nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nomeController.text = user?.displayName ?? "";
  }

  void _abrirCarrossel(
    List<QueryDocumentSnapshot> docs,
    int indexInicial,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              "Minhas Publicações",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: PageView.builder(
            itemCount: docs.length,
            controller: PageController(initialPage: indexInicial),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: InteractiveViewer(
                      child: Image.network(
                        data['imagemUrl'],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    color: Colors.black87,
                    child: Text(
                      "Local: ${data['localizacao'] ?? 'Não informado'}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _editarNomeUsuario() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFBE4AD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Color(0xFF7A5948),
            width: 2,
          ),
        ),
        title: const Text(
          "Editar Nome",
          style: TextStyle(
            color: Color(0xFF7A5948),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: _nomeController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "CANCELAR",
              style: TextStyle(color: Colors.brown),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7A5948),
            ),
            onPressed: () async {
              final navigator = Navigator.of(ctx);

              await user?.updateDisplayName(_nomeController.text);
              await user?.reload();

              if (!mounted) return;

              setState(() {});
              navigator.pop();
              _notificar("Nome atualizado!");
            },
            child: const Text(
              "SALVAR",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _excluirConta() async {
    final confirmar = await _mostrarConfirmacao(
      "Excluir Conta",
      "Esta ação é permanente. Deseja apagar seu acesso?",
    );

    if (!mounted) return;

    if (confirmar) {
      final navigator = Navigator.of(context);

      try {
        await user?.delete();
        navigator.pushReplacementNamed('/');
      } catch (e) {
        _notificar(
          "Saia e entre novamente antes de excluir por segurança.",
        );
      }
    }
  }

  Future<void> _excluirRegistro(String docId) async {
    final confirmar = await _mostrarConfirmacao(
      "Excluir Foto",
      "Deseja remover este registro?",
    );

    if (!mounted) return;

    if (confirmar) {
      await FirebaseFirestore.instance.collection('pets').doc(docId).delete();
      _notificar("Registro excluído.");
    }
  }

  void _notificar(String msg) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFF7A5948),
      ),
    );
  }

  Future<bool> _mostrarConfirmacao(
    String titulo,
    String msg,
  ) async {
    final resultado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFBE4AD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Color(0xFF7A5948),
            width: 2,
          ),
        ),
        title: Text(
          titulo,
          style: const TextStyle(
            color: Color(0xFF7A5948),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          msg,
          style: const TextStyle(color: Color(0xFF7A5948)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              "NÃO",
              style: TextStyle(color: Colors.brown),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7A5948),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              "SIM",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    return resultado ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7CC7E),
      appBar: AppBar(
        title: const Text(
          "Meu Perfil",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF7A5948),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final navigator = Navigator.of(context);
              await FirebaseAuth.instance.signOut();
              navigator.pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 40,
            backgroundColor: Color(0xFF7A5948),
            child: Icon(
              Icons.person,
              size: 50,
              color: Color(0xFFFBE4AD),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user?.displayName ?? "Usuário",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A5948),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  size: 20,
                  color: Color(0xFF7A5948),
                ),
                onPressed: _editarNomeUsuario,
              ),
            ],
          ),
          Text(
            user?.email ?? "",
            style: const TextStyle(color: Colors.brown),
          ),
          TextButton(
            onPressed: _excluirConta,
            child: const Text(
              "Excluir minha conta",
              style: TextStyle(color: Colors.brown),
            ),
          ),
          const Divider(
            thickness: 1,
            indent: 30,
            endIndent: 30,
            color: Color(0xFF7A5948),
          ),
          const Text(
            "MINHAS PUBLICAÇÕES",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7A5948),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('pets')
                  .where('userId', isEqualTo: user?.uid) // ✅ Filtra pelo userId
                  .orderBy('dataCriacao', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF7A5948),
                    ),
                  );
                }

                final docs = snapshot.data!.docs;

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final pet = docs[index];

                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () => _abrirCarrossel(docs, index),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF7A5948),
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                pet['imagemUrl'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _excluirRegistro(pet.id),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
