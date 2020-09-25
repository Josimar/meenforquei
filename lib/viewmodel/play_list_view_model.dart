import 'package:meenforquei/locator.dart';
import 'package:meenforquei/models/play_list_model.dart';
import 'package:meenforquei/services/dialog_service.dart';
import 'package:meenforquei/services/firestore_service.dart';
import 'package:meenforquei/services/navigation_service.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/utils/route_names.dart';
import 'package:meenforquei/viewmodel/base_model.dart';

class PlayListViewModel extends BaseModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();

  List<PlayListModel> _playlist;
  List<PlayListModel> get playlist => _playlist;


  Future fetchPlayList() async {
    setBusy(true);
    var playlistResult = await _firestoreService.getPlayListOnceOff(currentUser.wedding);
    setBusy(false);

    if (playlistResult == null){
      playlistResult = new List<PlayListModel>();
    }

    if (playlistResult is List<PlayListModel>){
      _playlist = playlistResult;
      notifyListeners();
    }else{
      await _dialogService.showDialog(
          title: 'Play list update failed', // ToDo: String fixa
          description: playlistResult != null ? playlistResult : "Nenhum play list encontrado"
      );
    }
  }

  void editPlaylist(int index){
    _navigationService.navigateInTo(CreatePlayListViewRoute, arguments: _playlist[index]);
  }

  Future deletePlaylist(int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
        title: MEString.temCerteza,
        description: MEString.querExcluir,
        confirmationTitle: MEString.sim,
        cancelTitle: MEString.nao
    );

    if (dialogResponse.confirmed){
      setBusy(true);
      await _firestoreService.deletePlayList(currentUser.wedding, _playlist[index].did);
      setBusy(false);
    }
  }

}