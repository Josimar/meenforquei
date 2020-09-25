import 'package:flutter/material.dart';
import 'package:meenforquei/models/convidados_model.dart';
import 'package:meenforquei/models/product_model.dart';
import 'package:meenforquei/models/user_model.dart';
import 'package:meenforquei/ui/views/agenda/agenda_create_view.dart';
import 'package:meenforquei/ui/views/agenda/agenda_detail_view.dart';
import 'package:meenforquei/ui/views/bloconotas/bloco_notas_create_view.dart';
import 'package:meenforquei/ui/views/checklist/check_list_create_view.dart';
import 'package:meenforquei/ui/views/configuracao/configuracao_create_view.dart';
import 'package:meenforquei/ui/views/convidados/meus_convidados_create_view.dart';
import 'package:meenforquei/ui/views/fornecedores/meus_fornecedores_create_view.dart';
import 'package:meenforquei/ui/views/localcerimonia/local_cerimonia_create_view.dart';
import 'package:meenforquei/ui/views/mensagem/mensagem_create_view.dart';
import 'package:meenforquei/ui/views/noticias/noticia_detail_view.dart';
import 'package:meenforquei/ui/views/noticias/noticias_create_view.dart';
import 'package:meenforquei/ui/views/orcamento/orcamento_create_view.dart';
import 'package:meenforquei/ui/views/playlist/play_list_create_view.dart';
import 'package:meenforquei/ui/views/post/post_create_view.dart';
import 'package:meenforquei/ui/views/product/product_create_view.dart';
import 'package:meenforquei/ui/views/product/product_detail_view.dart';
import 'package:meenforquei/ui/views/product/product_edit_view.dart';
import 'package:meenforquei/ui/views/quiz/quiz_create_view.dart';
import 'package:meenforquei/ui/views/quiz/quiz_play_view.dart';

import 'package:meenforquei/utils/route_names.dart';
import 'package:meenforquei/ui/views/signup_view.dart';
import 'package:meenforquei/ui/views/login_view.dart';
import 'package:meenforquei/ui/views/intro_view.dart';
import 'package:meenforquei/ui/views/home_view.dart';

import 'package:meenforquei/models/local_cerimonia_model.dart';

import 'package:meenforquei/models/noticia_model.dart';

import 'package:meenforquei/models/bloco_notas_model.dart';

import 'package:meenforquei/models/check_list_model.dart';

import 'package:meenforquei/models/meus_fornecedores_model.dart';

import 'package:meenforquei/models/meus_convidados_model.dart';

import 'package:meenforquei/models/mensagem_model.dart';

import 'package:meenforquei/models/orcamento_model.dart';

import 'package:meenforquei/models/configuracao_model.dart';

import 'package:meenforquei/models/play_list_model.dart';

import 'package:meenforquei/models/quiz_model.dart';

import 'package:meenforquei/models/agenda_model.dart';

import 'package:meenforquei/models/post_model.dart';
import 'package:meenforquei/utils/utilitarios.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final RouteArguments args = settings.arguments;

  switch (settings.name) {
    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginView(),
      );
    case SignUpViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignUpView(),
      );
    case HomeViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: HomeView(),
      );
    case IntroViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: IntroView(),
      );
    case CreateLocalViewRoute:
      var localToEdit = settings.arguments as LocalCerimoniaModel;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CreateLocalCerimoniaView(
          edittingLocal: localToEdit
        ),
      );
    case CreateNoticiaViewRoute:
      var noticiaToEdit = settings.arguments as NoticiaModel;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CreateNoticiasView(
            edittingNoticia: noticiaToEdit
        ),
      );
    case CreateQuizViewRoute:
      var quizToEdit = settings.arguments as QuizModel;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CreateQuizView(
            edittingQuiz: quizToEdit
        ),
      );
    case CreatePlayListViewRoute:
      var playlistToEdit = settings.arguments as PlayListModel;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CreatePlayListView(
            edittingPlayList: playlistToEdit
        ),
      );
    case CreateBlocoNotasViewRoute:
      var bloconotasToEdit = settings.arguments as BlocoNotasModel;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CreateBlocoNotasView(
            edittingBlocoNotas: bloconotasToEdit
        ),
      );
    case CreateMeusFornecedoresViewRoute:
      var meusfornecedoresToEdit = settings.arguments as MeusFornecedoresModel;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CreateMeusFornecedoresView(
            edittingMeusFornecedores: meusfornecedoresToEdit
        ),
      );

    case CreateOrcamentoViewRoute:
      var orcamentoToEdit = settings.arguments as OrcamentoModel;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CreateOrcamentoView(
            edittingOrcamento: orcamentoToEdit
        ),
      );
    case CreateConfiguracaoViewRoute:
      var configuracaoToEdit = settings.arguments as ConfiguracaoModel;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CreateConfiguracaoView(
            edittingConfiguracao: configuracaoToEdit
        ),
      );
    case CreateMensagemViewRoute:
      var convidadoToMessage = args.systemModel as ConvidadosModel;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CreateMensagemView(
          convidadoModel: convidadoToMessage,
          currentUser: args.userModel
        ),
      );

    case CreateProductViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CreateProductView(),
      );

    case EditProductViewRoute: // ToDo user o Create product view
      var produtoToEdit = args.systemModel as ProductModel;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: EditProductView(
            product: produtoToEdit,
            currentUser: args.userModel
        ),
      );

    case DetailProductViewRoute:
      var produtoToEdit = args.systemModel as ProductModel;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: DetailProductView(
            product: produtoToEdit,
            currentUser: args.userModel
        ),
      );

    case CreateCheckListViewRoute:
      var checklistToEdit = args.systemModel as CheckListModel;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CreateCheckListView(
            edittingCheckList: checklistToEdit
        ),
      );

    case DetailNoticiaViewRoute:
      var noticiaToEdit = args.systemModel as NoticiaModel;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: DetailNoticiasView(
            edittingNoticia: noticiaToEdit
        ),
      );

    case PlayQuizViewRoute:
      var quizToPlay = args.systemModel as QuizModel;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: PlayQuizView(
            edittingQuiz: quizToPlay,
            currentUser: args.userModel
        ),
      );

    case CreatePostViewRoute:
      var postToEdit = args.systemModel as PostModel;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CreatePostView(
            edittingPost: postToEdit,
            currentUser: args.userModel
        ),
      );

    case CreateAgendaViewRoute:
      var agendaToEdit = args.systemModel as AgendaModel;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CreateAgendaView(
            edittingAgenda: agendaToEdit,
            currentUser: args.userModel
        ),
      );
    case DetailAgendaViewRoute:
      var agendaToEdit = args.systemModel as AgendaModel;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: AgendaDetailView(
            edittingAgenda: agendaToEdit
        ),
      );

    case CreateMeusConvidadosViewRoute:
      var meusconvidadosToEdit = args.systemModel as MeusConvidadosModel;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CreateMeusConvidadosView(
            edittingMeusConvidados: meusconvidadosToEdit
        ),
      );

    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
                child: Text('No route defined for ${settings.name}')),
          ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
