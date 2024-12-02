import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/%20screens/statistiques_screen.dart';

import '../ services/PreferencesService.dart';


import 'DepartmentScreen.dart';
import 'ProjetsListScreen.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class ProjetScreen extends StatefulWidget {  // Assurez-vous que c'est 'ProjetScreen' et non 'ProjetScree'
  @override
  _ProjetScreenState createState() => _ProjetScreenState();
}

class _ProjetScreenState extends State<ProjetScreen> {
  final PreferencesService _preferencesService = PreferencesService();
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  // Charger l'email de l'utilisateur
  void _loadUserEmail() async {
    String email = await _preferencesService.getEmail();
    setState(() {
      _userEmail = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page d\'accueil'),
        backgroundColor: Colors.blueAccent,
      ),
      // Ajout de la barre latérale (Drawer)
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
                    ' Welcome to InnovaTech Solutions',
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.white], // Dégradé de fond
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bienvenue sur la page d\'accueil!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Se déconnecter',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
