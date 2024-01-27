import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_web_clone/models/user_models.dart';
import 'package:whatsapp_web_clone/webPages/home_page.dart';
import 'package:whatsapp_web_clone/webPages/login_sighup_page.dart';
import 'package:whatsapp_web_clone/webPages/message_page.dart';

class RoutesForWebPages{
  static Route<dynamic> createRoutes(RouteSettings settingsRoute)
  {
    final arguments = settingsRoute.arguments;

    switch(settingsRoute.name)
    {
      case "/":
        return MaterialPageRoute(builder: (_)=>const LoginSighupPage());
      case "/login":
        return MaterialPageRoute(builder: (_)=>const LoginSighupPage());
      case "/home":
        return MaterialPageRoute(builder: (_)=>const HomePage());
      case "/messages":
        return MaterialPageRoute(builder: (_)=> MessagePage(arguments as UserModel));
    }

    return errorPageRoute();
  }

  static Route<dynamic> errorPageRoute()
  {
    return MaterialPageRoute(builder: (_)
    {
      return Scaffold(
        appBar: AppBar(title: Text("Web Page not found."),
        ),
        body: Center(
          child: Text("Web Page not found."),
        ),
      );
    });
  }
}