import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meenforquei/locator.dart';
import 'package:meenforquei/models/product_model.dart';
import 'package:meenforquei/services/navigation_service.dart';
import 'package:meenforquei/services/product_service.dart';
import 'package:meenforquei/utils/route_names.dart';
import 'package:meenforquei/utils/utilitarios.dart';
import 'package:meenforquei/viewmodel/base_model.dart';

class ProductViewModel extends BaseModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final ProductService _firestoreService = locator<ProductService>();

  List<ProductModel> products;
  ProductModel product;

  bool _showFavoriteOnly = false;

  Future<ProductModel> getProductById(String id) async {
    var doc = await _firestoreService.getProductById(currentUser.wedding, id);
    return ProductModel.fromMap(doc.data(), doc.id) ;
  }

  Future<List<ProductModel>> fetchProducts() async {
    var result = await _firestoreService.getProducts(currentUser.wedding, _showFavoriteOnly);
    products = result.documents
        .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
        .toList();
    return products;
  }

  Stream<QuerySnapshot> fetchProductsAsStream() {
    return _firestoreService.getProductsAsStream(currentUser.wedding);
  }

  Future addProduct(ProductModel data) async{
    await _firestoreService.addProduct(currentUser.wedding, data.toJson()) ;
    notifyListeners();
    return ;
  }

  Future removeProduct(String id) async{
    await _firestoreService.removeProduct(currentUser.wedding, id) ;
    notifyListeners();
    return;
  }

  Future<ProductModel> updateProduct(String id, ProductModel data) async{
    await _firestoreService.updateProduct(currentUser.wedding, id, data.toJson()) ;
    notifyListeners();
    return data;
  }

  void newProduct(){
    _navigationService.navigateInTo(CreateProductViewRoute);
  }

  Future editProduct({ProductModel produto}) async {
    final result = await _navigationService.navigateInTo(EditProductViewRoute, arguments: RouteArguments(produto, currentUser));
    return result;
  }

  void detailProduct({ProductModel produto}){
    _navigationService.navigateInTo(DetailProductViewRoute, arguments: RouteArguments(produto, currentUser));
  }

  void toggleFavorite(ProductModel produto) async {
    produto.isFavorite = !produto.isFavorite;
    String id = produto.id;
    await _firestoreService.updateProduct(currentUser.wedding, id, produto.toJson()) ;
    notifyListeners();
  }

  void showFavoriteOnly(){
    _showFavoriteOnly = true;
    notifyListeners();
  }

  void showFavoriteAll(){
    _showFavoriteOnly = false;
    notifyListeners();
  }
}