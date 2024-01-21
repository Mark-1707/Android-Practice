package com.ots.smsintent

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Context.NOTIFICATION_SERVICE
import android.content.ContextWrapper
import android.content.Intent
import android.content.pm.PackageManager
import android.media.MediaPlayer
import android.os.Build
import android.provider.Telephony
import android.telephony.SmsMessage
import android.util.Log
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationCompat.EXTRA_NOTIFICATION_ID
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat.startActivity
import androidx.work.OneTimeWorkRequest
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import java.util.concurrent.TimeUnit

class SmsReceiver : BroadcastReceiver() {

    private lateinit var mediaPlayer: MediaPlayer

    override fun onReceive(context: Context?, intent: Intent?) {

        if("STOP_MEDIA_PLAYER" == intent?.action){
            Log.d("Find Intent action", intent.action.toString())
            if(MediaPlayerSingleton.isPlaying() == true){
                MediaPlayerSingleton.releaseMediaPlayer()
            }
        }

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
                    playNotificationSound(context)
                    showNotification(context)
                    if (context != null) {
                        workRequest(context)
                    }

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

    private fun workRequest(context: Context) {
            val workRequest : OneTimeWorkRequest =
                OneTimeWorkRequestBuilder<LogLocationWorker>()
                    .setInitialDelay(10, TimeUnit.SECONDS)
                    .build()


        WorkManager.getInstance(context)
            .enqueue(workRequest)
    }


    private fun logReceivedSms(sender: String?, body: String?) {
        Log.d("SmsReceiver", "Received SMS from $sender: $body")
    }

    private fun playNotificationSound(context: Context?) {
        try {

            mediaPlayer = MediaPlayerSingleton.getMediaPlayer(context!!);
            mediaPlayer.start()

        } catch (e: Exception) {
            Log.e("SmsReceiver", "Error playing notification sound: ${e.message}")
        }
    }

    private fun showNotification(context: Context?){

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // Create the NotificationChannel.
            val name = "Test"
            val descriptionText = "Test"
            val importance = NotificationManager.IMPORTANCE_DEFAULT
            val mChannel = NotificationChannel("2", name, importance)
            mChannel.description = descriptionText
            // Register the channel with the system. You can't change the importance
            // or other notification behaviors after this.
            val notificationManager = ContextWrapper(context).getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(mChannel)
        }

        val goToApp = Intent(context, SmsReceiver::class.java).apply {
            action = "STOP_MEDIA_PLAYER"
            putExtra(EXTRA_NOTIFICATION_ID, 0)
        }


        val goToAppPendingIntent: PendingIntent =
            PendingIntent.getBroadcast(context, 0, goToApp, PendingIntent.FLAG_IMMUTABLE)

        var builder = context?.let {
            NotificationCompat.Builder(it, "2")
                .setSmallIcon(androidx.core.R.drawable.ic_call_answer)
                .setContentTitle("Test")
                .setContentText("Text")
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                .setContentIntent(goToAppPendingIntent)
                .addAction(androidx.core.R.drawable.notification_bg, "Stop", goToAppPendingIntent);
        }

        with(context?.let { NotificationManagerCompat.from(it) }) {
            // notificationId is a unique int for each notification that you must define.
            if (context?.let {
                    ActivityCompat.checkSelfPermission(
                        it,
                        Manifest.permission.POST_NOTIFICATIONS
                    )
                } != PackageManager.PERMISSION_GRANTED
            ) {
                return
            }
            this?.notify(2, builder!!.build() )
        }
    }

    private fun showAlert(context: Context){
        val intent = Intent(context, AlertActivity::class.java)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(context, intent, null);
    }
}
