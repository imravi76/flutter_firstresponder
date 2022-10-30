import 'dart:convert';

Rule ruleFromJson(String str) {
  final jsonData = json.decode(str);
  return Rule.fromMap(jsonData);
}

class Rule {

  final int id;
  final String status;
  final String received_msg;
  final String reply_message;
  final String reply_count;
  final String contacts;
  final String ignored_contacts;

  const Rule({required this.id, required this.status, required this.received_msg, required this.reply_message,
      required this.reply_count, required this.contacts, required this.ignored_contacts});

  Map<String, dynamic> toMap() => {

  "id": id,
  "status": status,
  "received_msg": received_msg,
  "reply_message": reply_message,
  "reply_count": reply_count,
  "contacts": contacts,
  "ignored_contacts": ignored_contacts,

  };

  factory Rule.fromMap(Map<String, dynamic> json) => Rule(
    id: json["id"],
    status: json["status"],
    received_msg: json["received_msg"],
    reply_message: json["reply_message"],
    reply_count: json["reply_count"],
    contacts: json["contacts"],
    ignored_contacts: json["ignored_contacts"],

  );

}
