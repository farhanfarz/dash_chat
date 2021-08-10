part of dash_chat;

/// MessageContainer is just a wrapper around [Text], [Image]
/// component to present the message
enum PayloadType {
  none,
  gridCarousel,
  cardsCarousel,
  buttons,
  quickReplies,
  video,
  card,
  location,
  loading,
}

class MessageContainer extends StatefulWidget {
  /// Message Object that will be rendered
  /// Takes a [ChatMessage] object
  final ChatMessage message;

  /// [DateFormat] object to render the date in desired
  /// format, if no format is provided it use
  /// the default `HH:mm:ss`
  final DateFormat timeFormat;

  /// [messageTextBuilder] function takes a function with this
  /// structure [Widget Function(String)] to render the text inside
  /// the container.
  final Widget Function(String, [ChatMessage]) messageTextBuilder;

  /// [messageImageBuilder] function takes a function with this
  /// structure [Widget Function(String)] to render the image inside
  /// the container.
  final Widget Function(String, [ChatMessage]) messageImageBuilder;

  /// [messageTimeBuilder] function takes a function with this
  /// structure [Widget Function(String)] to render the time text inside
  /// the container.
  final Widget Function(String, [ChatMessage]) messageTimeBuilder;

  /// Provides a custom style to the message container
  /// takes [BoxDecoration]
  final BoxDecoration messageContainerDecoration;

  /// Used to parse text to make it linkified text uses
  /// [flutter_parsed_text](https://pub.dev/packages/flutter_parsed_text)
  /// takes a list of [MatchText] in order to parse Email, phone, links
  /// and can also add custom pattersn using regex
  final List<MatchText> parsePatterns;

  /// A flag which is used for assiging styles
  final bool isUser;

  /// Provides a list of buttons to allow the usage of adding buttons to
  /// the bottom of the message
  final List<Reply> buttons;
  final PayloadType payloadType;

  /// [messageButtonsBuilder] function takes a function with this
  /// structure [List<Widget> Function()] to render the buttons inside
  /// a row.
  final List<Widget> Function(ChatMessage) messageButtonsBuilder;

  /// Constraint to use to build the message layout
  final BoxConstraints constraints;

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
  final BoxDecoration Function(ChatMessage, bool) messageDecorationBuilder;
  final Function(Reply) onTapReply;

  final bool isSomeoneTyping;

  const MessageContainer({
    this.message,
    this.timeFormat,
    this.constraints,
    this.messageImageBuilder,
    this.messageTextBuilder,
    this.messageTimeBuilder,
    this.messageContainerDecoration,
    this.parsePatterns = const <MatchText>[],
    this.textBeforeImage = true,
    this.isUser,
    this.messageButtonsBuilder,
    this.buttons,
    this.payloadType = PayloadType.none,
    this.messagePadding = const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
    this.messageDecorationBuilder,
    this.onTapReply,
    this.isSomeoneTyping = false,
  });

  @override
  _MessageContainerState createState() => _MessageContainerState();
}

class _MessageContainerState extends State<MessageContainer> {
  final List dummyData = List.generate(50, (index) => '$index');
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  double verticalSpacing = 12.0;
  double horizontalSpacing = 12.0;

  @override
  void initState() {
    super.initState();

    if (widget.payloadType == PayloadType.video)
      _controller =
          createMyVideoControllerUsingUrl(widget.buttons.first.src ?? '');
  }

  VideoPlayerController createMyVideoControllerUsingUrl(String url) {
    VideoPlayerController _controller = VideoPlayerController.network(
      url,
      //youtubeVideoQuality: VideoQuality.high720,
    );
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(false);
    _controller.initialize().then((_) => setState(() {
          _initializeVideoPlayerFuture = _controller.initialize();
        }));
    _controller.play();

    return _controller;
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final constraints = this.widget.constraints ??
        BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width);
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = 150;
    //(size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;


