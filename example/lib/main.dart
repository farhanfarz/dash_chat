import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dash_chat/dash_chat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  final ChatUser user = ChatUser(
    name: "Fayeed",
    uid: "123456789",
    avatar: "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
  );

  final ChatUser otherUser = ChatUser(
    name: "Mrfatty",
    uid: "25649654",
  );

  List<ChatMessage> messages = <ChatMessage>[
    ChatMessage(
      text: "Hello",

      user: ChatUser(
        name: "Fayeed",
        uid: "123456789",
      ),
      createdAt: DateTime.now(),
      // image: "http://www.sclance.com/images/picture/Picture_753248.jpg",
    ),
    ChatMessage(
      text: "This is a quick reply example.",
      user: ChatUser(
        name: "Mrfatty",
        uid: "25649654",
      ),
      createdAt: DateTime.now(),
      payloadType: PayloadType.quickReplies,
      buttons: <Reply>[
        Reply(
          title: "How to",
          value: "How to",
          iconPath:
              "https://silxdigital.com/wp-content/uploads/2019/09/digital-ads-promo-icon.png",
        ),
        Reply(
          title: "Check rates",
          value: "Check rates",
          iconPath:
              "https://silxdigital.com/wp-content/uploads/2019/09/digital-ads-promo-icon.png",
        ),
        Reply(
          title: "Set alert",
          value: "Set alert",
          iconPath:
              "https://silxdigital.com/wp-content/uploads/2019/09/digital-ads-promo-icon.png",
        ),
        Reply(
          title: "Disable alert",
          value: "Disable alert",
          iconPath:
              "https://silxdigital.com/wp-content/uploads/2019/09/digital-ads-promo-icon.png",
        ),
      ],
    ),
    ChatMessage(
      text: "This is a quick reply example.",
      user: ChatUser(
        name: "Mrfatty",
        uid: "25649654",
      ),
      createdAt: DateTime.now(),
      payloadType: PayloadType.gridCarousel,
      buttons: <Reply>[
        Reply(
          title: "How to",
          value: "How to",
          iconPath:
              "https://silxdigital.com/wp-content/uploads/2019/09/digital-ads-promo-icon.png",
        ),
        Reply(
          title: "Check rates",
          value: "Check rates",
          iconPath:
              "https://silxdigital.com/wp-content/uploads/2019/09/digital-ads-promo-icon.png",
        ),
        Reply(
          title: "Set alert",
          value: "Set alert",
          iconPath:
              "https://silxdigital.com/wp-content/uploads/2019/09/digital-ads-promo-icon.png",
        ),
        Reply(
          title: "Disable alert",
          value: "Disable alert",
          iconPath:
              "https://silxdigital.com/wp-content/uploads/2019/09/digital-ads-promo-icon.png",
        ),
      ],
    ),
    ChatMessage(
      text: "This is a video example.",
      user: ChatUser(
        name: "Mrfatty",
        uid: "25649654",
      ),
      createdAt: DateTime.now(),
      payloadType: PayloadType.video,
      buttons: <Reply>[
        Reply(
          title: "", value: "", iconPath: "",
          //src: "https://www.youtube.com/watch?v=q0EpEK6MkAI",
          //"https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
          // iconPath: "https://www.youtube.com/watch?v=YFCSODyFxbE",
        ),
      ],
    ),
    ChatMessage(
      text: "This is a card example.",
      user: ChatUser(
        name: "Mrfatty",
        uid: "25649654",
      ),
      createdAt: DateTime.now(),
      payloadType: PayloadType.card,
      buttons: <Reply>[
        Reply(
            title: "",
            value: "",
            iconPath: '',
            rateObject: Rate(
                toCurrency: '123',
                toCurrencyFull: 'uae rupee',
                fromCurrency: '677',
                exRate: 20,
                remittances: 345,
                buying: 222,
                selling: 888,
                icon: 'https://i.postimg.cc/yYgK7qW2/in.png')
            
            ),
      ],
    ),
  ];

  var m = <ChatMessage>[];

  var i = 0;

  @override
  void initState() {
    super.initState();
  }

  void systemMessage() {
    Timer(Duration(milliseconds: 300), () {
      if (i < 6) {
        setState(() {
          messages = [...messages, m[i]];
        });
        i++;
      }
      Timer(Duration(milliseconds: 300), () {
        _chatViewKey.currentState.scrollController
          ..animateTo(
            _chatViewKey.currentState.scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
      });
    });
  }

  void onSend(ChatMessage message) {
    print(message.toJson());
    // FirebaseFirestore.instance
    //     .collection('messages')
    //     .doc(DateTime.now().millisecondsSinceEpoch.toString())
    //     .set(message.toJson());
    /* setState(() {
      messages = [...messages, message];
      print(messages.length);
    });

    if (i == 0) {
      systemMessage();
      Timer(Duration(milliseconds: 600), () {
        systemMessage();
      });
    } else {
      systemMessage();
    } */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
      ),
      body: DashChat(
        readOnly: true,
        scrollController: ScrollController(initialScrollOffset: 0.0),
        // messageTextBuilder: (text, [message]) {
        //   return Padding(
        //     padding: const EdgeInsets.all(4.0),
        //     child: Text(
        //       text ?? '',
        //       style: TextStyle(
        //         color: message.user.uid == '123456789'
        //             ? Color(0xFF05046A)
        //             : Colors.white,
        //         fontSize: 14,
        //       ),
        //     ),
        //   );
        // },
        // messageTimeBuilder: (text, [message]) {
        //   return SizedBox();
        // },
        shouldStartMessagesFromTop: true,
        messageDecorationBuilder: (msg, isUser) {
          // bool isUser = msg.user.uid == '123456789';
          BoxDecoration decoration;
          if (isUser ?? false) {
            decoration = BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            );
          } else {
            decoration = BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF4F6FE8),
                  const Color(0xFF5AABE2),
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: [0.241, 0.5981],
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0.5, 0.5),
                    blurRadius: 0.5,
                    spreadRadius: 1.0)
              ],
            );
          }
          return decoration;
          // return Container(
          //   padding: EdgeInsets.all(12.0),
          //   decoration: decoration,
          //   margin: EdgeInsets.only(left: 16.0, bottom: 16.0),
          //   child: Text(
          //     msg.text,
          //     style: Theme.of(context).textTheme.button.copyWith(
          //           color: isUser ? Color(0xFF05046A) : Colors.white,
          //           fontSize: 14,
          //         ),
          //   ),
          // );
        },
        // messageButtonsBuilder: (message) {
        //   return message.quickReplies != null && message.quickReplies.values.length > 0 ? message.quickReplies.values
        //       .asMap()
        //       .map(
        //         (index, reply) {
        //           return MapEntry(
        //             index,
        //             Container(
        //               padding: EdgeInsets.all(12.0),
        //               decoration: BoxDecoration(
        //                 color: Color(0xFFFDDA25),
        //                 borderRadius: BorderRadius.circular(12.0),
        //               ),
        //               margin: EdgeInsets.only(left: 16.0, bottom: 16.0),
        //               child: Text(
        //                 reply.value,
        //                 style: Theme.of(context).textTheme.button.copyWith(
        //                       color: Color(0xFF05046A),
        //                       fontSize: 14,
        //                     ),
        //               ),
        //             ),
        //           );
        //         },
        //       )
        //       .values
        //       .toList() : null;
        // },
        quickReplyBuilder: (Reply reply) {
          return Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Color(0xFFFDDA25),
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: EdgeInsets.only(
              left: 16.0,
              bottom: 16.0,
            ),
            child: Text(
              reply.value ?? '',
            ),
          );
        },
        key: _chatViewKey,
        inverted: false,
        onSend: onSend,
        sendOnEnter: true,
        textInputAction: TextInputAction.send,
        user: user,
        inputDecoration:
            InputDecoration.collapsed(hintText: "Add message here..."),
        dateFormat: DateFormat('yyyy-MMM-dd'),
        timeFormat: DateFormat('HH:mm'),
        messages: messages,
        showUserAvatar: false,
        showAvatarForEveryMessage: false,
        scrollToBottom: false,
        onPressAvatar: (ChatUser user) {
          print("OnPressAvatar: ${user.name}");
        },
        onLongPressAvatar: (ChatUser user) {
          print("OnLongPressAvatar: ${user.name}");
        },
        inputMaxLines: 5,
        messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
        alwaysShowSend: true,
        inputTextStyle: TextStyle(fontSize: 16.0),
        inputContainerStyle: BoxDecoration(
          border: Border.all(width: 0.0),
          color: Colors.white,
        ),
        onQuickReply: (Reply reply) {
          setState(() {
            messages.add(ChatMessage(
                text: reply.value, createdAt: DateTime.now(), user: user));

            messages = [...messages];
          });

          Timer(Duration(milliseconds: 300), () {
            _chatViewKey.currentState.scrollController
              ..animateTo(
                _chatViewKey
                    .currentState.scrollController.position.maxScrollExtent,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );

            if (i == 0) {
              systemMessage();
              Timer(Duration(milliseconds: 600), () {
                systemMessage();
              });
            } else {
              systemMessage();
            }
          });
        },
        onLoadEarlier: () {
          print("laoding...");
        },
        shouldShowLoadEarlier: false,
        showTraillingBeforeSend: true,
        trailing: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            onPressed: () async {
              // final picker = ImagePicker();
              // PickedFile? result = await picker.getImage(
              //   source: ImageSource.gallery,
              //   imageQuality: 80,
              //   maxHeight: 400,
              //   maxWidth: 400,
              // );

              // if (result != null) {
              //   final Reference storageRef =
              //       FirebaseStorage.instance.ref().child("chat_images");

              //   final taskSnapshot = await storageRef.putFile(
              //     File(result.path),
              //     SettableMetadata(
              //       contentType: 'image/jpg',
              //     ),
              //   );

              // String url = await taskSnapshot.ref.getDownloadURL();

              // ChatMessage message =
              //     ChatMessage(text: "", user: user, image: url);

              // FirebaseFirestore.instance
              //     .collection('messages')
              //     .add(message.toJson());
              // }
            },
          ),
        ],
      ),
    );
  }
}
