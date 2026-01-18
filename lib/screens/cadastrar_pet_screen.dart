import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';

class CadastroPetScreen extends StatefulWidget {
  const CadastroPetScreen({super.key});

  @override
  State<CadastroPetScreen> createState() => _CadastroPetScreenState();
}

class _CadastroPetScreenState extends State<CadastroPetScreen> {
  // 1. Controllers para todos os campos
  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _referenciaController = TextEditingController();

  // 2. Variáveis de estado
  String _tipoSelecionado = 'Cachorro';
  String _idadeSelecionada = 'Filhote';
  String _porteSelecionado = 'Pequeno';
  bool _isLoading = false;
  double _progressoUpload = 0;

  final List<String> _categorias = ['Cachorro', 'Cadela', 'Gato', 'Gata'];
  final List<String> _idades = ['Filhote', 'Adulto', 'Idoso'];
  final List<String> _portes = ['Pequeno', 'Médio', 'Grande'];

  File? _image;
  Uint8List? _webImage;
  final ImagePicker _picker = ImagePicker();

  // 3. O "Tema" dos inputs (Bege com borda Marrom)
  InputDecoration _inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFFBE4AD),
      labelStyle: const TextStyle(
          color: Color(0xFF7A5948), fontWeight: FontWeight.bold),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xFF7A5948), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xFF7A5948), width: 2.5),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 60);
    if (picked != null) {
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() => _webImage = bytes);
      } else {
        setState(() => _image = File(picked.path));
      }
    }
  }

  Future<void> _obterLocalizacao() async {
    setState(() => _isLoading = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied)
        permission = await Geolocator.requestPermission();
      final position = await Geolocator.getCurrentPosition();
      _enderecoController.text = "${position.latitude}, ${position.longitude}";
    } catch (e) {
      _mensagem("Erro ao obter GPS: $e", cor: Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _cadastrarPet() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _mensagem("Você precisa estar logado!", cor: Colors.red);
      return;
    }

    if ((_image == null && _webImage == null) || _nomeController.text.isEmpty) {
      _mensagem("Informe o nome e escolha uma foto!");
      return;
    }

    setState(() {
      _isLoading = true;
      _progressoUpload = 0;
    });

    try {
      final storage = FirebaseStorage.instanceFor(
          bucket: 'miaucaomigo-f735c.firebasestorage.app');
      final fileName = "pet_${DateTime.now().millisecondsSinceEpoch}.jpg";
      final ref = storage.ref().child("pets/$fileName");

      UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = ref.putData(
            _webImage!, SettableMetadata(contentType: 'image/jpeg'));
      } else {
        uploadTask =
            ref.putFile(_image!, SettableMetadata(contentType: 'image/jpeg'));
      }

      uploadTask.snapshotEvents.listen((snapshot) {
        setState(() =>
            _progressoUpload = snapshot.bytesTransferred / snapshot.totalBytes);
      });

      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      double lat = 0;
      double lon = 0;
      if (_enderecoController.text.contains(',')) {
        final parts = _enderecoController.text.split(',');
        lat = double.tryParse(parts[0].trim()) ?? 0;
        lon = double.tryParse(parts[1].trim()) ?? 0;
      }

      await FirebaseFirestore.instance.collection('pets').add({
        'nome': _nomeController.text.trim(),
        'tipo': _tipoSelecionado,
        'idade': _idadeSelecionada,
        'porte': _porteSelecionado,
        'descricao': _descricaoController.text.trim(),
        'raca': _racaController.text.trim(),
        'imagemUrl': imageUrl,
        'latitude': lat,
        'longitude': lon,
        'localizacao': _enderecoController.text.trim(),
        'referencia': _referenciaController.text.trim(),
        'userId': user.uid,
        'dataCriacao': Timestamp.now(),
      });

      if (!mounted) return;
      setState(() => _progressoUpload = 1.0);
      await Future.delayed(const Duration(seconds: 2));

      _mensagem("🐾 Seu cadastro foi para a galeria!", cor: Colors.green);
      Navigator.pushNamedAndRemoveUntil(context, '/galeria', (_) => false);
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _mensagem("Erro ao salvar: $e", cor: Colors.red);
      }
    }
  }

  void _mensagem(String texto, {Color cor = Colors.orange}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(texto), backgroundColor: cor));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7CC7E),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7CC7E),
        elevation: 0,
        centerTitle: true,
        title: const Text("Cadastrar Miaucaomigo",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF7A5948))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 📸 Foto
            GestureDetector(
              onTap: () => _pickImage(ImageSource.gallery),
              child: Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBE4AD),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: const Color(0xFF7A5948), width: 2),
                ),
                child: (_image != null || _webImage != null)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: kIsWeb
                            ? Image.memory(_webImage!, fit: BoxFit.cover)
                            : Image.file(_image!, fit: BoxFit.cover),
                      )
                    : const Icon(Icons.add_a_photo,
                        size: 40, color: Color(0xFF7A5948)),
              ),
            ),
            const SizedBox(height: 25),

            // 📝 Campos do Formulário seguindo o Tema
            TextField(
                controller: _nomeController,
                decoration: _inputStyle("Nome do animal")),
            const SizedBox(height: 12),

            DropdownButtonFormField(
              value: _tipoSelecionado,
              items: _categorias
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _tipoSelecionado = v!),
              decoration: _inputStyle("Tipo"),
              dropdownColor: const Color(0xFFFBE4AD),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField(
              value: _idadeSelecionada,
              items: _idades
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _idadeSelecionada = v!),
              decoration: _inputStyle("Idade"),
              dropdownColor: const Color(0xFFFBE4AD),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField(
              value: _porteSelecionado,
              items: _portes
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _porteSelecionado = v!),
              decoration: _inputStyle("Porte"),
              dropdownColor: const Color(0xFFFBE4AD),
            ),
            const SizedBox(height: 12),

            TextField(
                controller: _racaController,
                decoration: _inputStyle("Raça ou coloração")),
            const SizedBox(height: 12),

            TextField(
                controller: _descricaoController,
                maxLines: 2,
                decoration: _inputStyle("Descrição")),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                    child: TextField(
                        controller: _enderecoController,
                        decoration: _inputStyle("GPS (Lat, Long)"))),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: const Color(0xFF7A5948),
                  child: IconButton(
                    onPressed: _isLoading ? null : _obterLocalizacao,
                    icon: const Icon(Icons.my_location, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            TextField(
                controller: _referenciaController,
                decoration: _inputStyle("Ponto de referência")),
            const SizedBox(height: 30),

            // 🚀 Progresso e Botão
            if (_isLoading) ...[
              LinearProgressIndicator(
                value: _progressoUpload,
                backgroundColor: Colors.white,
                color: const Color(0xFF7A5948),
              ),
              const SizedBox(height: 10),
              Text(
                _progressoUpload >= 1.0
                    ? "Seu cadastro foi para a galeria!"
                    : "${(_progressoUpload * 100).toStringAsFixed(0)}% Enviando...",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF7A5948)),
              ),
            ] else
              ElevatedButton(
                onPressed: _cadastrarPet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A5948),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("SALVAR MIAUCAOMIGO",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }
}
