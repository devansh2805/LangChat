import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../backend/authentication.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();

  String countryCode;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Container(
        padding: const EdgeInsets.all(40.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new IntlPhoneField(
              controller: _phoneController,
              decoration: new InputDecoration(
                labelText: "Mobile Number",
                border: OutlineInputBorder(borderSide: BorderSide()),
              ),
              initialCountryCode: 'IN',
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (phone) {
                setState(() {
                  countryCode = phone.countryCode;
                });
              },
            ),
            new SizedBox(
              height: 16,
            ),
            new RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              onPressed: () {
                final phoneNumber = countryCode + _phoneController.text.trim();
                Auth().loginUser(phoneNumber, context);
              },
              child: Text('Login'),
              textColor: Colors.white,
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}
