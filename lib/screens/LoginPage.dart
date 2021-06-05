// login page
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool clicked = false;
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
              maxLength: 10,
              controller: _phoneController,
              decoration: new InputDecoration(
                labelText: "Mobile Number",
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
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
            clicked
                ? Column(
                    children: [
                      Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.indigo[400]),
                        ),
                      ),
                      Text(
                        'please wait for the verification code..',
                        style: GoogleFonts.lexendDeca(),
                      )
                    ],
                  )
                : Container(),
            new SizedBox(
              height: 16,
            ),
            new TextButton(
              onPressed: () async {
                final phoneNumber = countryCode + _phoneController.text.trim();
                setState(() => clicked = true);
                await Auth().loginUser(phoneNumber, context);
              },
              child: Text(
                'Login',
                style: GoogleFonts.lexendDeca(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.indigo[400],
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
