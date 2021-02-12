import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
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
            subtitle: Text('Contact details for $index'),
            trailing: Wrap(
              spacing: 12,
              children: <Widget>[
                Icon(Icons.call, color: Color.fromRGBO(0, 20, 200, 0.4)),
                Icon(Icons.message, color: Color.fromRGBO(0, 200, 20, 0.4)),
              ],
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
