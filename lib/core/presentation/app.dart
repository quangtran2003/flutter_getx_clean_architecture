import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_getx_clean_architecture/core/presentation/controllers/app_controller.dart';
import 'package:flutter_getx_clean_architecture/core/presentation/widgets/base_get_page.dart';
import 'package:flutter_getx_clean_architecture/generated/locales.g.dart';
import 'package:flutter_getx_clean_architecture/routes/app_pages.dart';
import 'package:flutter_getx_clean_architecture/routes/app_routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

class App extends BaseGetPage<AppController> {
  App({super.key});

  final botToastBuilder = BotToastInit();

  @override
  bool get isAppWidget => true;

  @override
  Widget buildPage(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter GetX Clean Architecture',
      locale: const Locale('vi', 'VN'),
      translationsKeys: AppTranslation.translations,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.advice.path,
      getPages: AppPages.pages,
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('vi', ''),
      ],
      builder: (context, child) {
        return botToastBuilder(context, child);
      },
      navigatorObservers: [BotToastNavigatorObserver()],
    );
  }
}