    return Column(
      crossAxisAlignment:
          widget.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (widget.message.text != null && widget.message.text.isNotEmpty)
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth * 0.8,
            ),
            child: Stack(
              children: [
                Container(
                  //color: Colors.red,

                  margin:
                      EdgeInsets.only(bottom: 4, left: verticalSpacing, top: 4, right: verticalSpacing),
                  padding: EdgeInsets.fromLTRB(8.0, 14.0, 8.0, 14.0),
                  decoration: widget.messageDecorationBuilder
                          ?.call(widget.message, widget.isUser) ??
                      widget.messageContainerDecoration?.copyWith(
                        color: widget.message.user.containerColor != null
                            ? widget.message.user.containerColor
                            : widget.messageContainerDecoration.color,
                      ) ??
                      BoxDecoration(
                        color: widget.message.user.containerColor ??
                            (widget.isUser
                                ? Theme.of(context).accentColor
                                : Color.fromRGBO(225, 225, 225, 1)),
                        borderRadius: BorderRadius.circular(5.0),
                      ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: widget.isUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: <Widget>[
                      // if (widget.textBeforeImage)
                      //   _buildMessageText()
                      // else
                      //   _buildMessageImage(),
                      // if (widget.textBeforeImage)
                      //   _buildMessageImage()
                      // else
                      _buildMessageText(),

                      if (widget.messageButtonsBuilder != null)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: widget.isUser
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children:
                              widget.messageButtonsBuilder(widget.message),
                          mainAxisSize: MainAxisSize.min,
                        ),
                      // widget.messageTimeBuilder?.call(
                      //       widget.timeFormat
                      //               ?.format(widget.message.createdAt) ??
                      //           DateFormat('HH:mm:ss')
                      //               .format(widget.message.createdAt),
                      //       widget.message,
                      //     ) ??
                      //     Padding(
                      //       padding: EdgeInsets.only(top: 5.0),
                      //       child: Text(
                      //         widget.timeFormat != null
                      //             ? widget.timeFormat
                      //                 .format(widget.message.createdAt)
                      //             : DateFormat('HH:mm:ss')
                      //                 .format(widget.message.createdAt),
                      //         style: TextStyle(
                      //             color: Color(0xFFFFFFFF),
                      //             // widget.message.user.color ??
                      //             //     (widget.isUser ? Colors.white70 : Colors.black87),
                      //             fontSize: 12,
                      //             fontWeight: FontWeight.w400,
                      //             letterSpacing: 0.5,
                      //             fontFamily: 'SF-UI-Display-Regular'),
                      //         // TextStyle(
                      //         //   fontSize: 10.0,
                      //         //   color: widget.message.user.color ??
                      //         //       (widget.isUser
                      //         //           ? Colors.white70
                      //         //           : Colors.black87),
                      //         // ),
                      //       ),
                      //     )
                    ],
                  ),
                ),

                // Positioned(
                //     // left: 0,
                //     // bottom: 20,
                //     child: SizedBox(
                //   height: 30,
                //   width: 30,
                //   child: Image.asset('assets/images/chatbot_bubble.png'),
                // )
                //     //_buildCircleBubble(16),
                //     ),
              ],
            ),
          ),
        // _buildMessageImage(),
        if (widget.payloadType == PayloadType.quickReplies)
          Padding(
            padding:
                EdgeInsets.only(top: 11, bottom: 11, left: verticalSpacing),
            child: SizedBox(
              height: 38,
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                slivers: [
                  SliverToBoxAdapter(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: widget.isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: widget.buttons
                          .asMap()
                          .map(
                            (index, reply) {
                              return MapEntry(
                                index,
                                GestureDetector(
                                  onTap: () {
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');

                                    widget.onTapReply(reply);
                                  },
                                  child: Container(
                                    height: 38,
                                    // padding: EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFDDA25),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    margin: EdgeInsets.only(
                                      right: 10.0,
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8),
                                        child: Text(
                                          reply.title ?? '',
                                          // textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xDE05046A),
                                          ),
                                          // TextStyle(
                                          //   fontSize: 15,
                                          //   fontWeight: FontWeight.bold,
                                          //   fontFamily: 'SF-UI-Display-Medium',
                                          // ),
                                        ),
                                      ),
                                    ),
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
          ),
        if (widget.payloadType == PayloadType.buttons)
          Container(
            //height: 300,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 6, top: verticalSpacing, right: 6.0, bottom: 0.0),
              child: GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.buttons.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: (itemWidth / itemHeight),
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    var item = widget.buttons[index];
                    return GestureDetector(
                      onTap: () {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');

                        widget.onTapReply(item);
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(7.5, 7.5, 7.5,
                            (index >= widget.buttons.length - 2) ? 15 : 7.5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
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
                          padding: EdgeInsets.only(
                            left: 15,
                            top: verticalSpacing,
                            bottom: 15,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: FadeInImage.memoryNetwork(
                                  height: 44,
                                  width: 44,
                                  fit: BoxFit.contain,
                                  placeholder: kTransparentImage,
                                  image: item.iconPath ?? '',
                                ),
                              ),
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 0.15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xDE05046A),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        if (widget.payloadType == PayloadType.cardsCarousel &&
            widget.buttons != null)
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
            ),
            items: widget.buttons
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
                                        if (reply.imagePath != null &&
                                            reply.imagePath.isNotEmpty)
                                          Image.network(reply.imagePath,
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
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600,
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
        if (widget.payloadType == PayloadType.gridCarousel)
          Container(
            padding: EdgeInsets.only(left: 12),
            margin: EdgeInsets.symmetric(
              vertical: verticalSpacing,
            ),
            width: double.infinity,
            height: 330,
            child: GridView.builder(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: widget.buttons.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 74,
                childAspectRatio: 0.35,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                var item = widget.buttons[index];
                return GestureDetector(
                  onTap: () {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');

                    widget.onTapReply(item);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
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
                    //color: Colors.white,
                    alignment: Alignment.center,
                    child: ListTile(
                      leading: SizedBox(
                        height: 44.0,
                        width: 44.0,
                        child: Image.network(
                          item.iconPath ?? '',
                          height: 44.0,
                          width: 44.0,
                        ),
                      ),
                      title: Text(
                        item.title,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.15,
                          color: Color(0xDE05046A),
                        ),
                      ),
                      subtitle: Container(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          item.value ?? '',
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.4,
                            color: Color(0xDE05046A),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        if (widget.payloadType == PayloadType.location)
          Container(
            padding: EdgeInsets.only(
              left: 12,
            ),
            margin: EdgeInsets.symmetric(
              vertical: verticalSpacing,
            ),
            width: double.infinity,
            height: 340,
            child: GridView.builder(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: widget.buttons.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 84,
                childAspectRatio: 0.25,
                //childAspectRatio: (itemWidthLocation / 350),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                var item = widget.buttons[index];
                return GestureDetector(
                  onTap: () {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');

                    widget.onTapReply(item);
                  },
                  child: Container(
                    // padding: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
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
                    //color: Colors.white,
                    alignment: Alignment.center,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          height: 44.0,
                          width: 44.0,
                          child: Image.network(
                            item.iconPath ?? '',
                            height: 44.0,
                            width: 44.0,
                          ),
                        ),
                      ),
                      title: Text(
                        item.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.15,
                          color: Color(0xDE05046A),
                        ),
                      ),
                      subtitle: Container(
                        padding: EdgeInsets.only(
                          top: 5,
                        ),
                        child: Text(
                          item.value ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.4,
                            color: Color(0xDE05046A),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        if (widget.payloadType == PayloadType.video)
          Padding(
            padding: EdgeInsets.all(verticalSpacing),
            child: SizedBox(
              height: 240,
              child: PhysicalModel(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                shadowColor: Color(0xFFD2DEE2).withOpacity(0.4),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: FutureBuilder(
                      future: _initializeVideoPlayerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // If the VideoPlayerController has finished initialization, use
                          // the data it provides to limit the aspect ratio of the VideoPlayer.
                          return AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    VideoPlayer(_controller),
                                    ClosedCaption(
                                        text: _controller.value.caption.text),
                                    _PlayPauseOverlay(controller: _controller),
                                    VideoProgressIndicator(
                                      _controller,
                                      allowScrubbing: true,
                                    ),
                                  ]));
                        } else {
                          // If the VideoPlayerController is still initializing, show a
                          // loading spinner.
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    )),
              ),
            ),
          ),
        if (widget.payloadType == PayloadType.card)
          Container(
            margin: EdgeInsets.all(verticalSpacing),
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
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        child: FadeInImage.memoryNetwork(
                          height: 44,
                          width: 44,
                          fit: BoxFit.contain,
                          placeholder: kTransparentImage,
                          image: widget.buttons.first.rateObject?.icon ??
                              'https://i.postimg.cc/yYgK7qW2/in.png',
                          //'https://i.postimg.cc/yYgK7qW2/in.png'
                        ),
                        // SvgPicture.asset(
                        //     'assets/images/svg/flags-svg/ae.svg'),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '1 ${widget.buttons.first.rateObject?.toCurrencyFull ?? ''}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(28, 43, 98, 1),
                                fontWeight: FontWeight.w600,
                              )
                              //  Theme.of(context).textTheme.subtitle1.copyWith(
                              //     color: Color.fromRGBO(28, 43, 98, 1),
                              //     fontSize: 16,
                              //     fontWeight: FontWeight.w600),
                              ),
                          Text(
                              widget.buttons.first.rateObject?.exRate
                                      .toString() ??
                                  '',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(28, 43, 98, 1),
                                fontWeight: FontWeight.w700,
                              )
                              //   Theme.of(context)
                              //       .textTheme
                              //       .headline2
                              //       .copyWith(color: Color.fromRGBO(28, 43, 98, 1), letterSpacing: -0.5),
                              ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: 250,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Buying',
                              style: TextStyle(
                                color: Color(0xDE05046A),
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                letterSpacing: 0.4,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.buttons.first.rateObject?.buying
                                      .toString() ??
                                  '',
                              style: TextStyle(
                                color: Color.fromRGBO(28, 43, 98, 1),
                                letterSpacing: -0.5,
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 32,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selling',
                              style: TextStyle(
                                color: Color(0xDE05046A),
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                letterSpacing: 0.4,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.buttons.first.rateObject?.selling
                                      .toString() ??
                                  '',
                              style: TextStyle(
                                color: Color.fromRGBO(28, 43, 98, 1),
                                letterSpacing: -0.5,
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 32,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Remittances',
                              style: TextStyle(
                                color: Color(0xDE05046A),
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                letterSpacing: 0.4,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.buttons.first.rateObject?.remittances
                                      .toString() ??
                                  '',
                              style: TextStyle(
                                color: Color.fromRGBO(28, 43, 98, 1),
                                letterSpacing: -0.5,
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'If making remittance in Index Exchange right now',
                    style: Theme.of(context).textTheme.caption.copyWith(
                          color: Color.fromRGBO(28, 43, 98, 1).withOpacity(0.4),
                        ),
                  ),
                ],
              ),
            ),
          ),
        if (widget.payloadType == PayloadType.loading) _buildLoadingMessage()
      ],
    );
  }

  Widget _buildCircleBubble(double size) {
    return CustomPaint(
      painter: ChatBubbleTriangle(),
      child: Container(
        width: 12,
        height: 12,
      ),
    );
  }

  Widget pauseAndPlay() {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 44),
          reverseDuration: Duration(milliseconds: 200),
          child: Opacity(
            opacity: (_controller.value.isPlaying ?? false) ? 0 : 1,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                // height: 50,
                // width: 50,
                child: Icon(
                  (_controller.value.isPlaying ?? false)
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              (_controller.value.isPlaying ?? false)
                  ? _controller?.pause()
                  : _controller?.play();
            });
          },
        ),
      ],
    );
  }

  Widget _buildMessageText() {
    return widget.messageTextBuilder
            ?.call(widget.message.text, widget.message) ??
        ParsedText(
          parse: widget.parsePatterns,
          text: widget.message.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            fontWeight: FontWeight.w400,
          ),
        );
  }

  Widget _buildLoadingMessage() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: TypingIndicator(
        showIndicator: widget.isSomeoneTyping,
      ),
    );
  }

  Widget _buildMessageImage() {
    if (widget.message.image != null) {
      return widget.messageImageBuilder
              ?.call(widget.message.image, widget.message) ??
          Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: FadeInImage.memoryNetwork(
              height: widget.constraints.maxHeight * 0.3,
              width: widget.constraints.maxWidth * 0.7,
              fit: BoxFit.contain,
              placeholder: kTransparentImage,
              image: widget.message.image,
            ),
          );
    }
    return SizedBox(width: 0, height: 0);
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 50.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            if (controller.value.position == controller.value.duration) {
              controller.initialize();
            }
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}

class ChatBubbleTriangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // var paint = Paint()..color = Colors.blue;
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset.fromDirection(1),
        Offset.fromDirection(2),
        [
          Color(0xFF4F6FE8),
          Color(0xFF5AABE2),
        ],
      );

    var path = Path();
    path.lineTo(-15, 5);
    path.lineTo(10, 20);
    path.lineTo(0, 10);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
