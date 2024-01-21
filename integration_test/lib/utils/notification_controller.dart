import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

AudioPlayer player = AudioPlayer();
final service = FlutterBackgroundService();
//final _audioHandler = getIt<AudioHandler>();


class NotificationController {
  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here

    /// Handles regular notification taps.
    if (receivedAction.actionType == ActionType.Default) {
      //if (receivedAction.id == 100) {
      log("Button clicked on notifiaction");
      // do something...
      //}
      player.stop();
    }
  }

  init() async {}
}
