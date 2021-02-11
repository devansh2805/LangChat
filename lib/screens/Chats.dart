import 'package:flutter/material.dart';

class Chats extends StatelessWidget {
  List<String> getListElements() {
    var items = List<String>.generate(50, (index) => "Name $index");
    return items;
  }

  Widget build(BuildContext context) {
    var listItems = getListElements();
    var listView = ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
            leading: Icon(Icons.supervised_user_circle),
            title: Text(listItems[index]),
            subtitle: Text('Chat snippet for $index'),
            trailing: Icon(
              Icons.check,
              color: Color.fromRGBO(0, 20, 200, 0.4),
            ),
            onTap: () {
              SnackBar snackbar = SnackBar(
                content: Text('you tapped $index'),
              );
              Scaffold.of(context).showSnackBar(snackbar);
            });
      },
      itemCount: listItems.length,
    );
    return listView;
  }
}
