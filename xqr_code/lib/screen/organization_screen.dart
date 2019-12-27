import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_auth0/flutter_auth0.dart';
import 'package:xqr_code/constants.dart';

class OrganizationScreen extends StatefulWidget {
  OrganizationScreen({Key key}) : super(key: key);

  @override
  _OrganizationScreenState createState() => _OrganizationScreenState();
}

class _OrganizationScreenState extends State<OrganizationScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 45, 56, 75),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClientInfoWidget()
            ],
          ),
    );
  }
}

class ClientInfoWidget extends StatefulWidget {
  ClientInfoWidget({Key key}) : super(key: key);

  @override
  ClientInfoWidgetState createState() => ClientInfoWidgetState();
}

class ClientInfoWidgetState extends State<ClientInfoWidget> {
  Auth0 auth0;
  String label = 'ok';

  @override
  void initState() {
    auth0 = Auth0(baseUrl: DotEnv().env['AUTH_URL'], clientId: DotEnv().env['CLIENT_ID']);
    var storage = FlutterSecureStorage();
    var token = storage.read(key: Constants.of(context).accessTokenKey);
    _printInfo(token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(color: Colors.white),
    );
  }

  void _printInfo(Future<String> accessToken) async {
    try {
      var auth0Auth = Auth0Auth(auth0.auth.clientId, auth0.auth.client.baseUrl, bearer: await accessToken);
      var info = await auth0Auth.getUserInfo();
      String buffer = '';
      info.forEach((k, v) => buffer = '$buffer\n$k: $v');
      setState(() {
        label = buffer;
      });
    } catch (e) {
      print(e);
    }
  }
}
