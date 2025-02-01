import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'auth/login_view.dart';
import 'auth/signup_view.dart';
import 'auth/auth_service.dart';
import 'dashboard/dashboard_view.dart';
import 'product/product_list_view.dart';
import 'product/add_product_view.dart';
import 'orders/orders_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.grey[100],
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
          ),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          home: Consumer<AuthService>(
            builder: (context, authService, _) {
              return StreamBuilder(
                stream: authService.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  
                  if (snapshot.hasData) {
                    return const DashboardView();
                  }
                  
                  return const LoginView();
                },
              );
            },
          ),

          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case ProductListView.routeName:
                    return const ProductListView();
                  case AddProductView.routeName:
                    return const AddProductView();
                  case SignupView.routeName:
                    return const SignupView();
                  case LoginView.routeName:
                    return const LoginView();
                  case DashboardView.routeName:
                    return const DashboardView();
                  case OrdersView.routeName:
                    return const OrdersView();
                  default:
                    return const DashboardView();
                }
              },
            );
          },
        );
      },
    );
  }
}