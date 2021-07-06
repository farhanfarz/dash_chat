part of dash_chat;

/// MessageContainer is just a wrapper around [Text], [Image]
/// component to present the message
enum PayloadType { none, dropDown, cardsCarousel, buttons, quickReplies }

class MessageContainer extends StatelessWidget {
  /// Message Object that will be rendered
  /// Takes a [ChatMessage] object
  final ChatMessage message;

  /// [DateFormat] object to render the date in desired
  /// format, if no format is provided it use
  /// the default `HH:mm:ss`
  final DateFormat? timeFormat;

  /// [messageTextBuilder] function takes a function with this
  /// structure [Widget Function(String)] to render the text inside
  /// the container.
  final Widget Function(String?, [ChatMessage])? messageTextBuilder;

  /// [messageImageBuilder] function takes a function with this
  /// structure [Widget Function(String)] to render the image inside
  /// the container.
  final Widget Function(String?, [ChatMessage])? messageImageBuilder;

  /// [messageTimeBuilder] function takes a function with this
  /// structure [Widget Function(String)] to render the time text inside
  /// the container.
  final Widget Function(String, [ChatMessage])? messageTimeBuilder;

  /// Provides a custom style to the message container
  /// takes [BoxDecoration]
  final BoxDecoration? messageContainerDecoration;

  /// Used to parse text to make it linkified text uses
  /// [flutter_parsed_text](https://pub.dev/packages/flutter_parsed_text)
  /// takes a list of [MatchText] in order to parse Email, phone, links
  /// and can also add custom pattersn using regex
  final List<MatchText> parsePatterns;

  /// A flag which is used for assiging styles
  final bool isUser;

  /// Provides a list of buttons to allow the usage of adding buttons to
  /// the bottom of the message
  final List<Reply>? buttons;
  final PayloadType payloadType;

  /// [messageButtonsBuilder] function takes a function with this
  /// structure [List<Widget> Function()] to render the buttons inside
  /// a row.
  final List<Widget> Function(ChatMessage)? messageButtonsBuilder;

  /// Constraint to use to build the message layout
  final BoxConstraints? constraints;

  /// Padding of the message
  /// Default to EdgeInsets.all(8.0)
  final EdgeInsets messagePadding;

  /// Should show the text before the image in the chat bubble
  /// or the opposite
  /// Default to `true`
  final bool textBeforeImage;

  /// overrides the boxdecoration of the message
  /// can be used to override color, or customise the message container
  /// params [ChatMessage] and [isUser]: boolean
  /// return BoxDecoration
  final BoxDecoration Function(ChatMessage, bool?)? messageDecorationBuilder;

