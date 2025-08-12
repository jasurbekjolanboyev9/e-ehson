// lib/routes.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_ehson/pages/splash_page.dart';
import 'package:e_ehson/pages/auth/login_page.dart';
import 'package:e_ehson/pages/auth/register_page.dart';
import 'package:e_ehson/pages/auth/reset_password_page.dart';
import 'package:e_ehson/pages/dashboard_page.dart';
import 'package:e_ehson/pages/donate/donate_page.dart';
import 'package:e_ehson/pages/campaigns/campaigns_page.dart';
import 'package:e_ehson/pages/campaigns/campaign_detail_page.dart';
import 'package:e_ehson/pages/request/request_page.dart';
import 'package:e_ehson/pages/profile/profile_page.dart';
import 'package:e_ehson/pages/admin/admin_page.dart';
import 'package:e_ehson/pages/statistics/statistics_page.dart';
import 'package:e_ehson/pages/help/help_page.dart';
import 'package:e_ehson/pages/settings/language_page.dart';
import 'package:e_ehson/modules/chat/views/chat_screen.dart';
import 'package:e_ehson/controllers/auth_controller.dart';
import 'package:e_ehson/controllers/donation_controller.dart';
import 'package:e_ehson/controllers/campaign_controller.dart';
import 'package:e_ehson/controllers/profile_controller.dart';
import 'package:e_ehson/controllers/admin_controller.dart';

// ROUTE NOMLARI
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
  static const CHAT = '/chat';
  static const DONATION_HISTORY = '/donation-history';
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
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.RESET,
      page: () => ResetPasswordPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardPage(),
    ),
    GetPage(
      name: Routes.DONATE,
      page: () => DonatePage(),
      binding: DonationBinding(),
    ),
    GetPage(
      name: Routes.REQUEST,
      page: () => RequestAidPage(),
      binding: DonationBinding(),
    ),
    GetPage(
      name: Routes.CAMPAIGNS,
      page: () => CampaignsPage(),
      binding: CampaignBinding(),
    ),
    GetPage(
      name: Routes.CAMPAIGN_DETAIL,
      page: () => CampaignDetailPage(),
      binding: CampaignBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.ADMIN,
      page: () => AdminPage(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: Routes.STATISTICS,
      page: () => StatisticsPage(),
    ),
    GetPage(
      name: Routes.HELP,
      page: () => HelpPage(),
    ),
    GetPage(
      name: Routes.LANGUAGE,
      page: () => LanguagePage(),
    ),
    GetPage(
      name: Routes.CHAT,
      page: () => ChatScreen(),
    ),
    GetPage(
      name: Routes.DONATION_HISTORY,
      page: () => const Center(child: Text('Donation History')),
    ),
  ];
}
