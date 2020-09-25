import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meenforquei/locator.dart';
import 'package:meenforquei/services/dialog_service.dart';
import 'package:meenforquei/services/event_bus.dart';
import 'package:meenforquei/services/navigation_service.dart';
import 'package:meenforquei/ui/router.dart';
import 'package:meenforquei/ui/views/startup_view.dart';
import 'package:meenforquei/utils/dialog_manager.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/viewmodel/agenda_view_model.dart';
import 'package:meenforquei/viewmodel/check_list_view_model.dart';
import 'package:meenforquei/viewmodel/mensagem_view_model.dart';
import 'package:meenforquei/viewmodel/meus_convidados_view_model.dart';
import 'package:meenforquei/viewmodel/post_view_model.dart';
import 'package:meenforquei/viewmodel/product_view_model.dart';
import 'package:meenforquei/viewmodel/quiz_view_model.dart';
import 'package:meenforquei/viewmodel/tarefas_view_model.dart';
import 'package:provider/provider.dart';
import 'models/user_model.dart';
import 'dart:io';

void main() async {
  // Register all the models and services before the app starts
  setupLocator();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(PrincipalApp());
  //runApp(PrincipalApp(userModel: UserModel()));
}

class PrincipalApp extends StatelessWidget {
  final UserModel userModel;
  const PrincipalApp({Key key, this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    /*
    final ThemeData temaIOS = ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.grey,
        accentColor: Colors.teal,
        fontFamily: 'Lato',
        brightness: Brightness.light, // isDark ? Brightness.dark : Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Anton',
        )
    );
    */
    final ThemeData temaAndroid = ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: Color.fromARGB(255, 4, 125, 141),
      accentColor: Colors.teal,
      fontFamily: 'Lato',
      brightness: Brightness.light, // isDark ? Brightness.dark : Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: Theme.of(context).textTheme.apply(
        fontFamily: 'Lato',
      )
    );


    return MultiProvider(
      providers: [
        Provider<EventBus>(
          create: (context) => EventBus(),
          dispose: (context, bus) => bus.dispose(),
        ),
        ChangeNotifierProvider<AgendaViewModel>(create: (_) => AgendaViewModel()),
        ChangeNotifierProvider<MeusConvidadosViewModel>(create: (_) => MeusConvidadosViewModel()),
        ChangeNotifierProvider<TarefasViewModel>(create: (_) => TarefasViewModel()),
        ChangeNotifierProvider<MensagensViewModel>(create: (_) => MensagensViewModel()),
        ChangeNotifierProvider<CheckListViewModel>(create: (_) => CheckListViewModel()),
        ChangeNotifierProvider<QuizViewModel>(create: (_) => QuizViewModel()),
        ChangeNotifierProvider<PostViewModel>(create: (_) => PostViewModel()),
        ChangeNotifierProvider<ProductViewModel>(create: (_) => ProductViewModel()),
      ],
      child: MaterialApp(
        title: MEString.name,
        builder: (context, child) => Navigator(
          key: locator<DialogService>().dialogNavigationKey,
          onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => DialogManager(child: child)
          ),
        ),
        navigatorKey: locator<NavigationService>().navigationKey,
        theme: Platform.isIOS ? temaAndroid : temaAndroid,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: generateRoute,
        home: StartUpView(),
      ),
    );

  }
}
