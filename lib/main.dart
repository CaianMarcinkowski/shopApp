import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order_list.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/pages/auth_or_home_page.dart';
import 'package:shop/pages/cart_page.dart';
import 'package:shop/pages/orders_page.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/product_form_page.dart';
import 'package:shop/pages/product_page.dart';
import 'package:shop/utils/app_routes.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop/utils/custom_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Inicializa o binding do Flutter
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList(),
          update: (ctx, auth, previous) {
            return ProductList(
                auth.token ?? '', previous?.items ?? [], auth.userId ?? '');
          },
        ),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: (ctx, auth, previous) {
            return OrderList(
                auth.token ?? '', previous?.items ?? [], auth.userId ?? '');
          },
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.purple, // Cor primária
            secondary: Colors.deepOrange, // Cor de acentuação
          ),
          textTheme: TextTheme(
            titleLarge: TextStyle(
                color: const Color.fromARGB(
                    255, 255, 255, 255)), // Customizando `titleLarge`
          ),
          fontFamily: 'Lato',
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CustomPageTransitionsBuilder(),
            TargetPlatform.iOS: CustomPageTransitionsBuilder(),
          }),
        ),
        //home: ProductsOverviewPage(),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailPage(),
          AppRoutes.CART: (ctx) => CartPage(),
          AppRoutes.ORDERS: (ctx) => OrdersPage(),
          AppRoutes.PRODUCTS: (ctx) => ProductPage(),
          AppRoutes.PRODUCTS_FORM: (ctx) => ProductFormPage(),
          AppRoutes.AUTH_OR_HOME: (ctx) => AuthOrHomePage(),
        },
      ),
    );
  }
}