  const MessageContainer({
    required this.message,
    required this.timeFormat,
    this.constraints,
    this.messageImageBuilder,
    this.messageTextBuilder,
    this.messageTimeBuilder,
    this.messageContainerDecoration,
    this.parsePatterns = const <MatchText>[],
    this.textBeforeImage = true,
    required this.isUser,
    this.messageButtonsBuilder,
    this.buttons,
    this.payloadType = PayloadType.none,
    this.messagePadding = const EdgeInsets.all(8.0),
    this.messageDecorationBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final constraints = this.constraints ??
        BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width);
    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (message.text != null && message.text!.isNotEmpty)
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth * 0.8,
            ),
            child: Container(
              decoration: messageDecorationBuilder?.call(message, isUser) ??
                  messageContainerDecoration?.copyWith(
                    color: message.user.containerColor != null
                        ? message.user.containerColor
                        : messageContainerDecoration!.color,
                  ) ??
                  BoxDecoration(
                    color: message.user.containerColor ??
                        (isUser
                            ? Theme.of(context).accentColor
                            : Color.fromRGBO(225, 225, 225, 1)),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
              margin: EdgeInsets.only(
                bottom: 5.0,
              ),
              padding: messagePadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  // if (this.textBeforeImage)
                  //   _buildMessageText()
                  // else
                  //   _buildMessageImage(),
                  // if (this.textBeforeImage)
                  //   _buildMessageImage()
                  // else
                  _buildMessageText(),

                  if (messageButtonsBuilder != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: messageButtonsBuilder!(message),
                      mainAxisSize: MainAxisSize.min,
                    ),
                  messageTimeBuilder?.call(
                        timeFormat?.format(message.createdAt) ??
                            DateFormat('HH:mm:ss').format(message.createdAt),
                        message,
                      ) ??
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          timeFormat != null
                              ? timeFormat!.format(message.createdAt)
                              : DateFormat('HH:mm:ss')
                                  .format(message.createdAt),
                          style: TextStyle(
                            fontSize: 10.0,
                            color: message.user.color ??
                                (isUser ? Colors.white70 : Colors.black87),
                          ),
                        ),
                      )
                ],
              ),
            ),
          ),
        _buildMessageImage(),
        if (payloadType == PayloadType.quickReplies)
          SizedBox(
            height: 60,
            child: CustomScrollView(
              scrollDirection: Axis.horizontal,
              slivers: [
                SliverToBoxAdapter(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: isUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: buttons!
                        .asMap()
                        .map(
                          (index, reply) {
                            return MapEntry(
                              index,
                              Container(
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
                              ),
                            );
                          },
                        )
                        .values
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        if (payloadType == PayloadType.buttons)
          Container(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: GridView.builder(
                  itemCount: buttons!.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // mainAxisSpacing: 5.0,
                    // crossAxisSpacing: 5.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    var item = buttons![index];
                    return Container(
                      height: 60,
                      margin: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFD2DEE2).withOpacity(0.4),
                            blurRadius: 30.0, // soften the shadow
                            spreadRadius: 0.0, //extend the shadow
                            offset: Offset(
                              0.0, // Move to right 10  horizontally
                              8.0, // Move to bottom 10 Vertically
                            ),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: EdgeInsets.only(left: 15, top: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              child: FadeInImage.memoryNetwork(
                                height: 44,
                                width: 44,
                                fit: BoxFit.contain,
                                placeholder: kTransparentImage,
                                image: item.iconPath ?? '',
                              ),
                              // FadeInImage.assetNetwork(
                              //   fit: BoxFit.cover,
                              //   placeholder: ,
                              //   image: item.iconPath ?? '',
                              // ),
                            ),
                            Text(
                              item.title,
                              // style: Theme.of(context).textTheme.subtitle1.copyWith(
                              //       color: Color(0xDE05046A),
                              //       fontSize: 15.sp,
                              //     ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
        if (payloadType == PayloadType.cardsCarousel && buttons != null)
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
            ),
            items: buttons!
                .asMap()
                .map(
                  (index, reply) {
                    return MapEntry(
                      index,
                      reply != null
                          ? Container(
                              child: Container(
                                margin: EdgeInsets.all(5.0),
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    child: Stack(
                                      children: <Widget>[
                                        // FadeInImage.memoryNetwork(
                                        //   fit: BoxFit.cover,
                                        //   placeholder: kTransparentImage,
                                        //   image: reply.iconPath,
                                        //   width: 1000,
                                        // ),
                                        if (reply.iconPath != null &&
                                            reply.iconPath!.isNotEmpty)
                                          Image.network(reply.iconPath!,
                                              fit: BoxFit.cover, width: 1000.0),

                                        Positioned(
                                          bottom: 0.0,
                                          left: 0.0,
                                          right: 0.0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color.fromARGB(200, 0, 0, 0),
                                                  Color.fromARGB(0, 0, 0, 0)
                                                ],
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                              ),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 20.0),
                                            child: Text(
                                              reply.title,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            )
                          : SizedBox(),
                    );
                  },
                )
                .values
                .toList(),
          ),
      ],
    );
  }

  Widget _buildMessageText() {
    return messageTextBuilder?.call(message.text, message) ??
        ParsedText(
          parse: parsePatterns,
          text: message.text!,
          style: TextStyle(
            color: message.user.color ??
                (isUser ? Colors.white70 : Colors.black87),
          ),
        );
  }

  Widget _buildMessageImage() {
    if (message.image != null) {
      return messageImageBuilder?.call(message.image, message) ??
          Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: FadeInImage.memoryNetwork(
              height: constraints!.maxHeight * 0.3,
              width: constraints!.maxWidth * 0.7,
              fit: BoxFit.contain,
              placeholder: kTransparentImage,
              image: message.image!,
            ),
          );
    }
    return SizedBox(width: 0, height: 0);
  }
}
