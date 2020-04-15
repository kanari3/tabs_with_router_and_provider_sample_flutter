import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: tabRoute,
      onGenerateRoute: Router.generateRoute,
    );
  }
}

// router class
const String tabRoute = '/tabs';
const String tempRoute = '/temp'; // no use in routing
const String homeRoute = '/home';
const String nextRoute = '/next';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(
            settings: RouteSettings(name: homeRoute),
            builder: (_) => ChangeNotifierProvider(
              create: (context) => HomeModel(),
              child: HomeScreen(),
            ));
      case nextRoute:
        var data = settings.arguments as String;
        return MaterialPageRoute(
            settings: RouteSettings(name: nextRoute),
            builder: (_) => ChangeNotifierProvider(
              create: (context) => NextModel(),
              child: NextScreen(data),
            ));
      case tabRoute:
        return MaterialPageRoute(
          settings: RouteSettings(name: tabRoute),
          builder: (_) => TabScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                  child: Text('No route defined for ${settings.name}')),)
        );
    }
  }
}

// Tab class
class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: SafeArea(
          child: TabBar(
            tabs: [
              Tab(text: 'tab1'),
              Tab(text: 'tab2'),
            ],
            controller: _tabController,
            indicator: UnderlineTabIndicator(),
            unselectedLabelColor: Colors.green,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
            labelColor: Colors.blue,
          ),
        ),
        body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              TempScreen(),
              HomeScreen(), // I think fault here.
            ]
        )
    );
  }
}

// temporary screen
class TempScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlueAccent,
      child: Center(
        child: Text('Temporary screen'),
      ),
    );
  }
}

// screen1
class HomeModel with ChangeNotifier {}
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeModel>(
      builder: (context, model, _) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, nextRoute, arguments: 'hoge');
            },
          ),
          body: Center(child: Text('Tab2 Screen')),
        );
      },
    );
  }
}

// screen2
class NextModel with ChangeNotifier{}
class NextScreen extends StatelessWidget {
  final String data;
  NextScreen(this.data);

  @override
  Widget build(BuildContext context) {
    return Consumer<NextModel>(
      builder: (context, model, _) {
        return Scaffold(
          body: Center(child: Text('NextScreen received: ${data}')),
        );
      },
    );
  }
}
