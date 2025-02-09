enum ErrorKind { unknown, userInput, api }

final class ArbennException implements Exception {
  final String? userMessage;
  final String debug;
  final ErrorKind kind;

  const ArbennException(this.debug,
      {this.userMessage, this.kind = ErrorKind.unknown});
}
