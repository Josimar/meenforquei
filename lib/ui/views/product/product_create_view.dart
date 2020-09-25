import 'package:flutter/material.dart';
import 'package:meenforquei/models/product_model.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/viewmodel/product_view_model.dart';
import 'package:provider/provider.dart';

class CreateProductView extends StatefulWidget {
  @override
  _CreateProductViewState createState() => _CreateProductViewState();
}

class _CreateProductViewState extends State<CreateProductView> {
  final _formKey = GlobalKey<FormState>();

  String productType = 'Bag';
  String title ;
  String price ;

  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductViewModel>(context) ;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
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
                    await productProvider.addProduct(
                        ProductModel(
                            id: '',
                            title: title,
                            description: title,
                            price: price,
                            img: productType.toLowerCase(),
                            imageUrl: '',
                            isFavorite: false
                        )
                    );
                    Navigator.pop(context) ;
                  }
                },
                child: Text('add Product', style: TextStyle(color: Colors.white)),
                color: Colors.blue,
              )

            ],
          ),
        ),
      ),
    );
  }
}
