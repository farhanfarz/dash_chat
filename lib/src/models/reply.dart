part of dash_chat;

/// Used for providing replies in quick replies

class Reply {
  /// Message shown to the user
  String title;

  /// Actual value underneath the message
  /// It's an [optioanl] paramter
  String value;

  String iconPath;

  /// If no messageId is provided it will use [UUID v4] to
  /// set a default id for that message
  dynamic messageId;

  String src;

  Reply({this.title, String messageId, this.iconPath, this.value, this.src}) {
    this.messageId = messageId ?? Uuid().v4().toString();
  }

  Reply.fromJson(Map<dynamic, dynamic> json) {
    title = json['title'];
    value = json['value'];
    messageId = json['messageId'];
    iconPath = json['iconPath'];
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['messageId'] = messageId;
    data['title'] = title;
    data['value'] = value;
    data['iconPath'] = iconPath;
    data['src'] = src;

    return data;
  }
}
