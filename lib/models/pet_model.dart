class Pet {
  final String id;
  final String nome;
  final String tipo; // Cão ou Gato
  final String raca;
  final String descricao;
  final String imagemUrl;
  final double latitude;
  final double longitude;
  final String usuarioId;

  Pet({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.raca,
    required this.descricao,
    required this.imagemUrl,
    required this.latitude,
    required this.longitude,
    required this.usuarioId,
  });

  // Converte do Firebase para o Objeto Pet
  factory Pet.fromFirestore(Map<String, dynamic> data, String id) {
    return Pet(
      id: id,
      nome: data['nome'] ?? '',
      tipo: data['tipo'] ?? '',
      raca: data['raca'] ?? '',
      descricao: data['descricao'] ?? '',
      imagemUrl: data['imagemUrl'] ?? '',
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      usuarioId: data['usuarioId'] ?? '',
    );
  }
}
