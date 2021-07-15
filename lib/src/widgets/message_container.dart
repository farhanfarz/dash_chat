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
    this.messagePadding = const EdgeInsets.all(8.0),
    this.messageDecorationBuilder,
  });

  @override
  _MessageContainerState createState() => _MessageContainerState();
}

class _MessageContainerState extends State<MessageContainer> {
  final List dummyData = List.generate(50, (index) => '$index');
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    if (widget.payloadType == PayloadType.video)
      _controller =
          createMyVideoControllerUsingUrl(widget.buttons.first.iconPath ?? '');
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
    _controller.initialize().then((_) => setState(() {}));
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

    return Column(
      crossAxisAlignment:
          widget.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (widget.message.text != null && widget.message.text.isNotEmpty)
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth * 0.8,
            ),
            child: Container(
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
              margin: EdgeInsets.only(
                bottom: 5.0,
              ),
              padding: widget.messagePadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: widget.isUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: <Widget>[
                  // if (this.textBeforeImage)
                  //   _buildMessageText()
                  // else
                  //   _buildMessageImage(),
                  // if (this.textBeforeImage)
                  //   _buildMessageImage()
                  // else
                  _buildMessageText(),

                  if (widget.messageButtonsBuilder != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: widget.isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: widget.messageButtonsBuilder(widget.message),
                      mainAxisSize: MainAxisSize.min,
                    ),
                  widget.messageTimeBuilder?.call(
                        widget.timeFormat?.format(widget.message.createdAt) ??
                            DateFormat('HH:mm:ss')
                                .format(widget.message.createdAt),
                        widget.message,
                      ) ??
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          widget.timeFormat != null
                              ? widget.timeFormat
                                  .format(widget.message.createdAt)
                              : DateFormat('HH:mm:ss')
                                  .format(widget.message.createdAt),
                          style: TextStyle(
                            fontSize: 10.0,
                            color: widget.message.user.color ??
                                (widget.isUser
                                    ? Colors.white70
                                    : Colors.black87),
                          ),
                        ),
                      )
                ],
              ),
            ),
          ),
        _buildMessageImage(),
        if (widget.payloadType == PayloadType.quickReplies)
          SizedBox(
            height: 60,
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
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SF-UI-Display-Medium',
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
        if (widget.payloadType == PayloadType.buttons)
          Container(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: GridView.builder(
                  padding: EdgeInsets.only(bottom: 120),
                  itemCount: widget.buttons.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    var item = widget.buttons[index];
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
                        padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            ),
                            Text(
                              item.title,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xDE05046A)),
                            )
                          ],
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
                                        if (reply.iconPath != null &&
                                            reply.iconPath.isNotEmpty)
                                          Image.network(reply.iconPath,
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
        if (widget.payloadType == PayloadType.gridCarousel)
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: SizedBox(
              width: double.infinity,
              height: 330,
              child: GridView.builder(
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
                  return Container(
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
                      leading: Image.network(
                        item.iconPath ?? '',
                        height: 44.0,
                        width: 44.0,
                      ),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xDE05046A),
                        ),
                      ),
                      subtitle: Container(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          item.value ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xDE05046A),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        if (widget.payloadType == PayloadType.video)
          SizedBox(
            height: 240,
            child: PhysicalModel(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              shadowColor: Color(0xFFD2DEE2).withOpacity(0.4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      VideoPlayer(_controller),
                      ClosedCaption(text: _controller.value.caption.text),
                      _PlayPauseOverlay(controller: _controller),
                      VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
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
            color: widget.message.user.color ??
                (widget.isUser ? Colors.white70 : Colors.black87),
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
