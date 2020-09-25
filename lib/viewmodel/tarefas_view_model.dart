import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meenforquei/locator.dart';
import 'package:meenforquei/models/tarefa_model.dart';
import 'package:meenforquei/services/dialog_service.dart';
import 'package:meenforquei/services/tarefa_service.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/viewmodel/base_model.dart';

class TarefasViewModel extends BaseModel {
  final TarefaService _tarefaService = locator<TarefaService>();
  final DialogService _dialogService = locator<DialogService>();

  TarefaModel _tarefa;
  bool get _editting => _tarefa != null;

  List<TarefaModel> _tarefas;
  List<TarefaModel> get Tarefas => _tarefas;

  Future<TarefaModel> getTarefaById(String id) async {
    var doc = await _tarefaService.getTarefaById(currentUser.wedding, id);
    // return TarefaModel.fromMap(doc .data, doc.documentID) ;
    return TarefaModel.fromMap(doc.data(), doc.id);
  }

  Future<List<TarefaModel>> fetchTarefa() async {
    var result = await _tarefaService.getTarefas(currentUser.wedding);

    _tarefas = result.documents
        .map((doc) => TarefaModel.fromMap(doc.data, doc.documentID))
        .toList();

    if (_tarefas == null){
      _tarefas = new List<TarefaModel>();
    }

    if (_tarefas is List<TarefaModel>){
      notifyListeners();
    }else{
      _dialogService.showDialog(
          title: MEString.updateFailed,
          description: _tarefas != null ? _tarefas : MEString.emptyList
      );
    }

    return _tarefas;
  }

  Stream<QuerySnapshot> fetchTarefasAsStream() {
    return _tarefaService.getTarefaAsStream(currentUser.wedding);
  }

  Future addTarefa({@required String title, bool isPopup = false}) async{
    if (isPopup){
      setBusy(true);
    }
    var result;

    if (!_editting){
      result = await _tarefaService.addTarefa(currentUser.wedding, TarefaModel(cid: currentUser.uid,  title: title, description: title, complete: false));
    }else{
      result = await _tarefaService.updateTarefa(currentUser.wedding, TarefaModel(
          title: title,
          description: title,
          cid: _tarefa.cid,
          rid: _tarefa.rid,
          tid: _tarefa.tid,
          date: _tarefa.date,
          complete: _tarefa.complete
      ));
    }

    if (isPopup){
      setBusy(false);
    }

    if (result is String) {
      await _dialogService.showDialog(
          title: MEString.errorMessage,
          description: result
      );
    }else if (isPopup){
      await _dialogService.showDialog(
          title: MEString.successMessage,
          description: MEString.successRegister
      );
    }
  }

  Future checkTarefa({@required String title, bool isPopup = false}) async{
    if (isPopup){
      setBusy(true);
    }
    var result;

    result = await _tarefaService.updateTarefa(currentUser.wedding, _tarefa);

    if (isPopup){
      setBusy(false);
    }

    if (result is String) {
      await _dialogService.showDialog(
          title: MEString.errorMessage,
          description: result
      );
    }else if (isPopup){
      await _dialogService.showDialog(
          title: MEString.successMessage,
          description: MEString.successRegister
      );
    }
  }

  Future deleteTarefa(String documentId, bool isPopup) async {
    if (isPopup){
      var dialogResponse = await _dialogService.showConfirmationDialog(
          title: MEString.temCerteza,
          description: MEString.querExcluir,
          confirmationTitle: MEString.sim,
          cancelTitle: MEString.nao
      );

      if (dialogResponse.confirmed){
        setBusy(true);
        await _tarefaService.deleteTarefa(currentUser.wedding, documentId, false);
        setBusy(false);
      }
    }else{
      await _tarefaService.deleteTarefa(currentUser.wedding, documentId, false);
    }
  }

  Future recuperaTarefa(String documentId, bool isPopup) async {
    if (isPopup){
      setBusy(true);
    }

    await _tarefaService.recuperaTarefa(currentUser.wedding, documentId);

    if (isPopup){
      setBusy(false);
    }
  }

  void setEdittingTarefa(TarefaModel edittingTarefa){
    _tarefa = edittingTarefa;
  }

}