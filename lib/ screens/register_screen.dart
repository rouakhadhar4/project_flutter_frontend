// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import '../ services/auth_service.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _message = '';

  void _register() async {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        _message = 'Veuillez remplir tous les champs';
      });
      return;
    }

    AuthService authService = AuthService();
    try {
      Map<String, dynamic> response = await authService.register(firstName, lastName, email, password);
      setState(() {
        _message = 'Enregistrement réussi! Vous pouvez maintenant vous connecter.';
      });

      // Attendre quelques secondes avant de rediriger vers la page de connexion
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
    } catch (e) {
      setState(() {
        _message = 'Erreur: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent, // Bleu similaire à la page de login
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.app_registration, size: 50, color: Colors.blueAccent), // Icône de registre
            SizedBox(height: 30),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person, color: Colors.blueAccent), // Icône de prénom
                labelText: 'Prénom',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline, color: Colors.blueAccent), // Icône de nom
                labelText: 'Nom',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email, color: Colors.blueAccent), // Icône d'email
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock, color: Colors.blueAccent), // Icône de mot de passe
                labelText: 'Mot de passe',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Bleu similaire à la page de login
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('S\'enregistrer', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 16),
            Text(_message, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text("vous avez dejà un compte ? Se connecter", style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        ),
      ),
    );
  }
}
