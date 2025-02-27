import 'package:aimimi/models/user.dart';
import 'package:aimimi/services/auth_service.dart';
import 'package:aimimi/services/goal_service.dart';
import 'package:aimimi/constants/styles.dart';
import 'package:aimimi/views/auth/login_view.dart';
import 'package:aimimi/views/main_view.dart';
import 'package:aimimi/widgets/background_painter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<OurUser>.value(
          initialData: null,
          value: AuthService().user,
        ),
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(),
        )
      ],
      child: MaterialApp(
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

          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        debugShowCheckedModeBanner: false,
        // home: MainView(),
        home: Authenticate(),
      ),
    );
  }
}

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isSigningIn = Provider.of<AuthService>(context).isSigningIn;
    OurUser auth = Provider.of<OurUser>(context);

    if (isSigningIn) {
      return buildLoading();
    } else if (auth != null) {
      return MultiProvider(
        providers: [
          StreamProvider<List<UserGoal>>.value(
            initialData: [],
            value:
                GoalService(uid: Provider.of<OurUser>(context).uid).userGoals,
          ),
          StreamProvider<List<String>>.value(
            initialData: [],
            value: GoalService(uid: Provider.of<OurUser>(context).uid)
                .completedGoals,
          ),
        ],
        child: MainView(),
      );
    } else {
      return LoginView();
    }
  }

  Widget buildLoading() => Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: BackgroundPainter()),
          Center(child: CircularProgressIndicator()),
        ],
      );
}
