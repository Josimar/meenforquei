import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meenforquei/locator.dart';
import 'package:meenforquei/models/agenda_model.dart';
import 'package:meenforquei/services/agenda_service.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/utils/route_names.dart';
import 'package:meenforquei/utils/utilitarios.dart';
import 'package:meenforquei/viewmodel/base_model.dart';
import 'package:meenforquei/services/dialog_service.dart';
import 'package:meenforquei/services/navigation_service.dart';

class AgendaViewModel extends BaseModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final AgendaService _agendaService = locator<AgendaService>();
  final DialogService _dialogService = locator<DialogService>();

  List<AgendaModel> _agendas;
  List<AgendaModel> get agendas => _agendas;

  AgendaModel agenda;
  bool get _editting => agenda != null;

  Stream<QuerySnapshot> fetchAgendaAsStream() {
    return _agendaService.getAgendaAsStream(currentUser.wedding);
  }

  Stream<List<AgendaModel>> fetchAgendaListAsStream() {
    return _agendaService.getAgendaListAsStream(currentUser.wedding);
  }

  Future fetchAgenda() async {
    setBusy(true);
    var agendaResult = await _agendaService.getAgendaOnce(currentUser.wedding);
    setBusy(false);

    if (agendaResult == null){
      agendaResult = new List<AgendaModel>();
    }

    if (agendaResult is List<AgendaModel>){
      _agendas = agendaResult;
      notifyListeners();
    }else{
      await _dialogService.showDialog(
          title: MEString.errorLoadAgenda,
          description: agendaResult != null ? agendaResult : MEString.emptyList
      );
    }
  }

  Future deleteAgenda(int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
        title: MEString.temCerteza,
        description: MEString.querExcluir,
        confirmationTitle: MEString.sim,
        cancelTitle: MEString.nao
    );

    if (dialogResponse.confirmed){
      setBusy(true);
      await _agendaService.deleteAgenda(currentUser.wedding, _agendas[index].did);
      setBusy(false);
    }
  }

  Future addAgenda(String docID) async{
    setBusy(true);

    var result;

    if (!_editting){
      result = await _agendaService.addAgenda(currentUser.wedding, agenda);
    }else{
      result = await _agendaService.updateAgenda(currentUser.wedding, docID, agenda);
    }

    setBusy(false);

    if (result is String){
      await _dialogService.showDialog(
          title: 'Could not create agenda', // ToDo: String fixa
          description: result
      );
    }else{
      await _dialogService.showDialog(
          title: 'Agenda successfully added', // ToDo: String fixa
          description: 'Your agenda has been created' // ToDo: String fixa
      );
    }

    _navigationService.pop();
  }

  void newAgenda(){
      AgendaModel agendaTemp = new AgendaModel();
      _navigationService.navigateInTo(CreateAgendaViewRoute, arguments: RouteArguments(agendaTemp, currentUser));
  }

  void editAgenda(AgendaModel agendaTemp){
    _navigationService.navigateInTo(CreateAgendaViewRoute, arguments: RouteArguments(agendaTemp, currentUser));
  }

  void detailAgenda(AgendaModel agendaTemp){
    _navigationService.navigateInTo(DetailAgendaViewRoute, arguments: RouteArguments(agendaTemp, null));
  }
}