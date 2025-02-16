part of dash_chat;

class ChatInputToolbar extends StatelessWidget {
  final TextEditingController controller;
  final TextStyle inputTextStyle;
  final InputDecoration inputDecoration;
  final TextCapitalization textCapitalization;
  final BoxDecoration inputContainerStyle;
  final List<Widget> leading;
  final List<Widget> trailling;
  final int inputMaxLines;
  final int maxInputLength;
  final bool alwaysShowSend;
  final ChatUser user;
  final Function(ChatMessage) onSend;
  final Function onSendTextfieild;

  final String text;
  final Function(String) onTextChange;
  final bool inputDisabled;
  final String Function() messageIdGenerator;
  final Widget Function(Function) sendButtonBuilder;
  final Widget Function() inputFooterBuilder;
  final bool showInputCursor;
  final double inputCursorWidth;
  final Color inputCursorColor;
  final ScrollController scrollController;
  final bool showTraillingBeforeSend;
  final FocusNode focusNode;
  final EdgeInsets inputToolbarPadding;
  final EdgeInsets inputToolbarMargin;
  final TextDirection textDirection;
  final bool sendOnEnter;
  final bool reverse;
  final TextInputAction textInputAction;
  final bool isEnableSend;

  ChatInputToolbar({
    Key key,
    this.textDirection = TextDirection.ltr,
    this.focusNode,
    this.scrollController,
    this.text,
    this.textInputAction,
    this.sendOnEnter = true,
    this.onTextChange,
    this.inputDisabled = false,
    this.controller,
    this.leading = const [],
    this.trailling = const [],
    this.inputDecoration,
    this.textCapitalization,
    this.inputTextStyle,
    this.inputContainerStyle,
    this.inputMaxLines = 1,
    this.showInputCursor = true,
    this.maxInputLength,
    this.inputCursorWidth = 2.0,
    this.inputCursorColor,
    this.onSend,
    this.reverse = false,
    this.user,
    this.alwaysShowSend = false,
    this.messageIdGenerator,
    this.inputFooterBuilder,
    this.sendButtonBuilder,
    this.showTraillingBeforeSend = true,
    this.inputToolbarPadding = const EdgeInsets.all(0.0),
    this.inputToolbarMargin = const EdgeInsets.all(0.0),
    this.onSendTextfieild,
    this.isEnableSend = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isEnableTextField = false;

    ChatMessage message = ChatMessage(
      text: text,
      user: user,
      messageIdGenerator: messageIdGenerator,
      createdAt: DateTime.now(),
    );

    return Container(
      height: 80,
      child: Padding(
        padding: EdgeInsets.only(left: 12.0, right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // ...leading,
            Expanded(
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(118, 118, 128, 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8,
                  ),
                  child: Directionality(
                    textDirection: textDirection,
                    child: TextField(
                      focusNode: focusNode,
                      onChanged: (value) {
                        onTextChange(value);
                      },
                      onSubmitted: (value) {
                        if (sendOnEnter) {
                          _sendMessage(context, message);
                        }
                      },
                      textInputAction: textInputAction,
                      buildCounter: (
                        BuildContext context, {
                        int currentLength,
                        int maxLength,
                        bool isFocused,
                      }) =>
                          null,
                      decoration: inputDecoration != null
                          ? inputDecoration
                          : InputDecoration.collapsed(
                              hintText: "",
                              hintStyle: TextStyle(color: Color(0xDE05046A)),
                              fillColor: Colors.white,
                            ),
                      textCapitalization: textCapitalization,
                      controller: controller,
                      style: inputTextStyle,
                      maxLength: maxInputLength,
                      minLines: 1,
                      maxLines: inputMaxLines,
                      showCursor: showInputCursor,
                      cursorColor: inputCursorColor,
                      cursorWidth: inputCursorWidth,
                      enabled: !inputDisabled,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            if (sendButtonBuilder != null)
              sendButtonBuilder(() async {
                if (text.length != 0) {
                  await onSend(message);
                  onSendTextfieild();

                  controller.text = "";

                  onTextChange("");
                }
              })
            else
              GestureDetector(
                onTap: () {
                  _sendMessage(context, message);
                },
                child: Opacity(
                  opacity: isEnableSend ? 1 : 0.4,
                  child: FadeInImage.memoryNetwork(
                    height: 30,
                    width: 30,
                    fit: BoxFit.contain,
                    placeholder: kTransparentImage,
                    image: 'https://i.postimg.cc/cCwNHNbN/Send.png' ?? '',
                  ),
                ),
              ),

            if (!showTraillingBeforeSend) ...trailling,
          ],
        ),
      ),
    );
    // if (sendButtonBuilder != null)
    //   sendButtonBuilder(() async {
    //     if (text.length != 0) {
    //       await onSend(message);
    //       onSendTextfieild();

    //       controller.text = "";

    //       onTextChange("");
    //     }
    //   })
    // else

    // if (!showTraillingBeforeSend) ...trailling,
    // ],
    // );
  }

  void _sendMessage(BuildContext context, ChatMessage message) async {
    if (text.length != 0) {
      // FocusScope.of(context).requestFocus(focusNode);
      SystemChannels.textInput.invokeMethod('TextInput.hide');

      Timer(Duration(seconds: 1), () {
        onSendTextfieild();
      });

      await onSend(message);

      controller.text = "";

      onTextChange("");

      //FocusScope.of(context).requestFocus(focusNode);

    }
  }
}
