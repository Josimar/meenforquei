import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meenforquei/models/post_model.dart';
import 'package:meenforquei/ui/widgets/custom_drawer.dart';
import 'package:meenforquei/ui/widgets/item/post_item.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:provider/provider.dart';
import 'package:meenforquei/ui/shared/ui_helpers.dart';
import 'package:meenforquei/viewmodel/post_view_model.dart';

class PostView extends StatefulWidget {
  final PageController pageController;
  const PostView(this.pageController, {Key key}) : super(key: key);

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  List<PostModel> posts;

  @override
  Widget build(BuildContext context) {
    print('| => Post View'); // ToDo: print Post

    final postProvider = Provider.of<PostViewModel>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: !postProvider.busy ? Icon(Icons.add) : CircularProgressIndicator(),
        onPressed: postProvider.newPost,
      ),
      drawer: CustomDrawer(widget.pageController),
      appBar: AppBar(
        title: Text(MEString.titlePost),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
          child: StreamBuilder(
              stream: postProvider.fetchPostsAsStream(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                if (snapshot.hasData){
                  posts = snapshot.data.documents.map((doc) => PostModel.fromMap(doc.data(), doc.documentID)).toList();

                  if (posts.length == 0){
                    return Center(child: Text(MEString.emptyList));
                  }

                  return ListView.builder(
                      itemCount: posts.length,

                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () => postProvider.editPost(posts[index]),
                        child: PostItem(
                          post: posts[index],
                          onDeleteItem: () => postProvider.deletePost(posts[index].documentId),
                        ),
                      )
                  );
                }else{
                  return Text(MEString.carregando);
                }
              }
          )
      )
    );
  }
}
