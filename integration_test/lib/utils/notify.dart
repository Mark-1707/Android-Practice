
import 'package:awesome_notifications/awesome_notifications.dart';

class Notify {
  static Future<bool> instantNotify(String sms) async {
    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
    return awesomeNotifications.createNotification(
        content: NotificationContent(
          id: 100,
          title: "Breakdown Trains",
          body: sms,
          channelKey: 'instant_notification',
          //customSound: "resource://raw/notification",
        ),
        
        actionButtons: [
          NotificationActionButton(
            label: 'Stop',
            enabled: true,
            actionType: ActionType.Default,
            key: 'test',
          )
        ]);
  }
}
