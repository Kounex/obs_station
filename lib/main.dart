import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:obs_blade/utils/network_helper.dart';

import 'app.dart';
import 'models/connection.dart';
import 'models/past_stream_data.dart';
import 'models/settings.dart';
import 'types/enums/hive_keys.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(ConnectionAdapter());
  Hive.registerAdapter(PastStreamDataAdapter());
  Hive.registerAdapter(SettingsAdapter());

  await Hive.openBox<Connection>(
    HiveKeys.SavedConnections.name,
    compactionStrategy: (entries, deletedEntries) => deletedEntries > 50,
  );
  await Hive.openBox<PastStreamData>(
    HiveKeys.PastStreamData.name,
    compactionStrategy: (entries, deletedEntries) => deletedEntries > 50,
  );

  /// Settings is a singleton - therefore not really a use case
  /// for Hive since it persists data in a key value store manner
  /// (like tables) so you usually have several entities for each
  /// key, but since it is so fast and encrypted and easy to use
  /// we make sure we have an instance from the beginning and we
  /// won't add an additional one, instead save the current one
  Box<Settings> settingsBox = await Hive.openBox<Settings>(
    HiveKeys.Settings.name,
    compactionStrategy: (entries, deletedEntries) => deletedEntries > 50,
  );
  if (settingsBox.length == 0) {
    await settingsBox.add(Settings());
  }

  /// Ensure our object has all its default values set. If a property
  /// has been added afterwards, it may be set to null since hive
  /// tries to read the value of the saved property (which does not exist)
  /// then - in this method we check if the property is null now and
  /// set default values if thats the case
  settingsBox.get(0).setDefault();

  /// Register listener for detecting network change and status
  // NetworkHelper.activateNetworkConnectionListener();

  runApp(App());
}
