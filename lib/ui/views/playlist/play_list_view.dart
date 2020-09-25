import 'package:flutter/material.dart';
import 'package:meenforquei/ui/widgets/item/play_list_item.dart';
import 'package:meenforquei/viewmodel/play_list_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/ui/widgets/custom_drawer.dart';

class PlayListView extends StatelessWidget {
  final PageController pageController;
  PlayListView(this.pageController);

  @override
  Widget build(BuildContext context) {
    print('| => Play List View'); // ToDo: print Play List

    bool _podeEditar = false;

    return ViewModelBuilder<PlayListViewModel>.reactive(
        viewModelBuilder: () => PlayListViewModel(),
        onModelReady: (model) => model.fetchPlayList(),
        builder: (context, model, child) => Scaffold(
          drawer: CustomDrawer(pageController),
          appBar: AppBar(
            title: Text(MEString.titlePlayList),
            centerTitle: true,
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                child: model.playlist == null ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                    )
                ) : model.playlist.length == 0 ? Center(
                    child: Text(
                        MEString.emptyPlayList,
                        style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)
                    )
                ) :
                ListView.builder(
                    itemCount: model.playlist.length,
                    padding: new EdgeInsets.only(top: 5.0),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () => _podeEditar ? model.editPlaylist(index) : null, // model.detailPlaylist(index),
                          child: PlayListItem(
                              playlist: model.playlist[index],
                              onDeleteItem: () => model.deletePlaylist(index)
                          )
                      );
                    }
                ),
              )
            ],
          ),
        )
    );

  }
}
