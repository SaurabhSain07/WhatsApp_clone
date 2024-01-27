import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_web_clone/default_color/default_color.dart';
import 'package:whatsapp_web_clone/models/user_models.dart';
import 'package:whatsapp_web_clone/provider/chat_provider.dart';
import 'package:whatsapp_web_clone/widgets/message_widgets.dart';

class MessagesArea extends StatefulWidget {
  final UserModel currentUserData;
   MessagesArea({super.key, required this.currentUserData});

  @override
  State<MessagesArea> createState() => _MessagesAreaState();
}

class _MessagesAreaState extends State<MessagesArea> {
  @override
  Widget build(BuildContext context) {

    UserModel? toUserData = context.watch<ProviderChat>().toUserData;

    return toUserData==null
        ? Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Center(
        child: Image.asset("images/whatsapp.png"),
      ),
    )
        : Column(
          children: [

            // header
            Container(
              color: DefaultColor.barBackgruondColor,
              padding:const EdgeInsets.all(8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(toUserData.image),
                  ),
                  const SizedBox(width: 8,),

                  Text(
                    toUserData.name,
                    style:const TextStyle(
                      fontSize: 16
                    ),
                  ),
                  const Spacer(),

                  const Icon(
                      Icons.search
                  ),

                  const Icon(
                      Icons.more_vert,
                  ),
                ],
              ),
            ),

           // messages list
            Expanded(
                child: MessageWidgets(
                  fromUserData: widget.currentUserData,
                  toUserData: toUserData,
                )
            )
          ],
         );
  }
}
