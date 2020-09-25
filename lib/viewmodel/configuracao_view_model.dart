import 'package:meenforquei/locator.dart';
import 'package:meenforquei/models/configuracao_model.dart';
import 'package:meenforquei/services/dialog_service.dart';
import 'package:meenforquei/services/firestore_service.dart';
import 'package:meenforquei/services/navigation_service.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/utils/route_names.dart';
import 'package:meenforquei/viewmodel/base_model.dart';

class ConfiguracaoViewModel extends BaseModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();

  List<ConfiguracaoModel> _configuracao;
  List<ConfiguracaoModel> get configuracao => _configuracao;

  Future fetchConfiguracao() async {
    setBusy(true);
    var configuracaoResult = await _firestoreService.getConfiguracaoOnceOff(currentUser.wedding);
    setBusy(false);

    if (configuracaoResult == null){
      configuracaoResult = new List<ConfiguracaoModel>();
    }

    if (configuracaoResult is List<ConfiguracaoModel>){
      _configuracao = configuracaoResult;
      notifyListeners();
    }else{
      await _dialogService.showDialog(
          title: 'Configuração update failed', // ToDo: String fixa
          description: configuracaoResult != null ? configuracaoResult : "Nenhuma configuração encontrada"
      );
    }
  }

  void editConfiguracao(int index){
    _navigationService.navigateInTo(CreateConfiguracaoViewRoute, arguments: _configuracao[index]);
  }

  Future deleteConfiguracao(int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
        title: MEString.temCerteza,
        description: MEString.querExcluir,
        confirmationTitle: MEString.sim,
        cancelTitle: MEString.nao
    );

    if (dialogResponse.confirmed){
      setBusy(true);
      await _firestoreService.deleteConfiguracao(currentUser.wedding, _configuracao[index].did);
      setBusy(false);
    }
  }

}