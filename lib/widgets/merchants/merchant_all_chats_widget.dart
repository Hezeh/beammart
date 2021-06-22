import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/screens/merchants/chat_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class MerchantAllChatsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<AuthenticationProvider>(context);
    return SafeArea(
      child: Column(
        children: [
          SizedBox(),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .where(
                    'businessId',
                    isEqualTo: _userProvider.user!.uid,
                  )
                  .orderBy(
                    'lastMessageTimestamp',
                    descending: true,
                  )
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data!.docs.length == 0) {
                  return Center(
                    child: Text("You have no chats"),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Sorry. An error occurred"),
                  );
                }
                if (snapshot.data == null) {
                  return Center(
                    child: Text("Sorry. An error occurred"),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final datetime = snapshot.data!.docs[index]
                        .data()!['lastMessageTimestamp']
                        .toDate();
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MerchantChatDetailScreen(
                              chatId: snapshot.data!.docs[index].id,
                              consumerName: snapshot.data!.docs[index]
                                  .data()!['consumerDisplayName'],
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(
                            "${snapshot.data!.docs[index].data()!['consumerDisplayName']}"),
                        subtitle: Text(
                            "${snapshot.data!.docs[index].data()!['lastMessageContent']}"),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Jiffy(datetime).fromNow(),
                            ),
                            (snapshot.data!.docs[index]
                                            .data()!['businessUnread'] !=
                                        null &&
                                    snapshot.data!.docs[index]
                                            .data()!['businessUnread'] !=
                                        0)
                                ? CircleAvatar(
                                    backgroundColor: Colors.green,
                                    child: Text(
                                      "${snapshot.data!.docs[index].data()!['businessUnread']}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    minRadius: 0,
                                    maxRadius: 13,
                                  )
                                : Text(""),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
