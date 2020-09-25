import 'package:meenforquei/locator.dart';
import 'package:meenforquei/models/local_cerimonia_model.dart';
import 'package:meenforquei/services/dialog_service.dart';
import 'package:meenforquei/services/firestore_service.dart';
import 'package:meenforquei/services/navigation_service.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/utils/route_names.dart';
import 'package:meenforquei/viewmodel/base_model.dart';

class LocalCerimoniaViewModel extends BaseModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();

  List<LocalCerimoniaModel> _local;
  List<LocalCerimoniaModel> get local => _local;

  Future fetchLocalCerimonia() async {
    setBusy(true);
    var localResult = await _firestoreService.getLocalCerimoniaOnceOff(currentUser.wedding);
    setBusy(false);

    if (localResult is List<LocalCerimoniaModel>){
      _local = localResult;
      notifyListeners();
    }else{
      await _dialogService.showDialog(
          title: 'Local update failed', // ToDo: String fixa
          description: localResult
      );
    }
  }

  void editLocal(int index){
    _navigationService.navigateInTo(CreateLocalViewRoute, arguments: _local[index]);
  }

  Future deleteLocal(int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
        title: MEString.temCerteza,
        description: MEString.querExcluir,
        confirmationTitle: MEString.sim,
        cancelTitle: MEString.nao
    );

    if (dialogResponse.confirmed){
      setBusy(true);
      await _firestoreService.deleteLocalCerimonia(currentUser.wedding, _local[index].did);
      setBusy(false);
    }
  }

}