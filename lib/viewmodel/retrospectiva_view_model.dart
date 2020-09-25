import 'package:meenforquei/locator.dart';
import 'package:meenforquei/models/retrospectiva_model.dart';
import 'package:meenforquei/services/firestore_service.dart';
import 'package:meenforquei/viewmodel/base_model.dart';

class RetrospectivaViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  List<RetrospectivaModel> _retro;
  List<RetrospectivaModel> get retro => _retro;

  // Só atualiza quando tiver o retrospectiva
  Future fetchRetrospectivas() async {
    setBusy(true);

    var retrospectivaResult = await _firestoreService.getRetrospectivaOnceOff(currentUser.wedding);

    setBusy(false);

    if (retrospectivaResult is List<RetrospectivaModel>){
      _retro = retrospectivaResult;
      notifyListeners();
    }
  }



}