import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meenforquei/locator.dart';
import 'package:meenforquei/models/conversa_model.dart';
import 'package:meenforquei/models/convidados_model.dart';
import 'package:meenforquei/models/mensagem_model.dart';
import 'package:meenforquei/services/dialog_service.dart';
import 'package:meenforquei/services/mensagem_service.dart';
import 'package:meenforquei/services/navigation_service.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/utils/route_names.dart';
import 'package:meenforquei/utils/utilitarios.dart';
import 'package:meenforquei/viewmodel/base_model.dart';

class MensagensViewModel extends  BaseModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final MessageService _messageService = locator<MessageService>();
  final DialogService _dialogService = locator<DialogService>();

  List<MensagemModel> _mensagem;
  List<MensagemModel> get mensagem => _mensagem;

  List<ConvidadosModel> _convidado;
  List<ConvidadosModel> get convidado => _convidado;

  List<ConversaModel> _conversa;
  List<ConversaModel> get conversa => _conversa;

  Stream<QuerySnapshot> fetchMensagensAsStream(String remetenteId, String destinatarioId) {
    return _messageService.getMensagemAsStream(currentUser.wedding, remetenteId, destinatarioId);
  }



  Future fetchMensagem() async {
    setBusy(true);
    var mensagemResult = await _messageService.getMensagensOnceOff(currentUser.wedding);
    setBusy(false);

    if (mensagemResult == null){
      mensagemResult = new List<MensagemModel>();
    }

    if (mensagemResult is List<MensagemModel>){
      _mensagem = mensagemResult;
      notifyListeners();
    }else{
      await _dialogService.showDialog(
          title: MEString.errorMensagem,
          description: mensagemResult != null ? mensagemResult : MEString.emptyMensagem
      );
    }
  }

  Future fetchContatos() async {
    setBusy(true);
    var contatoResult = await _messageService.getContatoOnce(currentUser.wedding, currentUser.uid);
    setBusy(false);

    if (contatoResult == null) {
      contatoResult = new List<ConvidadosModel>();
    }

    if (contatoResult is List<ConvidadosModel>) {
      _convidado = contatoResult;
      notifyListeners();
    } else {
      await _dialogService.showDialog(
          title: MEString.errorContato, // ToDo: String fixa
          description: contatoResult != null
              ? contatoResult
              : MEString.nenhumContato
      );
    }
  }

  Future fetchConversas() async {
    setBusy(true);
    var conversaResult = await _messageService.getConversaOnce(currentUser.wedding, currentUser.uid);
    setBusy(false);

    if (conversaResult == null) {
      conversaResult = new List<ConversaModel>();
    }

    if (conversaResult is List<ConversaModel>) {
      _conversa = conversaResult;
      notifyListeners();
    } else {
      await _dialogService.showDialog(
          title: MEString.errorConversa,
          description: conversaResult != null
              ? conversaResult
              : MEString.emptyConversa
      );
    }
  }

  Stream<QuerySnapshot> streamMensagemCollection(String destUid) {
    return _messageService.streamMensagemCollection(currentUser.wedding, currentUser.uid, destUid);
  }

  Future handleStartUpLogic() async {
    setBusy(true);
    print(MEString.teste01);
    new Timer(const Duration(milliseconds: 3000), (){
      setBusy(false);
      print(MEString.teste02);
    });
  }


  void editMensagem(int index){
    _navigationService.navigateInTo(CreateMensagemViewRoute, arguments: _mensagem[index]);
  }

  void newMensagem(int index){
    _navigationService.navigateInTo(CreateMensagemViewRoute, arguments: RouteArguments(_convidado[index], currentUser));
  }

  void newMensagemConversa(String name, String urlImage, String idDestino){
    ConvidadosModel convidadoTemp = new ConvidadosModel();
    convidadoTemp.name = name;
    convidadoTemp.urlimagem = urlImage;
    convidadoTemp.uid = idDestino;

    _navigationService.navigateInTo(CreateMensagemViewRoute, arguments: RouteArguments(convidadoTemp, currentUser));
  }

  Future deleteMensagem(int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
        title: MEString.temCerteza,
        description: MEString.querExcluir,
        confirmationTitle: MEString.sim,
        cancelTitle: MEString.nao
    );

    if (dialogResponse.confirmed){
      setBusy(true);
      await _messageService.deleteMensagem(currentUser.wedding, _mensagem[index].did);
      setBusy(false);
    }
  }

}