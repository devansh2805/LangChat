import 'package:LangChat/backend/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  bool loading = true;
  DocumentSnapshot userDetails;

  void fetchData() async {
    userDetails =
        await Database().getUserDetails('LSRUHSGOvneWaWSzBjrIh3NVnR72');
    loading = false;
    setState(() {});
  }

  String getInitials(String name) {
    String intitials = '';
    name.split(' ').forEach((word) {
      if (word.length > 0) {
        intitials += word[0].toUpperCase();
      }
    });
    return intitials;
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !loading
        ? StreamBuilder(
            stream: Database().fetchUsers(userDetails['uid']),
            builder: (context, snapshot) {
              return (snapshot.hasData)
                  ? ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          margin: EdgeInsets.all(6),
                          child: ListTile(
                              leading: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child: Text(getInitials(ds['name']),
                                      style: GoogleFonts.roboto(
                                        fontSize: 15,
                                      ))),
                              title: Text(ds['name']),
                              subtitle: Text('Chat snippet for $index'),
                              trailing: Icon(
                                Icons.check,
                                color: Color.fromRGBO(0, 20, 200, 0.4),
                              ),
                              onTap: () {
                                // SnackBar snackbar = SnackBar(
                                //   content: Text('you tapped $index'),
                                // );
                                // Scaffold.of(context).showSnackBar(snackbar);
                              }),
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.indigo[500],
                      ),
                    );
            },
          )
        : Center(child: CircularProgressIndicator());
    //   var listItems = getListElements();
    //   var listView = ListView.builder(
    //     itemBuilder: (context, index) {
    //       return ListTile(
    //           leading: Icon(Icons.supervised_user_circle),
    //           title: Text(listItems[index]),
    //           subtitle: Text('Chat snippet for $index'),
    //           trailing: Icon(
    //             Icons.check,
    //             color: Color.fromRGBO(0, 20, 200, 0.4),
    //           ),
    //           onTap: () {
    //             SnackBar snackbar = SnackBar(
    //               content: Text('you tapped $index'),
    //             );
    //             Scaffold.of(context).showSnackBar(snackbar);
    //           });
    //     },
    //     itemCount: listItems.length,
    //   );
    //   return listView;
    // }
  }
}
