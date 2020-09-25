import 'package:flutter/material.dart';
import 'package:meenforquei/ui/views/agenda/agenda_view.dart';
import 'package:meenforquei/ui/views/bloconotas/bloco_notas_view.dart';
import 'package:meenforquei/ui/views/casal_view.dart';
import 'package:meenforquei/ui/views/checklist/check_list_view.dart';
import 'package:meenforquei/ui/views/configuracao/configuracao_view.dart';
import 'package:meenforquei/ui/views/convidados/meus_convidados_view.dart';
import 'package:meenforquei/ui/views/fornecedores/meus_fornecedores_view.dart';
import 'package:meenforquei/ui/views/localcerimonia/local_cerimonia_view.dart';
import 'package:meenforquei/ui/views/mensagem/mensagens_view.dart';
import 'package:meenforquei/ui/views/noivos_view.dart';
import 'package:meenforquei/ui/views/noticias/noticias_view.dart';
import 'package:meenforquei/ui/views/orcamento/orcamentos_view.dart';
import 'package:meenforquei/ui/views/playlist/play_list_view.dart';
import 'package:meenforquei/ui/views/post/post_view.dart';
import 'package:meenforquei/ui/views/product/product_view.dart';
import 'package:meenforquei/ui/views/quiz/quiz_view.dart';
import 'package:meenforquei/ui/views/retrospectiva/retrospectiva_view.dart';
import 'package:meenforquei/ui/views/tarefas/tarefas_view.dart';
import 'package:stacked/stacked.dart';
import 'package:meenforquei/viewmodel/home_view_model.dart';

class HomeView extends StatelessWidget {
  final _pageController = PageController();
  // const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('| => Home Screen'); // ToDo: print home screen

    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        // onModelReady: (model) => model.fetchPosts(),
        builder: (context, model, child) => PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            CasalView(_pageController),
            NoivosView(_pageController),
            RetrospectivaView(_pageController),
            MeusConvidadosView(_pageController),
            TarefasView(_pageController),
            MensagemView(_pageController),
            CheckListView(_pageController),
            AgendaView(_pageController),
            PlayListView(_pageController),
            MeusFornecedoresView(_pageController),
            OrcamentoView(_pageController),
            NoticiasView(_pageController),
            LocalCerimoniaView(_pageController),
            QuizView(_pageController),
            ConfiguracaoView(_pageController),
//            BlocoNotasView(_pageController),
//            PostView(_pageController),
//            ProductView(_pageController)
          ],
        )
    );
  }
}
