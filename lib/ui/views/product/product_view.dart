import 'package:flutter/material.dart';
import 'package:meenforquei/models/product_model.dart';
import 'package:meenforquei/ui/widgets/custom_drawer.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/viewmodel/product_view_model.dart';
import 'package:provider/provider.dart';
import 'package:meenforquei/utils/utilitarios.dart';

class ProductView extends StatelessWidget {
  final PageController pageController;
  ProductView(this.pageController, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('| => Product View'); // ToDo: print product

    final productProvider = Provider.of<ProductViewModel>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productProvider.newProduct();
        },
        child: Icon(Icons.add),
      ),
      drawer: CustomDrawer(pageController),
      appBar: AppBar(
        title: Text(MEString.product),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue){
              if (selectedValue == FilterOptions.Favorite){
                productProvider.showFavoriteOnly();
              }else{
                productProvider.showFavoriteAll();
              }
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(MEString.soFavoritos),
                value: FilterOptions.Favorite
              ),
              PopupMenuItem(
                  child: Text(MEString.todos),
                  value: FilterOptions.All
              )
            ],
          )
        ],
      ),
      body: new FutureBuilder<List<ProductModel>>(
        future: productProvider.fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? new GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: productProvider.products.length,
                itemBuilder: (ctx, index){
                  return ChangeNotifierProvider.value(
                    value: productProvider.products[index],
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GridTile(
                        child: GestureDetector(
                          onTap: (){
                            productProvider.editProduct(produto: productProvider.products[index]);
                          },
                          child: Image.network(
                            productProvider.products[index].imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        footer: GridTileBar(
                            backgroundColor: Colors.black87,
                            leading: IconButton(
                              icon: Icon(productProvider.products[index].isFavorite ? Icons.favorite : Icons.favorite_border),
                              onPressed: (){
                                productProvider.toggleFavorite(productProvider.products[index]);
                              },
                            ),
                            title: Text(productProvider.products[index].title, textAlign: TextAlign.center),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: (){
                                print('RemoveProduct');
                                print(productProvider.products[index].id);
                                productProvider.removeProduct(productProvider.products[index].id);
                              },
                            )
                        ),
                      ),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10
                ),
              )
              : new Center(child: new CircularProgressIndicator());
        },
      )
    );
  }
}

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductViewModel>(context);
    final productModel = productProvider.product;

    print('productModel');
    print(productModel);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: (){
            // onEditProduct();
          },
          child: Image.network(
            productModel.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(productModel.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: (){},
          ),
          title: Text(productModel.title, textAlign: TextAlign.center),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: (){},
          )
        ),
      ),
    );
  }
}


class ProductCard extends StatelessWidget {
  final ProductModel productDetails;
  final VoidCallback onEditProduct;

  ProductCard({@required this.productDetails, this.onEditProduct});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: GestureDetector(
        onTap: (){
          onEditProduct();
        },
        child: Card(
          elevation: 5,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: <Widget>[
                Hero(
                  tag: productDetails.id,
                  child: Image.network(
                    productDetails.imageUrl,
                    height: MediaQuery.of(context).size.height * 0.35,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        productDetails.title,
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            fontStyle: FontStyle.italic),
                      ),
                      Text(
                        '${productDetails.price} \$',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            fontStyle: FontStyle.italic,
                            color: Colors.orangeAccent),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
