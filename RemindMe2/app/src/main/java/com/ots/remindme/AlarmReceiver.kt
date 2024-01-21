package com.ots.remindme

// AlarmReceiver.kt
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.RingtoneManager
import android.widget.Toast

class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        // Show a toast or perform any action when the alarm is triggered
        Toast.makeText(context, "Alarm! It's 11 PM.", Toast.LENGTH_LONG).show()

        // You can also play a notification sound
        val notification = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
        val ringtone = RingtoneManager.getRingtone(context, notification)
        ringtone.play()
    }
}
