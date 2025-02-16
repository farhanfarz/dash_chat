part of dash_chat;

class ScrollToBottom extends StatelessWidget {
  final Function onScrollToBottomPress;
  final ScrollController scrollController;
  final bool inverted;
  final ScrollToBottomStyle scrollToBottomStyle;

  ScrollToBottom({
    this.onScrollToBottomPress,
    this.scrollController,
    this.inverted,
    this.scrollToBottomStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: scrollToBottomStyle.width,
      height: scrollToBottomStyle.height,
      child: RawMaterialButton(
        elevation: 5,
        fillColor: Color(0xFF5AA9E2),
        //scrollToBottomStyle.backgroundColor ??
        //  Theme.of(context).primaryColor,
        shape: CircleBorder(),
        child: Icon(
          scrollToBottomStyle.icon ?? Icons.keyboard_arrow_down,
          color: scrollToBottomStyle.textColor ?? Colors.black,
        ),
        onPressed: () {
          onScrollToBottomPress?.call() ??
              scrollController.animateTo(
                inverted
                    ? 0.0
                    : scrollController.position.maxScrollExtent + 25.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
        },
      ),
    );
  }
}
