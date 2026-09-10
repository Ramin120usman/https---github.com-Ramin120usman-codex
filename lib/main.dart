import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/cart_provider.dart';
import 'package:flutter_application_1/providers/home_provider.dart';
import 'package:flutter_application_1/providers/order_summary_provider.dart';
import 'package:flutter_application_1/providers/product_details_provider.dart';
import 'package:flutter_application_1/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
         create: (_) => HomeProvider(),
),
        ChangeNotifierProvider(
  create: (_) => ProductDetailsProvider(),
),
ChangeNotifierProvider(
  create: (_) => CartProvider(),
),
ChangeNotifierProvider(
  create: (_) => WishlistProvider(),
),
ChangeNotifierProvider(
  create: (_) => OrderSummaryProvider(),
),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Outme Smart',
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}