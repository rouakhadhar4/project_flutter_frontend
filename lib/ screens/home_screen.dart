import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/%20screens/statistiques_screen.dart';

import '../ services/PreferencesService.dart';

import 'DepartmentScreen.dart';
import 'ProjetsListScreen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            // Employee
            ListTile(
              leading: Icon(Icons.person, color: Colors.blueAccent),
              title: Text('Employee'),
              onTap: () {
                // Ajouter ici la logique pour accéder à la page des employés
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment, color: Colors.blueAccent),
              title: Text('Statistiques'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => StatistiquesScreen()),
                );
              },
            ),
            // Se déconnecter
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
            colors: [Colors.white, Colors.white], // Dégradé de fond
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section "Welcome"
                _buildSection(
                  icon: Icons.business_center,
                  title: 'Welcome to Our Enterprise',
                  description:
                  'We strive to deliver innovative solutions and exceptional services to meet your needs.',
                  color: Colors.blueAccent,
                ),
                SizedBox(height: 20),
                // Section "Our Missions"
                _buildSection(
                  icon: Icons.flag,
                  title: 'Our Missions',
                  description:
                  'Our mission is to foster growth and innovation, ensuring quality and sustainability in everything we do.',
                  color: Colors.green,
                ),
                // Section "Web Development"
                _buildSection(
                  icon: Icons.web,
                  title: 'Web Development',
                  description:
                  'We specialize in creating dynamic and responsive web applications tailored to your needs.',
                  color: Colors.blue,
                ),
                SizedBox(height: 20),
                // Section "Embedded Systems"
                _buildSection(
                  icon: Icons.memory,
                  title: 'Embedded Systems',
                  description:
                  'We provide efficient and reliable embedded systems for a wide range of industries.',
                  color: Colors.orange,
                ),
                SizedBox(height: 20),
                // Section "Extra"
                _buildSection(
                  icon: Icons.star,
                  title: 'Extra',
                  description:
                  'We offer additional services to support your business growth and success.',
                  color: Colors.purple,
                ),
                SizedBox(height: 20),
                // Section "Contact Us"
                _buildSection(
                  icon: Icons.contact_phone,
                  title: 'Contact Us',
                  description:
                  'Reach out to us at contact@innova-tech.com or call us at +1 123 456 789.',
                  color: Colors.orange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Méthode pour construire une section avec un design attrayant
  Widget _buildSection({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(12),
              child: Icon(icon, size: 30, color: color),
            ),
            SizedBox(width: 16),
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
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
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
