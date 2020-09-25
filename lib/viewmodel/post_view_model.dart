import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meenforquei/locator.dart';
import 'package:meenforquei/models/post_model.dart';
import 'package:meenforquei/services/dialog_service.dart';
import 'package:meenforquei/services/post_service.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/utils/route_names.dart';
import 'package:meenforquei/services/navigation_service.dart';
import 'package:meenforquei/utils/utilitarios.dart';
import 'package:meenforquei/viewmodel/base_model.dart';

class PostViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final PostService _postService = locator<PostService>();
  final DialogService _dialogService = locator<DialogService>();

  List<PostModel> _posts;
  List<PostModel> get posts => _posts;

  PostModel _edittingPost;
  bool get _editting => _edittingPost != null;

  Future<PostModel> getPostById(String id) async {
    var doc = await _postService.getPostById(currentUser.wedding, id);
    return PostModel.fromMap(doc.data(), doc.id) ;
  }

  Future<List<PostModel>> fetchPost() async {
    var result = await _postService.getPost(currentUser.wedding);

    _posts = result.documents
        .map((doc) => PostModel.fromMap(doc.data(), doc.id))
        .toList();

    if (_posts == null){
      _posts = new List<PostModel>();
    }

    if (_posts is List<PostModel>){
      notifyListeners();
    }else{
      _dialogService.showDialog(
          title: MEString.updateFailed,
          description: _posts != null ? _posts : MEString.emptyPost
      );
    }

    return _posts;
  }

  Stream<QuerySnapshot> fetchPostsAsStream() {
    return _postService.getPostAsStream(currentUser.wedding);
  }

  Future deletePost(String documentId) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
        title: MEString.temCerteza, // ToDo texto fixo
        description: MEString.querExcluir,
        confirmationTitle: 'Yes',
        cancelTitle: 'No'
    );

    if (dialogResponse.confirmed){
      setBusy(true);
      await _postService.deletePost(currentUser.wedding, documentId);
      setBusy(false);
    }
  }

  Future addPost({@required String title}) async{
    setBusy(true);

    var result;

    if (!_editting){
      result = await _postService
          .addPost(currentUser.wedding, PostModel(title: title, userId: currentUser.uid));
    }else{
      result = await _postService.updatePost(currentUser.wedding, PostModel(
          title: title,
          userId: _edittingPost.userId,
          documentId: _edittingPost.documentId
      ));
    }

    setBusy(false);

    if (result is String){
      await _dialogService.showDialog(
          title: 'Could not create post', // ToDo: String fixa
          description: result
      );
    }else{
      await _dialogService.showDialog(
          title: 'Post successfully added', // ToDo: String fixa
          description: 'Your post has been created' // ToDo: String fixa
      );
    }

    _navigationService.pop();
  }

  void setEdittingPost(PostModel edittingPost){
    _edittingPost = edittingPost;
  }

  void editPost(PostModel post){
    _navigationService.navigateInTo(CreatePostViewRoute, arguments: RouteArguments(post, currentUser));
  }

  void newPost(){
    _navigationService.navigateInTo(CreatePostViewRoute, arguments: RouteArguments(null, currentUser));
  }

}
