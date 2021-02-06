import 'package:flutter/material.dart';

class Calls extends StatelessWidget{
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
          subtitle: Text('Call for $index'),
          trailing: Icon(Icons.check),
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