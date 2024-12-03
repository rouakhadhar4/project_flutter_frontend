import 'package:flutter/material.dart';
import 'dart:convert'; // Pour gérer JSON
import 'package:http/http.dart' as http;

import '../models/employee.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final Employee? employee;

  EmployeeDetailScreen({this.employee});

  @override
  _EmployeeDetailScreenState createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  late TextEditingController _prenomController;
  late TextEditingController _nomController;
  late TextEditingController _emailController;
  late TextEditingController _telephoneController;
  late TextEditingController _posteController;
  late TextEditingController _salaireController;
  late TextEditingController _dateEmbaucheController;

  String? _selectedProjetId;
  String? _selectedDepartementId;

  List<dynamic> projets = [];
  List<dynamic> departements = [];
  bool isLoading = true;

  String logMessage = '';

  @override
  void initState() {
    super.initState();
    _prenomController = TextEditingController(text: widget.employee?.prenom ?? '');
    _nomController = TextEditingController(text: widget.employee?.nom ?? '');
    _emailController = TextEditingController(text: widget.employee?.email ?? '');
    _telephoneController = TextEditingController(text: widget.employee?.telephone ?? '');
    _posteController = TextEditingController(text: widget.employee?.poste ?? '');
    _salaireController = TextEditingController(text: widget.employee?.salaire?.toString() ?? '');
    _dateEmbaucheController = TextEditingController(text: widget.employee?.dateEmbauche ?? '');

    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final projetsResponse = await http.get(Uri.parse('http://10.0.2.2:8045/api/projets'));
      final departementsResponse = await http.get(Uri.parse('http://10.0.2.2:8045/api/departements'));

      _updateLogMessage('Projets Response: ${projetsResponse.statusCode}');
      _updateLogMessage('Départements Response: ${departementsResponse.statusCode}');

      if (projetsResponse.statusCode == 200 && departementsResponse.statusCode == 200) {
        setState(() {
          projets = json.decode(projetsResponse.body);
          departements = json.decode(departementsResponse.body);
          isLoading = false;
        });
        _updateLogMessage('Projets et départements récupérés avec succès.');
      } else {
        _updateLogMessage('Erreur lors de la récupération des projets ou départements: '
            '${projetsResponse.statusCode}, ${departementsResponse.statusCode}');
      }
    } catch (e) {
      _updateLogMessage('Erreur réseau ou serveur: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _updateLogMessage(String message) {
    setState(() {
      logMessage = message;
    });
    print(message); // Garder le log dans la console aussi
  }

  Future<void> _saveEmployee() async {
    // Ajout de vérification avant envoi des données
    if (_prenomController.text.isEmpty || _nomController.text.isEmpty || _emailController.text.isEmpty) {
      _updateLogMessage('Veuillez remplir tous les champs obligatoires.');
      return;
    }

    if (_selectedProjetId == null || _selectedDepartementId == null) {
      _updateLogMessage('Veuillez sélectionner un projet et un département.');
      return;
    }

    final employeeData = {
      "prenom": _prenomController.text,
      "nom": _nomController.text,
      "email": _emailController.text,
      "telephone": _telephoneController.text,
      "poste": _posteController.text,
      "salaire": double.tryParse(_salaireController.text) ?? 0.0,
      "dateEmbauche": _dateEmbaucheController.text,
      "projetId": _selectedProjetId,
      "departementId": _selectedDepartementId,
    };


    _updateLogMessage('Données prêtes à être envoyées: $employeeData');

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8045/api/employes'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(employeeData),
      );

      _updateLogMessage('Response: ${response.statusCode}');
      _updateLogMessage('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _updateLogMessage('Employé sauvegardé avec succès.');
      } else {
        _updateLogMessage('Erreur serveur: ${response.statusCode}, Message: ${response.body}');
      }
    } catch (e) {
      _updateLogMessage('Erreur réseau ou autre: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee == null ? 'Ajouter un employé' : 'Modifier l\'employé'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _prenomController,
              decoration: InputDecoration(labelText: 'Prénom'),
            ),
            TextField(
              controller: _nomController,
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _telephoneController,
              decoration: InputDecoration(labelText: 'Téléphone'),
            ),
            TextField(
              controller: _posteController,
              decoration: InputDecoration(labelText: 'Poste'),
            ),
            TextField(
              controller: _salaireController,
              decoration: InputDecoration(labelText: 'Salaire'),
            ),
            TextField(
              controller: _dateEmbaucheController,
              decoration: InputDecoration(labelText: 'Date d\'embauche'),
            ),
            DropdownButton<String>(
              value: _selectedProjetId,
              hint: Text('Sélectionner un ID de projet'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedProjetId = newValue;
                });
              },
              items: projets.map<DropdownMenuItem<String>>((dynamic projet) {
                return DropdownMenuItem<String>(
                  value: projet['id'].toString(),
                  child: Text(projet['id'].toString()),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: _selectedDepartementId,
              hint: Text('Sélectionner un ID de département'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDepartementId = newValue;
                });
              },
              items: departements.map<DropdownMenuItem<String>>((dynamic departement) {
                return DropdownMenuItem<String>(
                  value: departement['id'].toString(),
                  child: Text(departement['id'].toString()),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _saveEmployee,
              child: Text('Sauvegarder'),
            ),
            SizedBox(height: 16.0),
            Text(
              logMessage,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
