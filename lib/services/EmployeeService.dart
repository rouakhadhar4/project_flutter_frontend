import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee.dart';

class EmployeeService {
  static const String baseUrlEmployees = 'http://10.0.2.2:8045/api/employes';  // URL pour les employés
  static const String baseUrlDepartements = 'http://10.0.2.2:8045/api/departements';  // URL pour les départements
  static const String baseUrlProjets = 'http://10.0.2.2:8045/api/projets';
  Future<void> addEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse(baseUrlEmployees),
      headers: {
        'Content-Type': 'application/json', // Specify content type as JSON
      },
      body: json.encode(employee.toJson()), // Send the employee data as JSON
    );

    if (response.statusCode == 201) {
      print('Employee added successfully');
    } else {
      throw Exception('Failed to add employee');
    }
  }
  Future<void> deleteEmployee(int employeeId) async {
    final response = await http.delete(Uri.parse('http://10.0.2.2:8045/api/employes/$employeeId'));
    if (response.statusCode != 200) {
      throw Exception('Échec de la suppression de l\'employé');
    }
  }


  // Récupérer la liste des départements
  Future<List<Map<String, dynamic>>> getDepartements() async {
    final response = await http.get(Uri.parse(baseUrlDepartements));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Erreur lors de la récupération des départements');
    }
  }

  // Récupérer la liste des projets
  Future<List<Map<String, dynamic>>> getProjets() async {
    final response = await http.get(Uri.parse(baseUrlProjets));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Erreur lors de la récupération des projets');
    }
  }
  Future<List<Employee>> getEmployees() async {
    final response = await http.get(Uri.parse(baseUrlEmployees));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Employee.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des employés');
    }
  }
  Future<List<Employee>> getAllEmployees() async {
    final response = await http.get(Uri.parse(baseUrlEmployees));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Employee.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des employés');
    }
  }


  // Ajouter ou modifier un employé
  Future<void> saveEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse(baseUrlEmployees),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(employee.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la sauvegarde de l\'employé');
    }
  }
}
