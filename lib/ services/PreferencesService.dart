import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  // Sauvegarder l'email dans SharedPreferences
  Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_email', email);
  }

  // Récupérer l'email depuis SharedPreferences
  Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email') ?? '';  // Retourner une chaîne vide si l'email n'est pas trouvé
  }
}
