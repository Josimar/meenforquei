import 'package:flutter/material.dart';
import 'package:meenforquei/models/product_model.dart';
import 'package:meenforquei/models/user_model.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/viewmodel/product_view_model.dart';
import 'package:provider/provider.dart';

class DetailProductView extends StatefulWidget {
  final ProductModel product;
  final UserModel currentUser;

  DetailProductView({@required this.product, this.currentUser});

  @override
  _DetailProductViewState createState() => _DetailProductViewState();
}

class _DetailProductViewState extends State<DetailProductView> {
  ProductModel productModel = new ProductModel();

  @override
  void initState() {
    super.initState();
    productModel = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(MEString.productDetail),
        actions: <Widget>[

          IconButton(
            iconSize: 25,
            icon: Icon(Icons.delete_forever),
            onPressed:() async {
              await productProvider.removeProduct(productModel.id);
              Navigator.pop(context);
            },
          ),
          IconButton(
            iconSize: 25,
            icon: Icon(Icons.edit),
            onPressed: () async {
              ProductModel pModel = await productProvider.editProduct(produto: productModel);
              setState(() {
                productModel = pModel;
                productModel.id = widget.product.id;
              });
            },
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: widget.product.id,
            child: Image.network(
              productModel.imageUrl,
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            productModel.title,
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 22,
                fontStyle: FontStyle.italic),
          ),
          Text(
            productModel.description,
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 22,
                fontStyle: FontStyle.italic),
          ),
          Text(
            '${productModel.price} \$',
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 22,
                fontStyle: FontStyle.italic,
                color: Colors.orangeAccent),
          ),
          SizedBox(height: 10)
        ],
      ),
    );
  }
}
