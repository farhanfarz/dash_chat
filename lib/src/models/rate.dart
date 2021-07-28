part of dash_chat;

/// Used for providing replies in quick replies

class Rate {
  String fromCurrency;

  /// Actual value underneath the message
  /// It's an [optioanl] paramter
  String toCurrency;
  String toCurrencyFull;
  double exRate;
  double buying;
  double selling;
  double remittances;
  String icon;

  /// If no messageId is provided it will use [UUID v4] to
  /// set a default id for that message
  dynamic messageId;

  

  Rate({
    this.fromCurrency,
    this.toCurrency,
    this.buying,
    this.selling,
    this.remittances,
    this.exRate,
    this.toCurrencyFull,
    this.icon,
  });

  Rate.fromJson(Map<dynamic, dynamic> json) {
    fromCurrency = json['fromCurrency'];
    toCurrency = json['toCurrency'];
    messageId = json['messageId'];
    icon = json['icon'];
    buying = json['buying'];
    selling = json['selling'];
    remittances = json['remittances'];
    exRate = json['exRate'];
    toCurrencyFull = json['toCurrencyFull'];

   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['messageId'] = messageId;
    data['fromCurrency'] = fromCurrency;
    data['toCurrency'] = toCurrency;
    data['icon'] = icon;
    
    data['buying'] = buying;
    data['selling'] = selling;
    data['remittances'] = remittances;
    data['exRate'] = exRate;
    data['toCurrencyFull'] = toCurrencyFull;

    return data;
  }
}
