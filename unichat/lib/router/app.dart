// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:unichat/page/contact/professorProfileWithStudent.dart';
import 'package:unichat/page/list/professorList.dart';
import 'package:unichat/page/login/login.dart';
import 'package:unichat/page/login/professorLogin.dart';
import 'package:unichat/page/login/studentLogin.dart';
import 'package:unichat/page/map.dart';
import 'package:unichat/page/profile/professorProfile.dart';
import 'package:unichat/page/profile/studentProfile.dart';
import 'package:unichat/page/reserve/studentReservation.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'UniChat',
        initialRoute: '/map',
        routes: {
          '/login' : (BuildContext context) => LoginPage(),
          '/map' : (BuildContext context) => const MapPage(),
          '/professor/profile' : (BuildContext context) => ProfessorProfile(),
          '/professor/login' : (BuildContext context) => ProfessorLoginPage(),
          '/student/login' : (BuildContext context) => StudentLoginPage(),
          '/student/profile' : (BuildContext context) => StudentProfile(),
          '/test' : (BuildContext context) => const ProfessorList(),
          '/professor/student' : (BuildContext context) => const ProfessorProfileWithStudent(),
          '/reservation/student' : (BuildContext context) => const StudentReservation(),
        },
        theme: ThemeData.light(useMaterial3: true),
      );
  }
}

