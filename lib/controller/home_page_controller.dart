import 'package:evercook/main.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  Stream<List<Map<String, dynamic>>>? _recipesStream;

  void getRecipes() {
    // _recipesStream = supabase.from('recipes').stream(primaryKey: ['id']);
    _recipesStream!.listen((recipes) {
      for (final recipe in recipes) {
        print(recipe);
      }
    });
  }
}
