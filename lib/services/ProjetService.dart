import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/department.dart';
import '../models/Projet.dart';


class ProjetService {
  static const String baseUrl = 'http://10.0.2.2:8045/api/projets';
  Future<List<Projet>> getProjets() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Projet.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }
  Future<List<Department>> getDepartements() async {
    try {
      // Utilisation de l'URL correcte
      final response = await http.get(Uri.parse('http://10.0.2.2:8045/api/departements'));

      if (response.statusCode == 200) {
        // Si la réponse est réussie, parsez la liste des départements
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Department.fromJson(item)).toList(); // Convertir les données en objets Department
      } else {
        throw Exception('Failed to load departments');
      }
    } catch (e) {
      throw Exception('Error fetching departments: $e');

    }
  }


  // Récupérer tous les projets
  Future<List<Projet>> getAllProjets() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Projet.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load projets');
    }
  }
// Delete a project
  Future<void> deleteProjet(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete projet');
    }
  }
  Future<void> updateProjet(Projet projet) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:8045/api/projets/${projet.id}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'nom': projet.nom,
        'description': projet.description,
        'budget': projet.budget,
        'dateDebut': projet.dateDebut,
        'dateFin': projet.dateFin,
        'departementId': projet.departement?.id,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Échec de la mise à jour');
    }
  }

  // Récupérer un projet par ID
  Future<Projet> getProjetById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Projet.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load projet');
    }
  }

  Future<Projet> createProjet(Projet projet) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(projet.toJson()),  // Le corps de la requête
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      return Projet.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create projet: ${response.statusCode}');
    }

  }







}
