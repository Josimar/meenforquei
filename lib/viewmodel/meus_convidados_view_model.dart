import 'package:meenforquei/locator.dart';
import 'package:meenforquei/models/meus_convidados_model.dart';
import 'package:meenforquei/services/dialog_service.dart';
import 'package:meenforquei/services/firestore_service.dart';
import 'package:meenforquei/services/navigation_service.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/utils/route_names.dart';
import 'package:meenforquei/utils/utilitarios.dart';
import 'package:meenforquei/viewmodel/base_model.dart';

class MeusConvidadosViewModel extends BaseModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();

  List<MeusConvidadosModel> _meusconvidados;
  List<MeusConvidadosModel> get meusconvidados => _meusconvidados;

  Future<bool> hasContactsPermission() async {
    // return hasPermission(PermissionGroup.contacts);
  }
  Future<bool> hasPermission() async {
    //var permissionStatus =
    // await _permissionHandler.checkPermissionStatus(permission);
    // return permissionStatus == PermissionStatus.granted;
  }

  Future fetchMeusConvidados() async {
    setBusy(true);
    var meusconvidadosResult = await _firestoreService.getMeusConvidadosOnceOff(currentUser.wedding);
    setBusy(false);

    if (meusconvidadosResult == null){
      meusconvidadosResult = new List<MeusConvidadosModel>();
    }

    if (meusconvidadosResult is List<MeusConvidadosModel>){
      _meusconvidados = meusconvidadosResult;
      notifyListeners();
    }else{
      await _dialogService.showDialog(
          title: 'Convidados update failed', // ToDo: String fixa
          description: meusconvidadosResult != null ? meusconvidadosResult : "Nenhum convidado encontrado"
      );
    }
  }

  void editMeusConvidados(int index){
    _navigationService.navigateInTo(CreateMeusConvidadosViewRoute, arguments: _meusconvidados[index]);
  }

  void addMeusConvidados(){
    _navigationService.navigateInTo(CreateMeusConvidadosViewRoute, arguments: RouteArguments(null, null));
  }

  Future addConvidado(MeusConvidadosModel data) async{
    await _firestoreService.addConvidado(currentUser.wedding, data) ;
    notifyListeners();
    return ;
  }

  Future deleteMeusConvidados(int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
        title: MEString.temCerteza,
        description: MEString.querExcluir,
        confirmationTitle: MEString.sim,
        cancelTitle: MEString.nao
    );

    if (dialogResponse.confirmed){
      setBusy(true);
      await _firestoreService.deleteMeusConvidados(currentUser.wedding, _meusconvidados[index].did);
      setBusy(false);
    }
  }

}