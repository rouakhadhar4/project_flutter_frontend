// lib/services/auth_service.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../ screens/home_screen.dart';

class AuthService {
  final String apiUrl = 'http://10.0.2.2:8045/api/auth';  // URL de l'API Spring
// Méthode pour envoyer une requête POST pour se connecter
  Future<void> login(BuildContext context, String email, String password) async {
    try {
      String apiUrl = 'http://10.0.2.2:8045/api/auth/login';  // URL avec /login

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      Map<String, dynamic> body = {
        'email': email,
        'password': password,
      };

      // Envoi de la requête POST
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        // Si la connexion est réussie, naviguer vers la page d'accueil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // Si la réponse n'est pas 200, lancer une exception
        throw Exception('Email or password incorrect please try again" }');
      }
    } catch (e) {
      // Attraper et gérer toute erreur de connexion
      throw Exception('Email or password incorrect please try again"');
    }
  }
  Future<int> getUserCount() async {
    // Implementez la logique pour obtenir le nombre d'utilisateurs
    // Ceci est un exemple fictif. Il faut ajuster selon votre backend.
    final response = await http.get(Uri.parse('http://10.0.2.2:8045/api/auth/users'));
    if (response.statusCode == 200) {
      final List<dynamic> users = json.decode(response.body);
      return users.length;
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Méthode pour envoyer une requête POST pour s'enregistrer
  Future<Map<String, dynamic>> register(String firstName, String lastName, String email, String password) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      Map<String, dynamic> body = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      };

      final response = await http.post(
        Uri.parse('$apiUrl/register'),  // URL pour l'enregistrement
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {  // Supposons que 201 est renvoyé pour une création réussie
        return json.decode(response.body);
      } else {
        throw Exception('Échec de l\'enregistrement: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur d\'enregistrement: $e');
    }
  }


}
