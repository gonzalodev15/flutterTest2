
import 'package:flutter/material.dart';
import 'package:flutter_secondtest/Blocs/bloc.dart';
import 'package:flutter_secondtest/Pages/reminders_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState()  => _LoginPageState();
}

class ImageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var assetsImage = AssetImage('assets/List.png');
    var image = Image(image: assetsImage, width: 60.0, height: 60.0,);
    return Container(child: image);
  }

}

class _LoginPageState extends State<LoginPage> {

  changeThePage(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RemindersPage()));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Bloc();
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter login demo'),
      ),
      body: Center(
        child: Container(
            padding: EdgeInsets.all(40.0),
            child: Column(
              children: <Widget>[
                ImageList(),
                StreamBuilder<String>(
                  stream: bloc.email,
                  builder: (context, snapshot) => TextField(
                    onChanged: bloc.emailChanged,
                    keyboardType:  TextInputType.emailAddress,
                    decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: "Enter email",
                        labelText: "Email",
                        errorText: snapshot.error
                    ),
                  ),
                ),
                StreamBuilder<String>(
                  stream: bloc.password,
                  builder: (context, snapshot) => TextField(
                    onChanged: bloc.passwordChanged,
                    keyboardType:  TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        hintText: "Enter password",
                        labelText: "Password",
                      errorText: snapshot.error
                    ),
                  ),
                ),
                StreamBuilder<bool>(
                  stream: bloc.submitCheck,
                  builder: (context, snapshot) => RaisedButton(
                    color: Colors.pink,
                    onPressed:snapshot.hasData ? () => changeThePage(context):null,
                    child: Text("Submit"),
                    ),
                  ),
              ]),
            )
        ),
      );
  }

}
