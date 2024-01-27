import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_web_clone/models/user_models.dart';
import 'package:whatsapp_web_clone/widgets/message_widgets.dart';

class MessagePage extends StatefulWidget {
  final UserModel toUserData;
   MessagePage(
       this.toUserData,
       {Key? key}
       ) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {

  late UserModel toUser;
  late UserModel fromUser;

  getUserData(){
    toUser=widget.toUserData;

    User? loggedInUser = FirebaseAuth.instance.currentUser;

    if(loggedInUser !=null){
      fromUser = UserModel(
        loggedInUser.uid,
        loggedInUser.displayName ?? "",
        loggedInUser.email ?? "",
        "",
        image: loggedInUser.photoURL ?? "",
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [

            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(toUser.image),
            ),

            const SizedBox(
              width: 8,
            ),

            Text(
              toUser.name,
              style:const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            )
          ],
        ),
        actions:const [
          Icon(
            Icons.more_vert
          )
        ],
      ),

     body: SafeArea(
       child: MessageWidgets(
         fromUserData: fromUser,
         toUserData: toUser,
       ),
     ),
    );
  }
}
