import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kobi_3/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure plugin is initialized
  await initHiveForFlutter(); // Initialize Hive for GraphQL cache

  final HttpLink httpLink = HttpLink(
    'http://218.150.183.164:4000/graphql', // Correct the endpoint if necessary
  );

  final AuthLink authLink = AuthLink(
    getToken: () async =>
        'Bearer <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>', // Ensure your token is fetched correctly
  );

  final Link link = authLink.concat(httpLink);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: link,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );

  runApp(GraphQLProvider(
    client: client,
    child: MaterialApp(home: MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KOBI: 코리아텍 비서',
      home: Scaffold(
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Login(),
        ),
      ),
    );
  }
}
