import 'package:meenforquei/models/product_model.dart';

final DUMMY_PRODUCTS = [
  ProductModel(
    id: 'p1',
    title: 'First Product',
    description: 'My first product',
    price: '10.00',
    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/me-enforquei.appspot.com/o/images%2Fproduto_01.jpg?alt=media&token=77a6d76c-1a71-4263-b675-321049441777',
    isFavorite: false
  ),
  ProductModel(
      id: 'p2',
      title: 'Second Product',
      description: 'My second product',
      price: '11.00',
      imageUrl: 'https://firebasestorage.googleapis.com/v0/b/me-enforquei.appspot.com/o/images%2Fproduto_02.jpg?alt=media&token=80f3259b-aa2d-482e-b79f-84c738d4a628',
      isFavorite: false
  ),
  ProductModel(
      id: 'p3',
      title: 'Third Product',
      description: 'My third product',
      price: '13.00',
      imageUrl: 'https://firebasestorage.googleapis.com/v0/b/me-enforquei.appspot.com/o/images%2Fproduto_03.jpg?alt=media&token=637ed405-bfdb-439b-8daa-ebcf874234a6',
      isFavorite: false
  ),
];