import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_flutter/%20screens/statistiques_screen.dart';


import '../ services/EmployeeService.dart';
import '../models/Projet.dart';
import '../models/employee.dart';
import 'DepartmentScreen.dart';
import 'ProjetsListScreen.dart';
import 'employee_detail_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class EmployeeListPage extends StatefulWidget {
  @override
  _EmployeeListPageState createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  late Future<List<Employee>> _employees;
  late Future<List<Projet>> _projects;
  List<Employee> _allEmployees = [];
  List<Employee> _filteredEmployees = [];
  String? _selectedProject;
  List<String> _projectNames = [];

  @override
  void initState() {
    super.initState();
    _loadEmployees();
    _loadProjects();
  }

  void _loadEmployees() {
    _employees = EmployeeService().getEmployees();
    _employees.then((employees) {
      setState(() {
        _allEmployees = employees;
        _filteredEmployees = employees;
      });
    });
  }

  void _loadProjects() {
    // Call the service to fetch the list of projects
    _projects = EmployeeService().getProjets().then((projectsData) {
      // Convert the List<Map<String, dynamic>> to a List<Projet>
      List<Projet> projects = projectsData.map((projectMap) {
        return Projet.fromJson(projectMap);  // Use a method to convert Map to Projet
      }).toList();

      // Update the state with the list of projects
      setState(() {
        _projectNames = projects.map((e) => e.nom).toList();
        _projectNames.sort();  // Sort projects alphabetically
      });

      return projects;  // Return the list of Projet objects
    });

    // No need for the then() method on the _projects assignment anymore,
    // since we've handled it above.
  }

  void _filterEmployees(String? projectName) {
    setState(() {
      if (projectName == null || projectName.isEmpty) {
        _filteredEmployees = _allEmployees;
      } else {
        _filteredEmployees = _allEmployees
            .where((employee) => employee.projet.nom == projectName)
            .toList();
      }
    });
  }

  Future<void> _deleteEmployee(int employeeId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:8045/api/employes/$employeeId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          // Supprimer l'employé localement des listes
          _allEmployees.removeWhere((employee) => employee.id == employeeId);
          _filteredEmployees.removeWhere((employee) => employee.id == employeeId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Employé supprimé avec succès.')),
        );
      } else {
        throw Exception('Échec de la suppression de l\'employé');
      }
    } catch (e) {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ('Employés'),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 5.0,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
        ),

      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<Projet>>(
              future: _projects,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erreur: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return DropdownButton<String>(
                    value: _selectedProject,
                    hint: Text('Filtrer par projet'),
                    isExpanded: true,
                    items: snapshot.data!.map((projet) {
                      return DropdownMenuItem<String>(
                        value: projet.nom, // Use 'nom' as the project name
                        child: Text(projet.nom),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedProject = newValue;
                        _filterEmployees(newValue); // Apply the filter
                      });
                    },
                  );
                } else {
                  return Text('Aucun projet trouvé');
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Employee>>(
              future: _employees,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: _filteredEmployees.length,
                    itemBuilder: (context, index) {
                      final employee = _filteredEmployees[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${employee.prenom} ${employee.nom}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text('Poste: ${employee.poste}'),
                              Text('Email: ${employee.email}'),
                              Text('Téléphone: ${employee.telephone}'),
                              Text('Salaire: ${employee.salaire} EUR'),
                              Text('Date d\'embauche: ${employee.dateEmbauche}'),
                              Text('Département: ${employee.departement.nom}'),
                              Text('Projet: ${employee.projet.nom}'),
                              SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      if (employee.id != null) { // Check if the id is not null
                                        _deleteEmployee(employee.id!); // Use the non-nullable id
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('Aucun employé trouvé.'));
                }
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.home, size: 60, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Welcome to InnovaTech Solutions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.blueAccent),
              title: Text('Accueil'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            // Département
            ListTile(
              leading: Icon(Icons.business, color: Colors.blueAccent),
              title: Text('Département'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DepartmentScreen()),
                );
              },
            ),
            // Projets
            ListTile(
              leading: Icon(Icons.assignment, color: Colors.blueAccent),
              title: Text('Projets'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProjetsListScreen()),
                );
              },
            ),
            // Employés
            ListTile(
              leading: Icon(Icons.person, color: Colors.blueAccent),
              title: Text('Employee'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => EmployeeListPage()),
                );
                // Ajouter ici la logique pour accéder à la page des employés
              },
            ),
            // Statistiques
            ListTile(
              leading: Icon(Icons.bar_chart, color: Colors.blueAccent),
              title: Text('Statistiques'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => StatistiquesScreen()),
                );
              },
            ),
            // Déconnexion
            ListTile(
              leading: Icon(Icons.logout, color: Colors.blueAccent),
              title: Text('Se déconnecter'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
