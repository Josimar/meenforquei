import 'package:meenforquei/locator.dart';
import 'package:meenforquei/models/orcamento_model.dart';
import 'package:meenforquei/services/dialog_service.dart';
import 'package:meenforquei/services/firestore_service.dart';
import 'package:meenforquei/services/navigation_service.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/utils/route_names.dart';
import 'package:meenforquei/viewmodel/base_model.dart';

class OrcamentoViewModel extends BaseModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();

  List<OrcamentoModel> _orcamento;
  List<OrcamentoModel> get orcamento => _orcamento;

  Future fetchOrcamento() async {
    setBusy(true);
    var orcamentoResult = await _firestoreService.getOrcamentoOnceOff(currentUser.wedding);
    setBusy(false);

    if (orcamentoResult == null){
      orcamentoResult = new List<OrcamentoModel>();
    }

    if (orcamentoResult is List<OrcamentoModel>){
      _orcamento = orcamentoResult;
      notifyListeners();
    }else{
      await _dialogService.showDialog(
          title: 'Orçamento update failed', // ToDo: String fixa
          description: orcamentoResult != null ? orcamentoResult : "Nenhum orçamento encontrado"
      );
    }
  }

  void editOrcamento(int index){
    _navigationService.navigateInTo(CreateOrcamentoViewRoute, arguments: _orcamento[index]);
  }

  Future deleteOrcamento(int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
        title: MEString.temCerteza,
        description: MEString.querExcluir,
        confirmationTitle: MEString.sim,
        cancelTitle: MEString.nao
    );

    if (dialogResponse.confirmed){
      setBusy(true);
      await _firestoreService.deleteOrcamento(currentUser.wedding, _orcamento[index].did);
      setBusy(false);
    }
  }

}