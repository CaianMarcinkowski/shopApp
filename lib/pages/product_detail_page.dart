import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';

class ProductDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text(
      //     product.name,
      //     style: const TextStyle(
      //       color: Colors.white,
      //     ),
      //   ),
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.name),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: product.id,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                    begin: Alignment(0, 0.8),
                    end: Alignment(0, 0),
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0.6),
                      Color.fromRGBO(0, 0, 0, 0),
                    ],
                  )))
                ],
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(height: 10),
            Text(
              textAlign: TextAlign.center,
              'R\$ ${product.price}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
              ),
            ),
          ]))
        ],
      ),
    );
  }
}
