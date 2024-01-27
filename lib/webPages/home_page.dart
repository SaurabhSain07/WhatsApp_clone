import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_web_clone/chatsMessagesAreas/ChatsArea/chats_area.dart';
import 'package:whatsapp_web_clone/chatsMessagesAreas/messages_area.dart';
import 'package:whatsapp_web_clone/default_color/default_color.dart';
import 'package:whatsapp_web_clone/models/user_models.dart';
import 'package:whatsapp_web_clone/widgets/notification_dialog_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late UserModel currentUserData;
  String? _token;
  Stream<String>? _tokenStream;

  readCurrentUserData()async
  {
    User? currentFirebaseUser = FirebaseAuth.instance.currentUser;
    if(currentFirebaseUser !=null)
    {
      String uid=currentFirebaseUser.uid;
      String name=currentFirebaseUser.displayName ?? "";
      String email=currentFirebaseUser.email ?? "";
      String password="";
      String image=currentFirebaseUser.photoURL ?? "";

      currentUserData = UserModel(uid, name, email, password , image: image);
    }
     await getPermissionNotifications();
    await pushNotificationMessageListener();

    await FirebaseMessaging.instance.getToken().then((setTokenNow));

    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream!.listen((setTokenNow));

    await saveTokenToUserInfo();
  }

  getPermissionNotifications()async
  {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  pushNotificationMessageListener()
  {
    FirebaseMessaging.onMessage.listen((RemoteMessage message)
    {
      if(message.notification !=null)
      {
        showDialog(
            context: context,
            builder: ((BuildContext context)
            {
              return NotificationDialogWidgets(
                titleText: message.notification!.title,
                body: message.notification!.body,
              );
            })
        );
      }
    });
  }

  setTokenNow(String? token)
  {
    print("\n\n FMC User Recognition Token ${token.toString()}");

    setState(() {
      _token=token;
    });
  }

  saveTokenToUserInfo()async
  {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid).update(
        {
          "token": _token,
        });
  }

 @override
  void initState() {
    // TODO: implement initState
    super.initState();

    readCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: DefaultColor.lightBarBackgroundColor,
        child: Stack(
          children: [
            Positioned(
              top: 0,
                child: Container(
                  color: DefaultColor.primaryColor,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.2,
                ),
            ),

            Positioned(
              top: MediaQuery.of(context).size.height*0.05,
              bottom: MediaQuery.of(context).size.height*0.05,
              left: MediaQuery.of(context).size.height*0.05,
              right: MediaQuery.of(context).size.height*0.05,
                child: Row(
                  children: [
                  //  chatting area
                    Expanded(
                      flex: 4,
                      child: ChatArea(
                        currentUserData: currentUserData,
                      ),
                    ),

                  //   MessageArea
                    Expanded(
                      flex: 10,
                      child: MessagesArea(
                        currentUserData: currentUserData,
                      ),
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}
