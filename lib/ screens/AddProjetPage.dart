import 'package:flutter/material.dart';
import '../ services/ProjetService.dart';

import '../models/department.dart';  // Assurez-vous d'importer le modèle Department
import '../models/Projet.dart';
import 'ProjetsListScreen.dart';

class AddProjetPage extends StatefulWidget {
  @override
  _AddProjetPageState createState() => _AddProjetPageState();
}

class _AddProjetPageState extends State<AddProjetPage> {
  final _formKey = GlobalKey<FormState>();
  String nom = '';
  String description = '';
  double budget = 0.0;
  String dateDebut = '';
  String dateFin = '';
  int departementId = 1; // ID du département par défaut (vous pouvez le modifier selon votre logique)

  late Future<List<Department>> departments; // Liste des départements

  void submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Créez l'objet Projet à partir des données saisies
      Projet projet = Projet(
        nom: nom,
        description: description,
        budget: budget,
        dateDebut: dateDebut,
        dateFin: dateFin,
        departement: Department.idOnly(id: departementId),
        id: '',
      );

      // Envoyer la requête de création de projet
      try {
        ProjetService projetService = ProjetService(); // Instancier le service
        Projet createdProjet = await projetService.createProjet(
            projet); // Appeler la méthode du service
        // Affichez un message de succès ou redirigez l'utilisateur
        print("Projet créé avec succès : $createdProjet");

        // Redirection vers une autre page (par exemple la liste des projets ou une page de confirmation)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProjetsListScreen(), // Remplacez par la page vers laquelle vous souhaitez rediriger
          ),
        );
      } catch (e) {
        // Affichez un message d'erreur si la création échoue
        print('Erreur lors de la création du projet: $e');
      }
    }
  }


  @override
  void initState() {
    super.initState();
    departments = ProjetService()
        .getDepartements(); // Récupérer la liste des départements
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un Projet"),
        backgroundColor: Colors.blue
            , // Utilisation d'une couleur attrayante pour l'AppBar
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<Department>>(
          future: departments, // Future des départements
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Aucun département trouvé'));
            }

            List<Department> departmentList = snapshot.data!;

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ajouter un projet',
                      style: TextStyle(fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    SizedBox(height: 20),
                    // Champs de formulaire avec styles améliorés
                    _buildTextFormField('Nom du projet', (value) {
                      setState(() {
                        nom = value;
                      });
                    }),
                    _buildTextFormField('Description du projet', (value) {
                      setState(() {
                        description = value;
                      });
                    }),
                    _buildTextFormField('Budget', (value) {
                      setState(() {
                        budget = double.tryParse(value) ?? 0.0;
                      });
                    }, keyboardType: TextInputType.number),
                    _buildTextFormField('Date de début', (value) {
                      setState(() {
                        dateDebut = value;
                      });
                    }),
                    _buildTextFormField('Date de fin', (value) {
                      setState(() {
                        dateFin = value;
                      });
                    }),
                    SizedBox(height: 20),

                    // Dropdown pour sélectionner le département
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: 'Sélectionner un département',
                        labelStyle: TextStyle(color: Colors.blue),
                        border: OutlineInputBorder(borderRadius: BorderRadius
                            .circular(8)),
                      ),
                      value: departementId,
                      onChanged: (int? newValue) {
                        setState(() {
                          departementId = newValue!;
                        });
                      },
                      items: departmentList.map((Department department) {
                        return DropdownMenuItem<int>(
                          value: department.id,
                          child: Text('Département ID: ${department.id}'),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Veuillez sélectionner un département';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20),

                    // Bouton de soumission avec un design amélioré
                    ElevatedButton(
                      onPressed: () => submit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Couleur de fond du bouton
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 30.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Soumettre',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight
                            .bold, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, Function(String) onChanged,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blue),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label est requis';
          }
          return null;
        },
      ),
    );
  }
}
