import 'package:fitpass_app/home/home_route.dart';
import 'package:fitpass_app/login/user_model.dart';
import 'package:fitpass_app/network/api_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progress_dialog/progress_dialog.dart';

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  ProgressDialog pr;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _mobile = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  validateLogin() async {
    pr = new ProgressDialog(context);
    pr.show();
    Api api = Api();
    var response = await api.validateLogin(_mobile.text, _password.text);
    pr.hide().then((value) {

      if(response != null && response['code'] == 200){
        int userId = response['user_id'];
        String appKey = response['app_key'];

        print('$userId ,, $appKey');
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRoute(),
        settings: RouteSettings(
          arguments: UserModel(userId,appKey)
        )));
        print('login successfull');

      } else {
        print('invalid credentials');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _mobile,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Mobile number'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide mobile number';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _password,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Password'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide password';
                  }

                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                  child: Text("Login"),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      validateLogin();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
