import 'package:flutter/material.dart';
import 'package:meenforquei/ui/widgets/item/custom_drawer_item.dart';
import 'package:meenforquei/utils/meenforquei.dart';

import 'package:meenforquei/viewmodel/login_view_model.dart';
import 'package:stacked/stacked.dart';

class CustomDrawer extends StatefulWidget {
  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  @override
  Widget build(BuildContext context) {

    Widget _buildDrawerBack() => Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 200, 250, 250),
                Color.fromARGB(255, 232, 250, 250),
              ]
          )
      ),
    );

    /*
    final drawerHeader = UserAccountsDrawerHeader(
      accountName: new Text('Josimar Silva'),
      accountEmail: new Text('josimar@gmail.com'),
      currentAccountPicture: CircleAvatar(
        child: FlutterLogo(size: 42),
        backgroundColor: Colors.deepPurpleAccent
      ),
      otherAccountsPictures: <Widget>[
        CircleAvatar(child: Text('J')),
        CircleAvatar(child: Text('B')),
        CircleAvatar(child: Text('S')),
      ],
    );
    */

    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      // onModelReady: (model) => model.fetchPosts(),
      builder: (context, model, child) => Drawer(
        child: Stack(
          children: <Widget>[
            _buildDrawerBack(),
            ListView(
              padding: EdgeInsets.only(left: 32, top: 16),
              children: <Widget>[
                // drawerHeader,
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.fromLTRB(0, 16, 16, 8),
                  height: 140,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 8,
                        left: 0,
                        child: Text(
                          "Me Enforquei",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 34,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                "Olá, ${!model.userLogged ? "" : (model.currentUser != null ? model.currentUser.name : "")}",
                                style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              child: Text(
                                  !model.userLogged
                                      ? "Entre ou cadastre-se"
                                      : "Sair",
                                  style: TextStyle(
                                      color: Colors.black87, //Theme.of(context).primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                              onTap: () async {
                                if (model.userLogged){
                                  model.signOut();
                                }
                                model.goToRemoveDrawer(context);
                                model.navigateToLogin();
                              },
                            )
                          ],
                        )
                      )
                    ],
                  ),
                ),
                Divider(),
                CustomDrawerItem(Icons.home, MEString.mnuInicio, widget.pageController, 0),
                CustomDrawerItem(Icons.people_outline, MEString.mnuNoivos, widget.pageController, 1),
                CustomDrawerItem(Icons.movie_filter, MEString.titleRetrospectiva, widget.pageController, 2),
                CustomDrawerItem(Icons.people, MEString.convidados, widget.pageController, 3),
                CustomDrawerItem(Icons.list, MEString.titleTarefas, widget.pageController, 4),
                CustomDrawerItem(Icons.message, MEString.mensagens, widget.pageController, 5),
                CustomDrawerItem(Icons.playlist_add_check, MEString.checklist, widget.pageController, 6),
                CustomDrawerItem(Icons.calendar_today, MEString.mnuAgenda, widget.pageController, 7),
                CustomDrawerItem(Icons.play_circle_outline, MEString.playlist, widget.pageController, 8),
                CustomDrawerItem(Icons.group, MEString.meusFornecedores, widget.pageController, 9),
                CustomDrawerItem(Icons.attach_money, MEString.orcamento, widget.pageController, 10),
                CustomDrawerItem(Icons.fiber_new, MEString.titleNoticias, widget.pageController, 11),
                CustomDrawerItem(Icons.map, MEString.localCerimonia, widget.pageController, 12),
                CustomDrawerItem(Icons.add_to_queue, MEString.quiz, widget.pageController, 13),
                CustomDrawerItem(Icons.texture, MEString.configuracao, widget.pageController, 14),
//                CustomDrawerItem(Icons.note, MEString.bloconotas, widget.pageController, 15),
//                CustomDrawerItem(Icons.description, MEString.titlePost, widget.pageController, 16),
//                CustomDrawerItem(Icons.power, MEString.product, widget.pageController, 17),
              ],
            )
          ],
        ),
      )
    );

  }
}
