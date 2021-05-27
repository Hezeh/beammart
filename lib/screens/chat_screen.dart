import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String? chatId;
  final String? businessName;
  final String? businessPhotoUrl;
  final String? businessId;
  final String? consumerId;
  final String? consumerDisplayName;

  ChatScreen({
    Key? key,
    required this.chatId,
    required this.businessName,
    this.businessPhotoUrl,
    required this.businessId,
    required this.consumerId,
    this.consumerDisplayName,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<FormState> _chatFormKey = GlobalKey<FormState>();

  final TextEditingController _messageController = TextEditingController();

  Future<void> sendMessage({
    required String? messageContent,
    required String? chatId,
  }) async {
    final CollectionReference _db = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages');
    final DocumentReference _chatRef =
        FirebaseFirestore.instance.collection('chats').doc(chatId);

    // Check whether chat exists
    final _chatDoc = await _chatRef.get();
    if (_chatDoc.exists) {
       _db.add({
        'timestamp': Timestamp.now(),
        'messageContent': messageContent,
        'sentByConsumer': true,
      });
      _chatRef.update({
        'lastMessageTimestamp': Timestamp.now(),
        'lastMessageContent': messageContent
      });
      FirebaseFirestore.instance.runTransaction(
        (transaction) async {
          final DocumentSnapshot freshSnap = await transaction.get(_chatRef);
          transaction.update(
            freshSnap.reference,
            {
              'businessUnread': freshSnap['businessUnread'] + 1,
            },
          );
        },
      );
    } else {
      _chatRef.set(
        {
          'lastMessageTimestamp': Timestamp.now(),
          'lastMessageContent': messageContent,
          'businessUnread': 1,
          'businessId': widget.businessId,
          'consumerId': widget.consumerId,
          'businessPhotoUrl': widget.businessPhotoUrl,
          'consumerDisplayName': widget.consumerDisplayName,
          'consumerUnread': 0,
          'businessName': widget.businessName
        },
        SetOptions(merge: true),
      );
      _db.add({
        'timestamp': Timestamp.now(),
        'messageContent': messageContent,
        'sentByConsumer': true,
      });
    }
  }

  updateUnreadMessages() async {
    final DocumentReference _chatRef =
        FirebaseFirestore.instance.collection('chats').doc(widget.chatId);
    final _doc = await _chatRef.get();
    if (_doc.exists) {
      _chatRef.update({'consumerUnread': 0});
    }
  }

  @override
  void didChangeDependencies() {
    updateUnreadMessages();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        // backgroundColor: Colors.cyan,
        flexibleSpace: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pink,
                  Colors.yellow,
                ],
              ),
            ),
            // padding: EdgeInsets.only(right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                // CircleAvatar(
                //   // backgroundImage: NetworkImage(
                //   //     "<https://randomuser.me/api/portraits/men/5.jpg>"),
                //   maxRadius: 20,
                // ),
                // SizedBox(
                //   width: 5,
                // ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${widget.businessName}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      // SizedBox(
                      //   height: 6,
                      // ),
                      // Text(
                      //   "Online",
                      //   style: TextStyle(
                      //       color: Colors.grey.shade600, fontSize: 13),
                      // ),
                    ],
                  ),
                ),
                // Icon(
                //   Icons.settings,
                //   color: Colors.black54,
                // ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(widget.chatId)
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.docs.length == 0) {
                    return Center(
                      child: Text("No Messages"),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("An Error Occurred"),
                    );
                  }
                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    padding: EdgeInsets.only(
                      top: 10,
                      bottom: 60,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(
                          left: 14,
                          right: 14,
                          top: 10,
                          bottom: 10,
                        ),
                        child: Align(
                          alignment: (!snapshot.data!.docs[index]
                                  .data()!['sentByConsumer']
                              ? Alignment.topLeft
                              : Alignment.topRight),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: (!snapshot.data!.docs[index]
                                      .data()!['sentByConsumer']
                                  ? Colors.grey.shade200
                                  : Colors.cyan[200]),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Text(
                              snapshot.data!.docs[index]
                                  .data()!['messageContent'],
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.pink,
                    Colors.purple,
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(
                left: 10,
              ),
              height: 55,
              // width: double.infinity,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Form(
                      key: _chatFormKey,
                      child: Center(
                        child: TextFormField(
                          // cursorHeight: 50,
                          controller: _messageController,
                          maxLines: 20,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.send,
                          validator: (value) {
                            if (value != null) {
                              return null;
                            } else {
                              return null;
                            }
                          },
                          onFieldSubmitted: (value) {
                            if (_chatFormKey.currentState!.validate()) {
                              sendMessage(
                                chatId: widget.chatId,
                                messageContent: value,
                              );
                              _chatFormKey.currentState!.reset();
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Type a message",
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      if (_chatFormKey.currentState!.validate()) {
                        sendMessage(
                          chatId: widget.chatId,
                          messageContent: _messageController.value.text,
                        );
                        _chatFormKey.currentState!.reset();
                      }
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 30,
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
