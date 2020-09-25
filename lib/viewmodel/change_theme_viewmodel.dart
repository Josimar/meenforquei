import 'package:meenforquei/interfaces/shared_storage_interface.dart';
import 'package:meenforquei/models/app_config_model.dart';

class ChangeThemeViewModel{

  final ISharedStorage storage;
  final AppConfigModel config = AppConfigModel();

  ChangeThemeViewModel({this.storage});

  Future init() async {
    await storage.get('isDark').then((value){
      if (value != null)
        config.themeSwitch.value = value;
    });
  }

  changeTheme(bool value){
    config.themeSwitch.value = value;
    storage.put('isDark', value);
  }

}