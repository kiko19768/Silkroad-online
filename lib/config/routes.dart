import 'package:flutter/material.dart';
import 'package:arabic_mmorpg/presentation/pages/splash/splash_page.dart';
import 'package:arabic_mmorpg/presentation/pages/auth/login_page.dart';
import 'package:arabic_mmorpg/presentation/pages/auth/register_page.dart';
import 'package:arabic_mmorpg/presentation/pages/home/home_page.dart';
import 'package:arabic_mmorpg/presentation/pages/game/game_page.dart';
import 'package:arabic_mmorpg/presentation/pages/character/character_creation_page.dart';
import 'package:arabic_mmorpg/presentation/pages/character/character_selection_page.dart';
import 'package:arabic_mmorpg/presentation/pages/settings/settings_page.dart';

class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String game = '/game';
  static const String characterCreation = '/character/creation';
  static const String characterSelection = '/character/selection';
  static const String settings = '/settings';
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case game:
        final Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => GamePage(
            characterId: args['characterId'],
            mapId: args['mapId'],
          ),
        );
      case characterCreation:
        return MaterialPageRoute(builder: (_) => const CharacterCreationPage());
      case characterSelection:
        return MaterialPageRoute(builder: (_) => const CharacterSelectionPage());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}