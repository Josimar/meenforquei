import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meenforquei/ui/widgets/custom_drawer.dart';
import 'package:meenforquei/utils/meenforquei.dart';

class TesteTab extends StatefulWidget {
  final PageController pageController;

  TesteTab(this.pageController);

  @override
  _TesteTabState createState() => _TesteTabState();
}

/*
Widget _screenMain(BuildContext context){
  return Container(
    child: Column(
      children: <Widget>[
        Text("Tela escura: "),
        CustomSwitchWidget(),
        Text("Exibe a tela de ajuda: "),
        CustomSwitchIntroWidget()
      ],
    )
  );
}
*/

class _TesteTabState extends State<TesteTab> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signIn() async{
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    var authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    print("User Name: ${user.displayName}");
    return user;
  }

  void _signOut(){
    googleSignIn.signOut();
  }

  var _perguntaSelecionada = 0;
  var _pontuacaoTotal = 0;

  void _responder(int pontuacao){
    if (temPerguntaSelecionada){
      setState((){
        _perguntaSelecionada++;
        _pontuacaoTotal += pontuacao;
      });
    }
  }

  final List<Map<String, Object>> _perguntas = const [
    {
      'texto': 'Qual é a sua cor favorita?',
      'respostas': [
        {'texto': 'Preto', 'nota': 10},
        {'texto': 'Vermelho', 'nota': 9},
        {'texto': 'Branco', 'nota': 8},
        {'texto': 'Verde', 'nota': 7}]
    },{
      'texto': 'Qual é o seu animal favorito?',
      'respostas': [
        {'texto': 'Coelho','nota': 6},
        {'texto': 'Cobra','nota': 5},
        {'texto': 'Elefante','nota': 4},
        {'texto': 'Girafa','nota': 3}]
    },{
      'texto': 'Nome mais diferente?',
      'respostas': [
        {'texto': 'Zeca','nota': 2},
        {'texto': 'Zica','nota': 1},
        {'texto': 'Zoca','nota': 0},
        {'texto': 'Zufo','nota': -1}
      ]
    }
  ];

  void _reiniciarQuestionario(){
    setState((){
      _perguntaSelecionada = 0;
      _pontuacaoTotal = 0;
    });
  }

  bool get temPerguntaSelecionada{
    return _perguntaSelecionada < _perguntas.length;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(widget.pageController),
      appBar: AppBar(
        title: Text(MEString.textoTeste),
        centerTitle: true,
      ),
      // body: _screenMain(context),
      body: temPerguntaSelecionada
          ? Questionario(
              perguntas: _perguntas,
              perguntaSelecionada: _perguntaSelecionada,
              responder: _responder
          )
          : Resultado(_pontuacaoTotal, _reiniciarQuestionario),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        icon: const Icon(Icons.add),
        label: const Text('Add a task'),
        onPressed: () {
          _signIn().then((FirebaseUser user){
            print(user);
          }).catchError((e){
            print(e);
          });
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: Icon(Icons.exit_to_app), onPressed: _signOut),
            IconButton(icon: Icon(Icons.search), onPressed: () {},),
          ],
        ),
      ),

      // bottomBar: Checar necessidade do buttom bar

    );

  }
}

class Questao extends StatelessWidget {
  final String texto;
  Questao(this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // tamanho máximo
      margin: EdgeInsets.all(10),
      child: Text(
        texto,
        style: TextStyle(fontSize: 28)
      ),
    );
  }
}

class Resposta extends StatelessWidget {
  final String texto;
  final void Function() onSelecao;

  Resposta(this.texto, this.onSelecao);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        textColor: Colors.white,
        color: Colors.blue,
        child: Text(texto),
        onPressed: onSelecao,
      ),
    );
  }
}

class Resultado extends StatelessWidget {

  final int pontuacao;
  final void Function() onReiniciarQuestionario;
  Resultado(this.pontuacao, this.onReiniciarQuestionario);

  String get fraseResultado{
    if (pontuacao < 8){
      return 'Parabéns!';
    }else if (pontuacao < 12){
      return 'Você é bom!';
    }else if (pontuacao < 16){
      return 'Impressionante!';
    }else{
      return 'Nível Jedi!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text(fraseResultado, style: TextStyle(fontSize: 28)),
        ),
        FlatButton(
          child: Text("Reiniciar", style: TextStyle(fontSize: 18)),
          textColor: Colors.blue,
          onPressed: onReiniciarQuestionario,
        )
      ]
    );
  }
}

class Questionario extends StatelessWidget {
  final List<Map<String, Object>> perguntas;
  final int perguntaSelecionada;
  final void Function(int) responder;

  Questionario({this.perguntas, this.perguntaSelecionada, this.responder});

  bool get temPerguntaSelecionada{
    return perguntaSelecionada < perguntas.length;
  }

  @override
  Widget build(BuildContext context) {

    List<Map<String, Object>> respostas = temPerguntaSelecionada
        ? perguntas[perguntaSelecionada]['respostas']
        : null;

    return Column(
      children: <Widget>[
        // Questao(perguntas.elementAt(perguntaSelecionada)['texto']),
        Questao(perguntas[perguntaSelecionada]['texto']),
        ...respostas.map((resp) => Resposta(
            resp['texto'],
            () => responder(resp['nota'])
        )).toList(),
      ],
    );
  }
}
