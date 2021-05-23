import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/screens/chat_screen.dart';
import 'package:beammart/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class AllChatsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<AuthenticationProvider>(context);
    if (_userProvider.user == null) {
      return LoginScreen(
        showCloseIcon: false,
      );
    }
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
              ),
              gradient: LinearGradient(
                colors: [
                  Colors.amber,
                  Colors.purple,
                  Colors.pinkAccent,
                ],
              ),
            ),
            child: Center(
              child: Text(
                "Your Chats",
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(),
          // Get all chats where userId is equal to current User

          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .where(
                    'consumerId',
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
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final datetime = snapshot.data!.docs[index]
                        .data()!['lastMessageTimestamp']
                        .toDate();
                    print(datetime);
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              chatId: snapshot.data!.docs[index].id,
                              businessName: snapshot.data!.docs[index]
                                  .data()!['businessName'],
                              consumerId: snapshot.data!.docs[index]
                                  .data()!['consumerId'],
                              businessId: snapshot.data!.docs[index]
                                  .data()!['businessId'],
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          foregroundImage: NetworkImage(
                            '${snapshot.data!.docs[index].data()!['businessPhotoUrl']}',
                          ),
                          radius: 30,
                          backgroundColor: Colors.pink,
                        ),
                        title: Text(
                          "${snapshot.data!.docs[index].data()!['businessName']}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          "${snapshot.data!.docs[index].data()!['lastMessageContent']}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Jiffy(datetime).fromNow(),
                            ),
                            (snapshot.data!.docs[index]
                                            .data()!['consumerUnread'] !=
                                        null &&
                                    snapshot.data!.docs[index]
                                            .data()!['consumerUnread'] !=
                                        0)
                                ? CircleAvatar(
                                    backgroundColor: Colors.green,
                                    child: Text(
                                      "${snapshot.data!.docs[index].data()!['consumerUnread']}",
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
