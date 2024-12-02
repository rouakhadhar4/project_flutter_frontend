class Department {
  final int? id;
  final String nom;
  final String description;
  final String dateCreation;

  Department({
    this.id,
    required this.nom,
    required this.description,
    required this.dateCreation,
  });

  // Constructor for initializing only the id
  Department.idOnly({required this.id})
      : nom = '',
        description = '',
        dateCreation = '';  // Default values for nom, description, and dateCreation

  // Method to convert Department object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'dateCreation': dateCreation,
    };
  }

  // Create a Department object from JSON data
  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],  // Ensure 'id' is nullable or exists in JSON
      nom: json['nom'] ?? '',  // Default to an empty string if 'nom' is missing
      description: json['description'] ?? '',  // Default to empty string if 'description' is missing
      dateCreation: json['dateCreation'] ?? '',  // Default to empty string if 'dateCreation' is missing
    );
  }
}
