import 'package:flutter/material.dart';
import 'package:project_flutter/%20screens/statistiques_screen.dart';
import '../ services/ProjetService.dart';

import '../ services/department_service.dart';
import '../models/Projet.dart';
import '../models/department.dart';
import 'AddProjetPage.dart';
import 'DepartmentScreen.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class ProjetsListScreen extends StatefulWidget {
  @override
  _ProjetsListScreenState createState() => _ProjetsListScreenState();
}

class _ProjetsListScreenState extends State<ProjetsListScreen> {
  late Future<List<Department>> departements;
  List<Projet> filteredProjets = [];
  int? selectedDepartementId;

  @override
  void initState() {
    super.initState();
    departements = DepartmentService().fetchDepartments();
    loadAllProjets();
  }

  void loadAllProjets() async {
    List<Projet> allProjets = await ProjetService().getAllProjets();
    setState(() {
      filteredProjets = allProjets;
    });
  }

  void filterProjetsByDepartement(int? departementId) async {
    List<Projet> allProjets = await ProjetService().getAllProjets();
    setState(() {
      if (departementId == null) {
        filteredProjets = allProjets;
      } else {
        filteredProjets = allProjets
            .where((projet) => projet.departement?.id == departementId)
            .toList();

        if (filteredProjets.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Aucun projet trouvé pour ce département'),
          ));
        }
      }
    });
  }

  String formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return date.toLocal().toString();
    } catch (e) {
      return 'N/A';
    }
  }

  Future<void> deleteProjet(int id) async {
    try {
      await ProjetService().deleteProjet(id);
      filterProjetsByDepartement(selectedDepartementId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur de suppression: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Départements',
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
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
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
      body: Column(
        children: [
          FutureBuilder<List<Department>>(
            future: departements,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Erreur de chargement des départements');
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('Aucun département disponible');
              }

              List<Department> departementList = snapshot.data!;
              return DropdownButton<int>(
                value: selectedDepartementId,
                hint: Text('Sélectionnez un département'),
                items: departementList
                    .map((departement) => departement.id)
                    .toSet()
                    .map((departementId) {
                  return DropdownMenuItem<int>(
                    value: departementId,
                    child: Text(departementList
                        .firstWhere((e) => e.id == departementId)
                        .nom),
                  );
                }).toList(),
                onChanged: (int? value) {
                  setState(() {
                    selectedDepartementId = value;
                  });
                  filterProjetsByDepartement(value);
                },
              );
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProjets.length,
              itemBuilder: (context, index) {
                Projet projet = filteredProjets[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nom: ${projet.nom?.toString() ?? 'N/A'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Description: ${projet.description?.toString() ?? 'N/A'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Budget: ${projet.budget?.toString() ?? 'N/A'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Date Début: ${formatDate(projet.dateDebut ?? '')}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Date Fin: ${formatDate(projet.dateFin ?? '')}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Département ID: ${projet.departement?.id ?? 'N/A'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      int? id = int.tryParse(projet.id ?? '');
                      if (id != null) {
                        deleteProjet(id);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('ID invalide'),
                        ));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Couleur de fond rouge
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Espacement du bouton
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Bords arrondis
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Minimise la taille du Row
                      children: [
                        Icon(
                          Icons.delete, // Icône de suppression
                          color: Colors.white, // Couleur de l'icône
                        ),
                        SizedBox(width: 8), // Espacement entre l'icône et le texte
                        Text(
                          'Supprimer', // Texte du bouton
                          style: TextStyle(color: Colors.white), // Texte en blanc
                        ),
                      ],
                    ),
                  ),
]
                ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProjetPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
