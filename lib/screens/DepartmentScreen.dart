
import 'package:flutter/material.dart';
import 'package:project_flutter/%20screens/statistiques_screen.dart';
import '../ services/department_service.dart';

import '../models/department.dart';
import 'EmployeeListPage .dart';
import 'ProjetScreen..dart';
import 'ProjetsListScreen.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class DepartmentScreen extends StatefulWidget {
  @override
  _DepartmentScreenState createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final DepartmentService departmentService = DepartmentService();
  List<Department> _departments = [];
  List<Department> _filteredDepartments = []; // Liste filtrée des départements

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDepartments(); // Charger les départements au démarrage
  }

  Future<void> _loadDepartments() async {
    setState(() {
      _isLoading = true; // Afficher le loader
    });
    try {
      final departments = await departmentService.fetchDepartments();
      setState(() {
        _departments = departments;
        _filteredDepartments = departments; // Initialiser la liste filtrée
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des départements : $error')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Masquer le loader
      });
    }
  }
  Future<void> _addDepartment() async {
    try {
      final newDepartment = Department(
        nom: _nomController.text,
        description: _descriptionController.text,
        dateCreation: _dateController.text,
      );

      await departmentService.addDepartment(newDepartment);
      _loadDepartments();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Département ajouté avec succès')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  Future<void> _updateDepartment(Department department) async {
    if (department.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur : L'ID est nul.")));
      return;
    }

    final updatedDepartment = Department(
      id: department.id,
      nom: _nomController.text.isNotEmpty ? _nomController.text : department.nom,
      description: _descriptionController.text.isNotEmpty ? _descriptionController.text : department.description,
      dateCreation: _dateController.text.isNotEmpty ? _dateController.text : department.dateCreation,
    );

    await departmentService.updateDepartment(
      department.id!,
      updatedDepartment,
          () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Département mis à jour avec succès')));
        _loadDepartments(); // Recharger les départements après la mise à jour
      },
          (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      },
    );
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }


  Future<void> _deleteDepartment(int? id) async {
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur : L'ID est nul.")));
      return;
    }

    await departmentService.deleteDepartment(
      id,
          () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Département supprimé avec succès')));
        _loadDepartments(); // Recharger les départements après la suppression
      },
          (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      },
    );
  }


  // Fonction pour filtrer les départements par nom
  void _filterDepartments(String query) {
    final filtered = _departments.where((department) {
      return department.nom.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredDepartments = filtered;
    });
  }
  // Dialog de confirmation avant de supprimer un département
  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Supprimer le département'),
          content: Text('Êtes-vous sûr de vouloir supprimer ce département ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteDepartment(id);
              },
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
  void _showAddDepartmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Ajouter un département',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blueAccent,
            ),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Champ pour le nom du département
              TextField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: 'Nom du département',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.business, color: Colors.blueAccent),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.description, color: Colors.blueAccent),
                ),
              ),


              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date de création',
                      hintText: 'Sélectionner une date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.calendar_today, color: Colors.blueAccent),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blueGrey,
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _addDepartment();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateDepartmentDialog(Department department) {
    _nomController.text = department.nom;
    _descriptionController.text = department.description;
    _dateController.text = department.dateCreation;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Modifier le département',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Champ pour le nom du département
                TextField(
                  controller: _nomController,
                  decoration: InputDecoration(
                    labelText: 'Nom du département',
                    prefixIcon: Icon(Icons.business, color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  ),
                ),
                SizedBox(height: 15),
                // Champ pour la description
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description, color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  ),
                ),
                SizedBox(height: 15),
                // Champ pour la date de création
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Date de création',
                        hintText: 'Sélectionner une date',
                        prefixIcon: Icon(Icons.calendar_today, color: Colors.blueAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Annuler',
                style: TextStyle(
                  color: Colors.blueAccent, // Couleur du texte en bleu
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent.withOpacity(0.1), // Couleur de fond légèrement bleue
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Padding pour plus d'espace
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Coins arrondis
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _updateDepartment(department);
              },
              child: Text(
                'Mettre à jour',
                style: TextStyle(
                  color: Colors.blueAccent, // Couleur du texte en bleu
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent.withOpacity(0.1), // Couleur de fond légèrement bleue
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Padding pour plus d'espace
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Coins arrondis
                ),
              ),
            ),

          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Départements',
          style: TextStyle(
            fontSize: 24, // Augmenter la taille du texte
            fontWeight: FontWeight.bold, // Mettre le texte en gras
            color: Colors.white, // Couleur du texte
            letterSpacing: 1.2, // Espacement entre les lettres pour plus d'élégance
            shadows: [
              Shadow(
                offset: Offset(2.0, 2.0), // Décalage de l'ombre
                blurRadius: 5.0, // Légère flou autour de l'ombre
                color: Colors.black.withOpacity(0.5), // Couleur et opacité de l'ombre
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterDepartments, // Filtrer en temps réel
              decoration: InputDecoration(
                labelText: 'Rechercher par nom',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          _filteredDepartments.isEmpty
              ? Center(child: Text('Aucun département trouvé'))
              : Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Permet le défilement horizontal
                child: DataTable(
                  columnSpacing: 20,
                  dataRowHeight: 60, // Ajuster la hauteur des lignes
                  headingRowHeight: 60, // Ajuster la hauteur de l'en-tête
                  columns: [
                    DataColumn(
                      label: Text('Nom', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    DataColumn(
                      label: Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    DataColumn(
                      label: Text('Date de création', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    DataColumn(
                      label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                  rows: _filteredDepartments.map((department) {
                    return DataRow(
                      cells: [
                        DataCell(Text(department.nom)),
                        DataCell(Text(department.description)),
                        DataCell(Text(department.dateCreation)),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent, // Couleur d'arrière-plan
                                    shape: BoxShape.circle, // Forme circulaire
                                  ),
                                  padding: EdgeInsets.all(8), // Espacement autour de l'icône
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white, // Couleur de l'icône
                                    size: 24, // Taille de l'icône
                                  ),
                                ),
                                onPressed: () => _showUpdateDepartmentDialog(department),
                              ),
                              IconButton(
                                icon: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent, // Couleur d'arrière-plan
                                    shape: BoxShape.circle, // Forme circulaire
                                  ),
                                  padding: EdgeInsets.all(8), // Espacement autour de l'icône
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white, // Couleur de l'icône
                                    size: 24, // Taille de l'icône
                                  ),
                                ),
                                onPressed: () => _showDeleteConfirmationDialog(department.id!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDepartmentDialog,
        child: Icon(Icons.add, size: 30),
        backgroundColor: Colors.blueAccent,
        tooltip: 'Ajouter un département',
      ),
    );
  }
}
