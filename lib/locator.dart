import 'package:get_it/get_it.dart';

import 'package:meenforquei/services/authentication_service.dart';
import 'package:meenforquei/services/convidados_service.dart';
import 'package:meenforquei/services/mensagem_service.dart';
import 'package:meenforquei/services/navigation_service.dart';
import 'package:meenforquei/services/dialog_service.dart';

import 'package:meenforquei/services/firestore_service.dart';

import 'package:meenforquei/services/agenda_service.dart';
import 'package:meenforquei/services/check_list_service.dart';
import 'package:meenforquei/services/quiz_service.dart';
import 'package:meenforquei/services/post_service.dart';
import 'package:meenforquei/services/product_service.dart';
import 'package:meenforquei/services/tarefa_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => FirestoreService());

  locator.registerLazySingleton(() => AgendaService());
  locator.registerLazySingleton(() => ConvidadosService());
  locator.registerLazySingleton(() => TarefaService());
  locator.registerLazySingleton(() => MessageService());
  locator.registerLazySingleton(() => CheckListService());
  locator.registerLazySingleton(() => QuizService());
  locator.registerLazySingleton(() => PostService());
  locator.registerLazySingleton(() => ProductService());
}
