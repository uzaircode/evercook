import 'package:evercook/pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  final supabase = Supabase.instance.client;

  final RxString userId = ''.obs;

  @override
  void onInit() {
    // Listen to authentication state changes and update userId accordingly
    supabase.auth.onAuthStateChange.listen((data) {
      userId.value = data.session?.user.id ?? '';
    });
    super.onInit();
  }

  void signOut() async {
    await supabase.auth.signOut();
    Get.offAll(LoginPage());
  }
}
