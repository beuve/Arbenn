import 'package:arbenn/data/event/event_data.dart';
import 'package:arbenn/data/user/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

bool isAttende(BuildContext context, EventData event) {
  int? userId = context.select((CredentialsNotifier creds) => creds.userId);
  if (userId == null) {
    throw Exception("User is null and shouldn't be");
  }
  return event.attendes.any((attende) => attende.userId == userId);
}

bool isAdmin(BuildContext context, EventData event) {
  int? userId = context.select((CredentialsNotifier creds) => creds.userId);
  if (userId == null) {
    throw Exception("User is null and shouldn't be");
  }
  return event.admin.userId == userId;
}
