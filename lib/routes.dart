import 'package:get/get.dart';
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

class AppPages {
  static final pages = [
    GetPage(name: Routes.SPLASH, page: () => SplashPage()),
    GetPage(name: Routes.LOGIN, page: () => LoginPage()),
    GetPage(name: Routes.REGISTER, page: () => RegisterPage()),
    GetPage(name: Routes.RESET, page: () => ResetPasswordPage()),
    GetPage(name: Routes.DASHBOARD, page: () => DashboardPage()),
    GetPage(name: Routes.DONATE, page: () => DonatePage()),
    GetPage(name: Routes.REQUEST, page: () => RequestAidPage()),
    GetPage(name: Routes.CAMPAIGNS, page: () => CampaignsPage()),
    GetPage(name: Routes.CAMPAIGN_DETAIL, page: () => CampaignDetailPage()),
    GetPage(name: Routes.PROFILE, page: () => ProfilePage()),
    GetPage(name: Routes.ADMIN, page: () => AdminPage()),
    GetPage(name: Routes.STATISTICS, page: () => StatisticsPage()),
    GetPage(name: Routes.HELP, page: () => HelpPage()),
    GetPage(name: Routes.LANGUAGE, page: () => LanguagePage()),
  ];
}
