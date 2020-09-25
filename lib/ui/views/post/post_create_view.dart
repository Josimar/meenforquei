import 'package:flutter/material.dart';
import 'package:meenforquei/models/user_model.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/viewmodel/post_view_model.dart';
import 'package:provider/provider.dart';
import 'package:meenforquei/models/post_model.dart';
import 'package:meenforquei/ui/shared/ui_helpers.dart';
import 'package:meenforquei/ui/widgets/input_field.dart';

class CreatePostView extends StatefulWidget {
  final PostModel edittingPost;
  final UserModel currentUser;

  CreatePostView({Key key, this.edittingPost, this.currentUser}) : super(key: key);

  @override
  _CreatePostViewState createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final _formKey = GlobalKey<FormState>();
  String title;

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostViewModel>(context);

    postProvider.setEdittingPost(widget.edittingPost);
    if (widget.edittingPost != null)
      title = widget.edittingPost.title;

    return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: !postProvider.busy
                ? Icon(Icons.add)
                : CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
            onPressed: () {
              if (!postProvider.busy){
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  // await productProvider.addProduct(ProductModel(name: title,price: price,img: productType.toLowerCase()));
                  postProvider.addPost(title: title);
                }
              }

            },
            backgroundColor:
            !postProvider.busy ? Theme.of(context).primaryColor : Colors.grey[600],
          ),
          appBar: AppBar(
            title: Text(MEString.titlePost)
          ),
          body: Padding(
            padding: EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    initialValue: title,
                    decoration: InputDecoration(
                        labelText: MEString.titlePost,
                        border: InputBorder.none,
                        hintText: MEString.titlePost,
                        fillColor: Colors.grey[300],
                        filled: true,
                    ),
                    validator: (value) {
                        if (value.isEmpty) {
                          return MEString.titleValidate;
                        }
                        return null;
                    },
                    onSaved: (value) => title = value
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    alignment: Alignment.center,
                    child: Text(
                      MEString.addImage,
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  )

                ],
              ),
            ),
          )
      );
  }
}
