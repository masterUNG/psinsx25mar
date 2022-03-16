import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:psinsx/models/worktime_model.dart';
import 'package:psinsx/offlineMode/home_offline.dart';
import 'package:psinsx/pages/home_page.dart';
import 'package:psinsx/pages/insx_page.dart';
import 'package:psinsx/pages/map_dmsx.dart';
import 'package:psinsx/pages/out_time.dart';
import 'package:psinsx/pages/signin_page.dart';
import 'package:psinsx/pages/wait_work.dart';
import 'package:psinsx/pages/worktime.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> map = {
  '/homePage': (BuildContext context) => HomePage(),
  '/signIn': (BuildContext context) => SignIn(),
  '/insxPage': (BuildContext context) => InsxPage(),
  '/homeOffline': (BuildContext context) => HomeOffline(),
  '/mapDmsx': (BuildContext context) => Mapdmsx(),
  '/workTime': (BuildContext context) => WorkTime(),
  '/outTime': (BuildContext context) => OutTime(),
  '/waitWork': (BuildContext context) => WaitWork(),
};

String initialRount;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String string = preferences.getString('id');
  print('string ===>> $string');

  if (string?.isEmpty ?? true) {
    initialRount = '/signIn';
    runApp(MyApp());
  } else {
    initialRount = '/homePage';
    runApp(MyApp());
  }

  // if (string?.isEmpty ?? true) {
  //   initialRount = '/signIn';
  //   runApp(MyApp());
  // } else {
  //   DateTime dateTime = DateTime.now();
  //   DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  //   var currentDate = dateFormat.format(dateTime).toString();
  //   print('@@create_by $string \n @@ currentDate == $currentDate');

  //   var workTimeModels = <WorkTimeModel>[];

  //   String path =
  //       'https://pea23.com/apipsinsx/getWorktimeWhereUser.php?isAdd=true&create_by=$string';
  //   await Dio().get(path).then((value) {
  //     for (var item in json.decode(value.data)) {
  //       WorkTimeModel model = WorkTimeModel.fromMap(item);
  //       workTimeModels.add(model);
  //     }
  //   });

  //   print('lastDate ==>> ${workTimeModels[0].dat_work}');

  //   if (currentDate == workTimeModels[0].dat_work) {
  //     if (workTimeModels[0].out_work_image.isEmpty) {
  //       initialRount = '/homePage';
  //       runApp(MyApp());
  //     } else {
  //       initialRount = '/waitWork';
  //       runApp(MyApp());
  //     }
  //   } else {
  //     initialRount = '/workTime';
  //     runApp(MyApp());
  //   }
  // } // end if
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'สดุดียี่สิบสาม',
      theme: ThemeData(
          fontFamily: 'Prompt',
          brightness: Brightness.dark,
          primaryColor: Color(0xff6a1b9a),
          accentColor: Color(0xff6a1b9a),
          textTheme: TextTheme(
            headline5: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            bodyText2: TextStyle(fontSize: 18),
          )),
      debugShowCheckedModeBanner: false,
      routes: map,
      initialRoute: initialRount,
    );
  }
}
