import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order.dart';
import 'package:shop/models/order_list.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meus pedidos',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: FutureBuilder(
        future: Provider.of<OrderList>(context, listen: false).loadingOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error == null) {
            return Center(child: Text("Ocorreu um erro!"));
          } else {
            return Consumer<OrderList>(
              builder: (ctx, orders, child) => ListView.builder(
                itemCount: orders.itemsCount,
                itemBuilder: (ctx, i) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          10), // Borda arredondada opcional
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Cor da sombra
                          spreadRadius:
                              2, // Quantidade que a sombra vai se espalhar
                          blurRadius: 10, // Suavidade da sombra
                          offset: Offset(0, 5), // Posição da sombra (x, y)
                        ),
                      ],
                    ),
                    child: OrderWidget(order: orders.items[i])),
              ),
            );
          }
        },
      ),
      backgroundColor: Colors.white,
      drawer: AppDrawer(),
    );
  }
}
