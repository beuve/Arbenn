abstract class Constants {
  static const String serverHost = String.fromEnvironment(
    'SERVER_HOST',
    defaultValue: '127.0.0.1',
  );

  static const String serverPort = String.fromEnvironment(
    'SERVER_PORT',
    defaultValue: '8080',
  );

  static const String typesenseHost = String.fromEnvironment(
    'TYPESENSE_HOST',
    defaultValue: '127.0.0.1',
  );

  static const String typesensePort = String.fromEnvironment(
    'TYPESENSE_PORT',
    defaultValue: '8108',
  );

  static const String typesensePass = String.fromEnvironment(
    'TYPESENSE_PASS',
    defaultValue: 'xyz',
  );
}
