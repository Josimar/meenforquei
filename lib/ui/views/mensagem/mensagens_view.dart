import 'package:flutter/material.dart';
import 'package:meenforquei/ui/views/mensagem/mensagem_contatos_view.dart';
import 'package:meenforquei/ui/views/mensagem/mensagem_conversas_view.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/ui/widgets/custom_drawer.dart';

class MensagemView extends StatefulWidget {
  final PageController pageController;
  MensagemView(this.pageController);

  @override
  _MensagemViewState createState() => _MensagemViewState();
}

class _MensagemViewState extends State<MensagemView> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<String> itensMenu = [MEString.configuracao];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this
    );
  }

  _escolhaMenuItem(String itemEscolhido){
    switch (itemEscolhido){
      case MEString.configuracao:
        print(itemEscolhido);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('| => Mensagem View'); // ToDo: print mensagem

    bool _podeEditar = false;

    return Scaffold(
          drawer: CustomDrawer(widget.pageController),
          appBar: AppBar(
            title: Text(MEString.titleMensagens),
            centerTitle: true,
            bottom: TabBar(
              indicatorWeight: 4,
              labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              controller: _tabController,
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(text: MEString.conversas),
                Tab(text: MEString.contatos)
              ]
            ),

            actions: <Widget>[
              _podeEditar ? PopupMenuButton<String>(
                onSelected: _escolhaMenuItem,
                itemBuilder: (context){
                  return itensMenu.map((item){
                    return PopupMenuItem<String>(
                      value: item,
                      child: Text(item)
                    );
                  }).toList();
                },
              ) : Container()
            ],

          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              MensagemConversasView(),
              MensagemContatosView()
            ],
          )

    );

  }
}
