import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:meenforquei/models/noticia_model.dart';
import 'package:meenforquei/ui/shared/ui_helpers.dart';
import 'package:meenforquei/ui/widgets/input_field.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/viewmodel/noticias_create_model.dart';

class CreateNoticiasView extends StatelessWidget {
  final titleController = TextEditingController();
  final NoticiaModel edittingNoticia;

  CreateNoticiasView({Key key, this.edittingNoticia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateNoticiaViewModel>.reactive(
      viewModelBuilder: () => CreateNoticiaViewModel(),
      onModelReady: (model){
        titleController.text = edittingNoticia?.title ?? '';  // update the text in the titleController
        model.setEdittingNoticia(edittingNoticia);
      },
      builder: (context, model, child) => Scaffold(
          floatingActionButton: FloatingActionButton(
            child: !model.busy
                ? Icon(Icons.add)
                : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)),
            onPressed: () {
              if (!model.busy){
                model.addNoticia(title: titleController.text);
              }
            },
            backgroundColor:
            !model.busy ? Theme.of(context).primaryColor : Colors.grey[600],
          ),
          appBar: AppBar(
            title: Text(MEString.titleNoticias),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                verticalSpace(40),
                Text(
                  MEString.novaNoticia,
                  style: TextStyle(fontSize: 26),
                ),
                verticalSpaceMedium,
                InputField(
                  placeholder: 'Title',
                  controller: titleController,
                ),
                verticalSpaceMedium,
                Text(MEString.image),
                verticalSpaceSmall,
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.center,
                  child: Text(
                    MEString.tapImage,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                )
              ],
            ),
          )),
    );
  }
}