import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:arabic_mmorpg/config/app_config.dart';
import 'package:arabic_mmorpg/config/routes.dart';
import 'package:arabic_mmorpg/config/theme.dart';
import 'package:arabic_mmorpg/core/utils/service_locator.dart';
import 'package:arabic_mmorpg/presentation/bloc/auth/auth_bloc.dart';
import 'package:arabic_mmorpg/presentation/pages/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Force landscape orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  // Initialize service locator
  await setupServiceLocator();
  
  // Run the app
  runApp(const ArabicMMORPGApp());
}

class ArabicMMORPGApp extends StatelessWidget {
  const ArabicMMORPGApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => sl<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        // Add other global BLoCs here
      ],
      child: MaterialApp(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        locale: const Locale('ar'),
        supportedLocales: const [
          Locale('ar'), // Arabic
          Locale('en'), // English
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        initialRoute: Routes.splash,
        onGenerateRoute: Routes.generateRoute,
        home: const SplashPage(),
      ),
    );
  }
}