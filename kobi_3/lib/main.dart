import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './login.dart';

void main() async {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ValueNotifier<GraphQLClient> client;

  @override
  void initState() {
    super.initState();
    final HttpLink httpLink = HttpLink(
      'http://localhost:3000/course-schedule', // endpoint 등록
    );

    var authLink = AuthLink(
      getToken: () async => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
      // OR
      // getToken: () => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
    ); // 인증 토큰이 있다면 등록

    final Link link = authLink.concat(httpLink);

    var graphQLClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(
        store: InMemoryStore(),
        partialDataPolicy: PartialDataCachePolicy.accept,
      ),
    );

    client = ValueNotifier(graphQLClient);
  }
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
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
