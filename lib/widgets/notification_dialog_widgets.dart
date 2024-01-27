import 'package:flutter/material.dart';

class NotificationDialogWidgets extends StatefulWidget {

  final titleText;
  final body;

 const NotificationDialogWidgets({super.key, this.titleText, this.body});

  @override
  State<NotificationDialogWidgets> createState() => _NotificationDialogWidgetsState();
}

class _NotificationDialogWidgetsState extends State<NotificationDialogWidgets> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.titleText),
      actions: [
        OutlinedButton.icon(
            onPressed: ()
            {
              Navigator.pop(context);
            },
            label:const Text("Close"),
            icon:const Icon(Icons.close),
        ),
      ],
      content: widget.body.toString().contains(".jpg")
      ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
           const Text("Send you Image."),
           const SizedBox(
              height: 14,
            ),
            Padding(
                padding:const EdgeInsets.all(18.0),
                child: Image.network(
                  widget.body.toString(),
                  width: 160,
                  height: 160,
               ),
            ),
          ],
        )
          : widget.body.toString().contains(".docx")
          || widget.body.toString().contains(".pptx")
          || widget.body.toString().contains(".xlsx")
          || widget.body.toString().contains(".pdf")
          || widget.body.toString().contains(".mp3")
          || widget.body.toString().contains(".mp4")
      ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Send you File."),
          const SizedBox(
            height: 14,
          ),
          Padding(
            padding:const EdgeInsets.all(18.0),
            child: Image.asset(
              "images/file.png",
              width: 160,
              height: 160,
            ),
          ),
        ],
        )
      : Text(widget.body),
    );
  }
}
