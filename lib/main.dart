import 'package:aimimi/models/user.dart';
import 'package:aimimi/providers/goals_provider.dart';
import 'package:aimimi/services/goal_service.dart';
import 'package:aimimi/constants/styles.dart';
import 'package:aimimi/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/goal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'aimimi',
      theme: ThemeData(
        // Default colors
        primaryColor: Colors.white,
        accentColor: themeColor,
        scaffoldBackgroundColor: backgroundTintedColor,
        canvasColor: Colors.transparent,

        // Default font
        fontFamily: "Roboto",
        // textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
      ),
      debugShowCheckedModeBanner: false,
      // home: MainView(),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<GoalsProvider>(
            create: (_) => GoalsProvider(),
          ),
          StreamProvider<List<Goal>>.value(
            initialData: [],
            value: GoalService().goals,
          ),
          StreamProvider<List<UserGoal>>.value(
            initialData: [],
            value: GoalService(
                    uid: FirebaseAuth.instance.currentUser != null
                        ? FirebaseAuth.instance.currentUser.uid
                        : null)
                .userGoals,
          ),
        ],
        child: LoginView(),
      ),
    );
  }
}
