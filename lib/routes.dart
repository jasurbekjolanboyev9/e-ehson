import 'package:get/get.dart';

// Sahifalar
import 'pages/splash_page.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/auth/reset_password_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/donate/donate_page.dart';
import 'pages/campaigns/campaigns_page.dart';
import 'pages/campaigns/campaign_detail_page.dart';
import 'pages/request/request_page.dart';
import 'pages/profile/profile_page.dart';
import 'pages/admin/admin_page.dart';
import 'pages/statistics/statistics_page.dart';
import 'pages/help/help_page.dart';
import 'pages/settings/language_page.dart';

// Controllerlar
import 'controllers/auth_controller.dart';
import 'controllers/donation_controller.dart';
import 'controllers/campaign_controller.dart';
import 'controllers/profile_controller.dart';
import 'controllers/admin_controller.dart';

// ROUTE nomlari
class Routes {
  static const SPLASH = '/';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const RESET = '/reset';
  static const DASHBOARD = '/dashboard';
  static const DONATE = '/donate';
  static const REQUEST = '/request';
  static const CAMPAIGNS = '/campaigns';
  static const CAMPAIGN_DETAIL = '/campaign/:id';
  static const PROFILE = '/profile';
  static const ADMIN = '/admin';
  static const STATISTICS = '/statistics';
  static const HELP = '/help';
  static const LANGUAGE = '/language';
}

// BINDINGLAR
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}

class DonationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DonationController>(() => DonationController());
  }
}

class CampaignBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CampaignController>(() => CampaignController());
  }
}

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminController>(() => AdminController());
  }
}

// APP PAGES
class AppPages {
  static final pages = [
    GetPage(name: Routes.SPLASH, page: () => SplashPage()),
    GetPage(name: Routes.LOGIN, page: () => LoginPage(), binding: AuthBinding()),
    GetPage(name: Routes.REGISTER, page: () => RegisterPage(), binding: AuthBinding()),
    GetPage(name: Routes.RESET, page: () => ResetPasswordPage(), binding: AuthBinding()),
    GetPage(name: Routes.DASHBOARD, page: () => DashboardPage()),
    GetPage(name: Routes.DONATE, page: () => DonatePage(), binding: DonationBinding()),
    GetPage(name: Routes.REQUEST, page: () => RequestAidPage(), binding: DonationBinding()),
    GetPage(name: Routes.CAMPAIGNS, page: () => CampaignsPage(), binding: CampaignBinding()),
    GetPage(name: Routes.CAMPAIGN_DETAIL, page: () => CampaignDetailPage(), binding: CampaignBinding()),
    GetPage(name: Routes.PROFILE, page: () => ProfilePage(), binding: ProfileBinding()),
    GetPage(name: Routes.ADMIN, page: () => AdminPage(), binding: AdminBinding()),
    GetPage(name: Routes.STATISTICS, page: () => StatisticsPage()),
    GetPage(name: Routes.HELP, page: () => HelpPage()),
    GetPage(name: Routes.LANGUAGE, page: () => LanguagePage()),
  ];
}
