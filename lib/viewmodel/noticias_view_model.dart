import 'package:meenforquei/locator.dart';
import 'package:meenforquei/models/noticia_model.dart';
import 'package:meenforquei/services/dialog_service.dart';
import 'package:meenforquei/services/firestore_service.dart';
import 'package:meenforquei/services/navigation_service.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/utils/route_names.dart';
import 'package:meenforquei/utils/utilitarios.dart';
import 'package:meenforquei/viewmodel/base_model.dart';

class NoticiasViewModel extends BaseModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();

  List<NoticiaModel> _noticia;
  List<NoticiaModel> get noticia => _noticia;

  Future fetchNoticias() async {
    setBusy(true);
    var noticiaResult = await _firestoreService.getNoticiaOnceOff(currentUser.wedding);
    setBusy(false);

    if (noticiaResult == null){
      noticiaResult = new List<NoticiaModel>();
    }

    if (noticiaResult is List<NoticiaModel>){
      _noticia = noticiaResult;
      notifyListeners();
    }else{
      await _dialogService.showDialog(
          title: 'Notícia update failed', // ToDo: String fixa
          description: noticiaResult != null ? noticiaResult : "Nenhum notícia encontrada"
      );
    }
  }

  void editNoticia(int index){
    _navigationService.navigateInTo(CreateNoticiaViewRoute, arguments: _noticia[index]);
  }

  void detailNoticia(int index){
    _navigationService.navigateInTo(DetailNoticiaViewRoute, arguments: RouteArguments(_noticia[index], currentUser));
  }

  Future deleteNoticia(int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
        title: MEString.temCerteza,
        description: MEString.querExcluir,
        confirmationTitle: MEString.sim,
        cancelTitle: MEString.nao
    );

    if (dialogResponse.confirmed){
      setBusy(true);
      await _firestoreService.deleteNoticia(currentUser.wedding, _noticia[index].did);
      setBusy(false);
    }
  }

}