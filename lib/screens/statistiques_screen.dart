import 'package:flutter/material.dart';
import '../ services/EmployeeService.dart';
import '../ services/ProjetService.dart';
import '../ services/auth_service.dart';
import '../ services/department_service.dart';

import 'DepartmentScreen.dart';

import 'EmployeeListPage .dart';
import 'ProjetsListScreen.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class StatistiquesScreen extends StatefulWidget {
  @override
  _StatistiquesScreenState createState() => _StatistiquesScreenState();
}

class _StatistiquesScreenState extends State<StatistiquesScreen> {
  int _userCount = 0;
  int _departmentCount = 0;
  int _projectCount = 0;
  int _employeeCount = 0; // Ajout du comptage des employés
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStatistics();
  }

  // Méthode pour récupérer les statistiques
  Future<void> _fetchStatistics() async {
    try {
      final userCount = await AuthService().getUserCount();
      final departmentCount = await DepartmentService().fetchDepartments();
      final projectCount = await ProjetService().getAllProjets();
      final employeeCount = await EmployeeService().getAllEmployees(); // Récupère le nombre d'employés

      setState(() {
        _userCount = userCount;
        _departmentCount = departmentCount.length;
        _projectCount = projectCount.length;
        _employeeCount = employeeCount.length; // Met à jour le nombre d'employés
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des statistiques : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Statistiques',
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
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
            // Accueil
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatCard(
              title: 'Utilisateurs',
              count: _userCount,
              icon: Icons.person,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            _buildStatCard(
              title: 'Départements',
              count: _departmentCount,
              icon: Icons.business,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            _buildStatCard(
              title: 'Projets',
              count: _projectCount,
              icon: Icons.work,
              color: Colors.orange,
            ),
            SizedBox(height: 20),
            _buildStatCard( // Carte pour les employés
              title: 'Employés',
              count: _employeeCount,
              icon: Icons.person_add,
              color: Colors.purple, // Choisir une couleur
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour afficher une carte de statistique avec un design amélioré
  Widget _buildStatCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(12),
              child: Icon(icon, size: 30, color: color),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
