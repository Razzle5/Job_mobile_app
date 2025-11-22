import 'package:get/get.dart';
import 'package:job_app/features/authentications/controllers/hrd_login_controller.dart';
import 'package:job_app/features/authentications/controllers/hrd_signup_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HrdLoginController>(() => HrdLoginController(), fenix: true);
    Get.lazyPut<HrdSignupController>(() => HrdSignupController(), fenix: true);
  }
}
