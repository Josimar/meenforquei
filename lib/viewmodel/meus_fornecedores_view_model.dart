import 'package:meenforquei/locator.dart';
import 'package:meenforquei/models/meus_fornecedores_model.dart';
import 'package:meenforquei/services/dialog_service.dart';
import 'package:meenforquei/services/firestore_service.dart';
import 'package:meenforquei/services/navigation_service.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/utils/route_names.dart';
import 'package:meenforquei/viewmodel/base_model.dart';

class MeusFornecedoresViewModel extends BaseModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();

  List<MeusFornecedoresModel> _meusfornecedores;
  List<MeusFornecedoresModel> get meusfornecedores => _meusfornecedores;

  Future fetchMeusFornecedores() async {
    setBusy(true);
    var meusfornecedoresResult = await _firestoreService.getMeusFornecedoresOnceOff(currentUser.wedding);
    setBusy(false);

    if (meusfornecedoresResult == null){
      meusfornecedoresResult = new List<MeusFornecedoresModel>();
    }

    if (meusfornecedoresResult is List<MeusFornecedoresModel>){
      _meusfornecedores = meusfornecedoresResult;
      notifyListeners();
    }else{
      await _dialogService.showDialog(
          title: 'Fornecedor update failed', // ToDo: String fixa
          description: meusfornecedoresResult != null ? meusfornecedoresResult : "Nenhum fornecedor encontrado"
      );
    }
  }

  void editMeusFornecedores(int index){
    _navigationService.navigateInTo(CreateMeusFornecedoresViewRoute, arguments: _meusfornecedores[index]);
  }

  Future deleteMeusFornecedores(int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
        title: MEString.temCerteza,
        description: MEString.querExcluir,
        confirmationTitle: MEString.sim,
        cancelTitle: MEString.nao
    );

    if (dialogResponse.confirmed){
      setBusy(true);
      await _firestoreService.deleteMeusFornecedores(currentUser.wedding, _meusfornecedores[index].did);
      setBusy(false);
    }
  }

}