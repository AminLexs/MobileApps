import 'package:flutter/material.dart';
import 'package:laba3/models/locale.modal.dart';
import 'package:laba3/models/theme.model.dart';
import 'package:laba3/models/user.modal.dart';
import 'package:provider/provider.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';


class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Locale _lang = Locale.en;

  void _handleLogoutTap() {
    Provider.of<UserModel>(context, listen: false).toggleIsLoggedIn();
  }

  void _onLangChanged(Locale value) {
    setState(() {
      _lang = value;
    });
    Provider.of<LocaleModel>(context, listen: false).setLocale(value);
  }

  void _onThemeChanged(bool isDark) {
    isDark
        ? Provider.of<ThemeModel>(context, listen: false).setDarkMode()
        : Provider.of<ThemeModel>(context, listen: false).setLightMode();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(Provider.of<LocaleModel>(context).getString("settings")),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10.0, top: 20.0),
              child: InkWell(

                onTap: _handleLogoutTap,
                child:
                Text(Provider.of<LocaleModel>(context).getString("logout")),/*Icon(
                  Icons.logout,
                ),*/
              ),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Provider.of<LocaleModel>(context).getString("lang")),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Radio<Locale>(
                            value: Locale.ru,
                            groupValue: _lang,
                            onChanged: _onLangChanged,
                          ),
                          Text(Provider.of<LocaleModel>(context)
                              .getString("lang_ru")),
                          Radio<Locale>(
                            value: Locale.en,
                            groupValue: _lang,
                            onChanged: _onLangChanged,
                          ),
                          Text(Provider.of<LocaleModel>(context)
                              .getString("lang_en")),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Provider.of<LocaleModel>(context)
                      .getString("dark_theme")),
                  Switch(
                      value: Provider.of<ThemeModel>(context).isDark,
                      onChanged: _onThemeChanged),
                ],
              ),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      Provider.of<LocaleModel>(context).getString("font_size")),
                  Slider(
                      value: Provider.of<ThemeModel>(context).fontSize,
                      onChanged: Provider.of<ThemeModel>(context).setFontSize,
                      max: 28,
                      min: 14)
                ],
              )
            ],
          ),
        ));
  }
}






























/*






 final _colorController = CircleColorPickerController(
      initialColor: Provider.of<ThemeModel>(context)
          .getMainColor(),
    );



 SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Provider.of<LocaleModel>(context)
                      .getString("primary_colour")),
                  ElevatedButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(Provider.of<LocaleModel>(context)
                              .getString("primary_colour")),
                          content: SingleChildScrollView(
                            child: CircleColorPicker(
                                controller: _colorController,
                             // initialColor: Provider.of<ThemeModel>(context)
                                //  .getMainColor(),
                                onChanged:
                              Provider.of<ThemeModel>(context)
                                  .setMainColor,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(Provider.of<LocaleModel>(context)
                                  .getString("select")),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                      child: Text(Provider.of<LocaleModel>(context)
                          .getString("select"))),
                ],
              ),
              */