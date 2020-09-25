import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meenforquei/locator.dart';
import 'package:meenforquei/models/check_list_model.dart';
import 'package:meenforquei/services/check_list_service.dart';
import 'package:meenforquei/services/dialog_service.dart';
import 'package:meenforquei/services/navigation_service.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/utils/route_names.dart';
import 'package:meenforquei/utils/utilitarios.dart';
import 'package:meenforquei/viewmodel/base_model.dart';

class CheckListViewModel extends BaseModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final CheckListService _checklistService = locator<CheckListService>();
  final DialogService _dialogService = locator<DialogService>();

  List<CheckListModel> _checklist;
  List<CheckListModel> get checklist => _checklist;

  CheckListModel _edittingCheckList;
  bool get _editting => _edittingCheckList != null;

  void setEdittingCheckList(CheckListModel edittingCheckList){
    _edittingCheckList = edittingCheckList;
  }

  Stream<QuerySnapshot> fetchCheckListAsStream() {
    return _checklistService.getCheckListAsStream(currentUser.wedding);
  }

  Future deleteCheckList(String documentId) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
        title: MEString.temCerteza,
        description: MEString.querExcluir,
        confirmationTitle: MEString.sim,
        cancelTitle: MEString.nao
    );

    if (dialogResponse.confirmed){
      setBusy(true);
      await _checklistService.deleteCheckList(currentUser.wedding, documentId);
      setBusy(false);
    }
  }

  Future addCheckList(String pId, CheckListModel data) async{
    if (pId == null || pId.isEmpty){
      await _checklistService.addPeriodoCheckList(currentUser.wedding, data.toMap());
    }else{
      await _checklistService.addCheckList(currentUser.wedding, pId, data.toMap());
    }

    notifyListeners();
    _navigationService.pop();
  }

  void newCheckList(){
    _navigationService.navigateInTo(CreateCheckListViewRoute, arguments: RouteArguments(null, currentUser));
  }

  void editCheckList(CheckListModel checkModel){
    _navigationService.navigateInTo(CreateCheckListViewRoute, arguments: RouteArguments(checkModel, currentUser));
  }

  Future<List<CheckListModel>> fetchCheckList() async {
    var checklistResult = await _checklistService.getCheckListOnce(currentUser.wedding);

    if (checklistResult == null){
      checklistResult = new List<CheckListModel>();
    }

    if (checklistResult is List<CheckListModel>){
      for (var i = 0; i < checklistResult.length; i++){
        checklistResult[i].tasks = await _checklistService.getCheckListTask(currentUser.wedding, checklistResult[i].did);
        if (checklistResult[i].tasks == null){
          checklistResult[i].tasks = new List<CheckListModel>();
        }
      }
      _checklist = checklistResult;
      return checklistResult;
    }else{
      await _dialogService.showDialog(
          title: MEString.errorCheckList,
          description: checklistResult != null ? checklistResult : MEString.emptyCheckList
      );
      return _checklist;
    }
  }


}