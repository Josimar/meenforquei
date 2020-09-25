import 'package:meenforquei/interfaces/shared_storage_interface.dart';
import 'package:meenforquei/models/app_config_model.dart';

class AppViewModel{

  final ISharedStorage storage;
  final AppConfigModel config = AppConfigModel();

  AppViewModel({this.storage});

  Future init() async {
    await storage.get('viewIntro').then((value){
      config.viewIntroScreen.value = true;
      if (value != null){
        config.viewIntroScreen.value = value;
      }
    });
  }

  changeViewIntro(bool value){
    config.viewIntroScreen.value = value;
    storage.put('viewIntro', value);
  }

}