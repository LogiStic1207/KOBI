import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './login.dart';

void main() async {
  await initHiveForFlutter();

  runApp(MaterialApp(home: MyApp()));
}
class Config{
  
  static final HttpLink httpLink = HttpLink(
    'http://192.168.219.101:4000/',
  );
  static final AuthLink authLink = AuthLink(
    getToken: () async => 'Bearer <PERSONAL_TOKEN_KEY>',
  );
  static final Link link = authLink.concat(httpLink);

  static ValueNotifier<GraphQLClient> initClient() {
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: GraphQLCache(store: HiveStore()),
        link: link
      )
    );
    return client;
  }
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //late final ValueNotifier<GraphQLClient> client;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: Config.initClient(),
      child: MaterialApp(
        title: 'KOBI: 코리아텍 비서',
        home: Scaffold(
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Login(),
          ),
        ),
      ),
    );
  }
}
