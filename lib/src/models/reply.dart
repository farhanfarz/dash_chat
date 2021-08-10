part of dash_chat;

/// Used for providing replies in quick replies

class Reply {
  /// Message shown to the user
  String title;

  /// Actual value underneath the message
  /// It's an [optioanl] paramter
  String value;

  String iconPath;

  String imagePath;

  /// If no messageId is provided it will use [UUID v4] to
  /// set a default id for that message
  dynamic messageId;

  String src;

  Rate rateObject;

  String address;

  Function onTapReply;

  Reply({
    this.title,
    String messageId,
    this.iconPath,
    this.imagePath,
    this.value,
    this.src,
    this.rateObject,
    this.onTapReply,
    this.address,
  }) {
    this.messageId = messageId ?? Uuid().v4().toString();
  }

  Reply.fromJson(Map<dynamic, dynamic> json) {
    title = json['title'];
    value = json['value'];
    messageId = json['messageId'];
    iconPath = json['iconPath'];
    imagePath = json['imagePath'];
    src = json['src'];
    rateObject = json['rateObject'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['messageId'] = messageId;
    data['title'] = title;
    data['value'] = value;
    data['iconPath'] = iconPath;
    data['imagePath'] = imagePath;
    data['src'] = src;
    data['rateObject'] = rateObject;
    data['address'] = address;


    return data;
  }
}
