import 'Department.dart';
import 'Projet.dart';

class Employee {
  final int? id;
  final String prenom;
  final String nom;
  final String email;
  final String telephone;
  final String poste;
  final double salaire;
  final String dateEmbauche;
  final Projet projet;  // Objet Projet au lieu de projetId
  final Department departement;  // Objet Departement au lieu de departementId
  final String? imageUrl;

  Employee({
    this.id,
    required this.prenom,
    required this.nom,
    required this.email,
    required this.telephone,
    required this.poste,
    required this.salaire,
    required this.dateEmbauche,
    required this.projet,
    required this.departement,
    this.imageUrl,

  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prenom': prenom,
      'nom': nom,
      'email': email,
      'telephone': telephone,
      'poste': poste,
      'salaire': salaire,
      'dateEmbauche': dateEmbauche,
      'projet': projet.toJson(),
      'departement': departement.toJson(),
      'imageUrl': imageUrl,
    };
  }

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      prenom: json['prenom'],
      nom: json['nom'],
      email: json['email'],
      telephone: json['telephone'],
      poste: json['poste'],
      salaire: json['salaire'],
      dateEmbauche: json['dateEmbauche'],
      projet: Projet.fromJson(json['projet']),
      departement: Department.fromJson(json['departement']),
      imageUrl: json['imageUrl'],
    );
  }
}
