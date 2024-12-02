import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/department.dart';

class DepartmentService {
  static const String apiUrl = 'http://10.0.2.2:8045/api/departements';

  // Récupérer la liste des départements
  Future<List<Department>> fetchDepartments() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Department.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des départements');
      }
    } catch (error) {
      throw Exception('Une erreur est survenue : $error');
    }
  }
  Future<void> addDepartment(Department department) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(department.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success case (e.g., 200 or 201 Created)
        print('Département ajouté avec succès!');
      } else {
        // If response status is not successful, log the status code and response body
        throw Exception('Échec de l\'ajout du département. Statut: ${response.statusCode}, Réponse: ${response.body}');
      }
    } catch (error) {
      // Catch and log any error that occurs during the request
      throw Exception('Une erreur est survenue lors de l\'ajout du département: $error');
    }
  }

  // Mettre à jour un département
  Future<void> updateDepartment(int id, Department department, Function onSuccess, Function onError) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(department.toJson()),
      );

      if (response.statusCode == 200) {
        onSuccess();
      } else {
        onError('Erreur lors de la mise à jour du département');
      }
    } catch (error) {
      onError('Une erreur est survenue : $error');
    }
  }

  // Supprimer un département
  Future<void> deleteDepartment(int id, Function onSuccess, Function onError) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$id'));

      if (response.statusCode == 200) {
        onSuccess();
      } else {
        onError('Erreur lors de la suppression du département');
      }
    } catch (error) {
      onError('Une erreur est survenue : $error');
    }
  }
}
