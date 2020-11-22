import 'dart:convert';

class Voucher {
  String id;
  String title;
  String minimumSpend;
  String validity;
  String discount;
  String usedOn;
  Voucher({
    this.id,
    this.title,
    this.minimumSpend,
    this.validity,
    this.discount,
    this.usedOn,
  });
  String get getUsedOn => usedOn;

  set setUsedOn(String usedOn) => this.usedOn = usedOn;

  String get getId => id;

  set setId(String id) => this.id = id;

  String get getTitle => title;

  set setTitle(String title) => this.title = title;

  String get getMinimumSpend => minimumSpend;

  set setMinimumSpend(String minimumSpend) => this.minimumSpend = minimumSpend;

  String get getValidity => validity;

  set setValidity(String validity) => this.validity = validity;

  String get getDiscount => discount;

  set setDiscount(String discount) => this.discount = discount;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'minimumSpend': minimumSpend,
      'validity': validity,
      'discount': discount,
      'usedOn': usedOn,
    };
  }

  Voucher copyWith({
    String id,
    String title,
    String minimumSpend,
    String validity,
    String discount,
    String usedOn,
  }) {
    return Voucher(
      id: id ?? this.id,
      title: title ?? this.title,
      minimumSpend: minimumSpend ?? this.minimumSpend,
      validity: validity ?? this.validity,
      discount: discount ?? this.discount,
      usedOn: usedOn ?? this.usedOn,
    );
  }

  factory Voucher.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Voucher(
      id: map['id'],
      title: map['title'],
      minimumSpend: map['minimumSpend'],
      validity: map['validity'],
      discount: map['discount'],
      usedOn: map['usedOn'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Voucher.fromJson(String source) =>
      Voucher.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Voucher(id: $id, title: $title, minimumSpend: $minimumSpend, validity: $validity, discount: $discount, usedOn: $usedOn)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Voucher &&
        o.id == id &&
        o.title == title &&
        o.minimumSpend == minimumSpend &&
        o.validity == validity &&
        o.discount == discount &&
        o.usedOn == usedOn;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        minimumSpend.hashCode ^
        validity.hashCode ^
        discount.hashCode ^
        usedOn.hashCode;
  }
}
