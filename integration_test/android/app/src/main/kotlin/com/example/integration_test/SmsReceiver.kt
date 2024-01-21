package com.example.integration_test

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.MediaPlayer
import android.provider.Telephony
import android.telephony.SmsMessage
import android.util.Log
import android.widget.Toast

class SmsReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context?, intent: Intent?) {

        Log.d("Find Intent action", intent?.action.toString())

        Log.d("Receiver", "Alarm Intent")

        if (Telephony.Sms.Intents.SMS_RECEIVED_ACTION == intent?.action) {
            val bundle = intent.extras
            if (bundle != null) {
                val pdus = bundle.get("pdus") as Array<*>
                for (pdu in pdus) {
                    val message = SmsMessage.createFromPdu(pdu as ByteArray)
                    val sender = message.originatingAddress
                    val body = message.messageBody

                    // Add your logic here to determine when to show a notification
                    // For example, you can check the sender or the content of the message
                    logReceivedSms(sender, body)
                    Log.d("onReceive", "Hello")
                    playNotificationSound(context)
                    // Display a toast for demonstration purposes
                    Toast.makeText(
                        context,
                        "Received SMS from $sender: $body",
                        Toast.LENGTH_SHORT
                    ).show()
                }
            }
        }

    }

    private fun logReceivedSms(sender: String?, body: String?) {
        Log.d("SmsReceiver", "Received SMS from $sender: $body")
    }

    private fun playNotificationSound(context: Context?) {
        try {
            val mediaPlayer = MediaPlayer.create(context, R.raw.alarm) // Put your sound file in the res/raw folder
            mediaPlayer.start()
        } catch (e: Exception) {
            Log.e("SmsReceiver", "Error playing notification sound: ${e.message}")
        }
    }
}
