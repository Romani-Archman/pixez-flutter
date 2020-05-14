import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pixez/generated/i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'user_setting.g.dart';

class UserSetting = _UserSettingBase with _$UserSetting;

abstract class _UserSettingBase with Store {
  SharedPreferences prefs;
  static const String ZOOM_QUALITY_KEY = "zoom_quality";

  @observable
  int zoomQuality = 0;
  @observable
  int languageNum = 0;
  @observable
  String path = "";
  @action
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    zoomQuality = prefs.getInt(ZOOM_QUALITY_KEY) ?? 0;
    path = prefs.getString("store_path") ??
        (await getExternalStorageDirectory()).path + '/pxez';
    languageNum = prefs.getInt("language_num") ?? 0;
    I18n.onLocaleChanged(I18n.delegate.supportedLocales[languageNum]);
  }

  @action
  Future<String> getPath() async {
    path = prefs.getString("store_path");
    return path;
  }

  @action
  setPath(result) {
    path = result;
  }

  @action
  setLanguageNum(int value) async {
    await prefs.setInt("language_num", value);
    languageNum = value;
    I18n.onLocaleChanged(I18n.delegate.supportedLocales[languageNum]);
  }

  @action
  Future<void> change(int value) async {
    await prefs.setInt(ZOOM_QUALITY_KEY, value);
    zoomQuality = value;
  }
}