import '../models/department.dart';


class Projet {
  String? id;
  final String nom;
  final String description;
  final double budget;
  final String dateDebut;
  final String dateFin;
  final Department departement;

  Projet({
    required this.id,
    required this.nom,
    required this.description,
    required this.budget,
    required this.dateDebut,
    required this.dateFin,
    required this.departement,
  });

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'nom': nom,
      'description': description,
      'budget': budget,
      'dateDebut': dateDebut,
      'dateFin': dateFin,
      'departement': {
        'id': departement.id, // Envoie seulement l'ID
      },
    };
  }
  Projet.withDefaultId({
    required this.nom,
    required this.description,
    required this.budget,
    required this.dateDebut,
    required this.dateFin,
    required this.departement,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();

  static Projet fromJson(Map<String, dynamic> json) {
    if (json['nom'] == null || json['description'] == null) {
      throw Exception('Données manquantes pour la création du projet');
    }

    return Projet(
      id: json['id'].toString(), // Assurez-vous que l'ID est une chaîne de caractères
      nom: json['nom'],
      description: json['description'],
      budget: json['budget'] ?? 0.0,
      dateDebut: json['dateDebut'] ?? '',
      dateFin: json['dateFin'] ?? '',
      departement: Department(
        id: json['departement']['id'],
        nom: '',
        description: '',
        dateCreation: '',
      ),
    );
  }

}
