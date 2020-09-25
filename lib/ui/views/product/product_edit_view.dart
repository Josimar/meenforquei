import 'package:flutter/material.dart';
import 'package:meenforquei/models/product_model.dart';
import 'package:meenforquei/models/user_model.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/viewmodel/product_view_model.dart';
import 'package:provider/provider.dart';

class EditProductView extends StatefulWidget {
  final ProductModel product;
  final UserModel currentUser;

  EditProductView({@required this.product, this.currentUser});

  @override
  _EditProductViewState createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  final _formKey = GlobalKey<FormState>();

  String productType ;
  String title ;
  String price ;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductViewModel>(context);
    productType =  widget.product.img[0].toUpperCase() + widget.product.img.substring(1);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(MEString.productUpdate),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                  initialValue: widget.product.title,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: MEString.productTitle,
                    fillColor: Colors.grey[300],
                    filled: true,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return MEString.productTitleValidate;
                    }
                    return null;
                  },
                  onSaved: (value) => title = value
              ),
              SizedBox(height: 16,),
              TextFormField(
                  initialValue: widget.product.price.toString(),
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: MEString.productPrice,
                    fillColor: Colors.grey[300],
                    filled: true,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return MEString.productPriceValidate;
                    }
                    return null;
                  },
                  onSaved: (value) => price = value
              ),
              DropdownButton<String>(
                value: productType,
                onChanged: (String newValue) {
                  setState(() {
                    productType = newValue;
                  });
                },
                items: <String>['Bag', 'Computer', 'Dress', 'Phone','Shoes']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              RaisedButton(
                splashColor: Colors.red,
                onPressed: () async{
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    ProductModel model  = await productProvider.updateProduct(
                        widget.product.id,
                        ProductModel(
                            id: widget.product.id,
                            title: title,
                            description: title,
                            price: price,
                            img: productType.toLowerCase(),
                            isFavorite: widget.product.isFavorite
                        )
                    );
                    Navigator.pop(context, model);
                  }
                },
                child: Text(MEString.productModify, style: TextStyle(color: Colors.white)),
                color: Colors.blue,
              )

            ],
          ),
        ),
      ),
    );
  }
}
