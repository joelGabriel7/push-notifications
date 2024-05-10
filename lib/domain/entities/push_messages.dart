class PushMessages {
  final String messagID;
  final String title;
  final String body;
  final DateTime sendDate;
  final Map<String, dynamic>? data;
  final String? imageUrl;

  PushMessages({
  required this.messagID, 
  required this.title, 
  required this.body, 
  required this.sendDate, 
  this.data, 
  this.imageUrl
 });

  @override
  String toString() {
    return ''' 
    PushMessages -
      messagID: $messagID,
      title: $title,
      body: $body,
      sendDate: $sendDate,
      data: $data,
      imageUrl: $imageUrl
    
    ''';
  }

}
