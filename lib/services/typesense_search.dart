import 'package:typesense/typesense.dart';

const host = '10.0.2.2', protocol = Protocol.http;
final config = Configuration(
  'xyz',
  nodes: {
    Node.withUri(
      Uri(
        scheme: 'http',
        host: host,
        port: 8108,
      ),
    ),
  },
  numRetries: 3, // A total of 4 tries (1 original try + 3 retries)
  connectionTimeout: const Duration(seconds: 2),
);

final typesenseClient = Client(config);
