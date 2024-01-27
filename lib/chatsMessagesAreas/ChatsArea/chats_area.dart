import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_web_clone/chatsMessagesAreas/ChatsArea/contacts_list.dart';
import 'package:whatsapp_web_clone/chatsMessagesAreas/ChatsArea/recent_chats.dart';
import 'package:whatsapp_web_clone/default_color/default_color.dart';
import 'package:whatsapp_web_clone/models/user_models.dart';
class ChatArea extends StatefulWidget {

  final UserModel currentUserData;
  ChatArea({super.key, required this.currentUserData});

  @override
  State<ChatArea> createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child:Container(
          decoration: const BoxDecoration(
            color: DefaultColor.lightBarBackgroundColor,
            border: Border(
              right: BorderSide(
                color: DefaultColor.backgroundColor,
              )
            )
          ),
          child: Column(
            children: [

              // header
              Container(
                color: DefaultColor.backgroundColor,
                padding:const EdgeInsets.all(8),
                child: Row(
                  children: [

                    CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(
                        widget.currentUserData.image
                      ),
                    ),

                   const SizedBox(width: 12,),

                    Text(widget.currentUserData.name,
                      style:const TextStyle(
                          fontWeight: FontWeight.bold),),

                   const Spacer(),

                    IconButton(
                        onPressed: ()async{
                          await FirebaseAuth.instance.signOut().then((value){
                            Navigator.pushReplacementNamed(context, "/login");
                          });
                        },
                        icon:const Icon(Icons.logout))
                  ],
                ),
              ),

            //   2 Tabs button
              const TabBar(
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.black,
                  indicatorColor: DefaultColor.primaryColor,
                  indicatorWeight: 2,
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight:FontWeight.bold,
                  ),
                  tabs: [
                    Tab(
                      text: "Chats",
                    ),
                    Tab(
                      text: "Contacts",
                    )
                  ],
              ),

              Expanded(
                child: Container(
                color: Colors.white,
                child:const TabBarView(
                  children: [
                  // show Chats
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: RecentChats(),
                    ),

                  // show contacts list
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: ContactsList(),
                    ),
                  ],
                ),
              ),
              ),
            ],
          ),
        ),
    );
  }
}

