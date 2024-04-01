import 'package:evercook/main.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  void getRecipes() {
    final recipe = supabase.from('recipes').stream(primaryKey: ['id']);
  }
}
