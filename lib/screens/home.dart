import 'package:flutter/material.dart';
import '../settings.dart';
import '../utils.dart';
class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  static const routeName = '/home';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messengerKey,
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: (int val) {
            _messengerKey.currentState!.showSnackBar(
                SnackBar(content: Text("bottom navbar tapped ${val.toString()}")));
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.access_alarm),
              label: "Item 0",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box_outlined),
              label: "Item 1",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.volunteer_activism),
              label: "Item 2",
            ),
          ],
        ),
        appBar: AppBar(
          title: const Text("Case 3.1"),
          actions: [
            IconButton(
              onPressed: (){
                _messengerKey.currentState!.showSnackBar(
                    const SnackBar(content: Text("Icons.account_circle")));
              },
              icon: Icon(Icons.account_circle),
              tooltip: 'Show Snackbar',
            ),
            IconButton(
              onPressed: () {
                _messengerKey.currentState!.showSnackBar(
                    const SnackBar(content: Text("Icons.add_box")));
              },
              icon: Icon(Icons.add_box),
              tooltip: 'Show Snackbar',
            ),
            TextButton(
              onPressed: (){
                _messengerKey.currentState!.showSnackBar(
                    const SnackBar(content: Text("Logout")));
                Navigator.of(context).pushNamedAndRemoveUntil(Settings().routeStartScreen, (route) => false);
              },
              child: Text("Logout",
                style: TextStyle(
                  color: Colors.white,
                ),),),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Container(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(50.0))
                          ),
                          child: const Image(image: AssetImage("assets/images/Google-flutter-logo.svg.png")), //Image.network("url"),
                        ),
                        Text("Авторизованный пользователь",
                          style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF)),),
                      ],
                    ),
                  )
              ),
              ListTile(
                  leading: const Icon(Icons.one_k),
                  title: const Text ("Каталог"),
                  onTap: (){
                    _messengerKey.currentState!.showSnackBar(
                        const SnackBar(content: Text("Переход в каталог")));
                    Navigator.pushNamed(context, '/catalog');
                  }
              ),
              ListTile(
                  leading: const Icon(Icons.two_k),
                  title: const Text ("Корзина"),
                  onTap: (){
                    _messengerKey.currentState!.showSnackBar(
                        const SnackBar(content: Text("Переход в корзину")));

                  }
              ),
              const Divider(  ),
              const Padding(padding: EdgeInsets.only(left: 10),
                child: Text("Профиль"),
              ),
              ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text ("Настройки"),
                  onTap: (){
                    _messengerKey.currentState!.showSnackBar(
                        const SnackBar(content: Text("Переход в настройки")));
                    Navigator.pushNamed(context, '/settings');
                  }
              ),
              const Divider(  ),
              Text ("Инструкция\n ..."),

            ],
          ),
        ),
      ),
    );
  }
} //HomeScreen