package com.ots.smsintent

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.Handler
import android.os.HandlerThread
import android.os.IBinder
import android.os.Looper
import android.os.Message
import android.provider.Telephony.Sms.Intents.SMS_RECEIVED_ACTION
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.ServiceCompat

class MyTest : Service() {

    private var serviceLooper: Looper? = null
    private var serviceHandler: ServiceHandler? = null

    val filter = IntentFilter(SMS_RECEIVED_ACTION)
    val receiver = SmsReceiver()

    // Handler that receives messages from the thread
    private inner class ServiceHandler(looper: Looper) : Handler(looper) {

        @RequiresApi(Build.VERSION_CODES.TIRAMISU)
        override fun handleMessage(msg: Message) {
            // Normally we would do some work here, like download a file.
            // For our sample, we just sleep for 5 seconds.
            try {

                registerReceiver(receiver, filter, RECEIVER_EXPORTED)

                showNotification()

                //Thread.sleep(20000)
            } catch (e: InterruptedException) {
                // Restore interrupt status.
                Thread.currentThread().interrupt()
            }
            // Stop the service using the startId, so that we don't stop
            // the service in the middle of handling another job
            //stopSelf(msg.arg1)
        }
    }

    override fun onCreate() {
        // Start up the thread running the service.  Note that we create a
        // separate thread because the service normally runs in the process's
        // main thread, which we don't want to block.  We also make it
        // background priority so CPU-intensive work will not disrupt our UI.
        HandlerThread("ServiceStartArguments", 10).apply {
            start()
//            registerReceiver(receiver, filter)
//
//            showNotification()
            // Get the HandlerThread's Looper and use it for our Handler
            serviceLooper = looper
            serviceHandler = ServiceHandler(looper)
        }
    }

    @RequiresApi(Build.VERSION_CODES.UPSIDE_DOWN_CAKE)
    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        Toast.makeText(this, "service starting", Toast.LENGTH_SHORT).show()


        serviceHandler?.obtainMessage()?.also { msg ->
            msg.arg1 = startId
            serviceHandler?.sendMessage(msg)
        }

        // If we get killed, after returning from here, restart
        return START_REDELIVER_INTENT
    }


    private fun showNotification(){
        // Check SDK Version to create notification channel
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            // Create notification channel
            val name = getString(R.string.notification_channel_name)
            val descriptionText = getString(R.string.notification_channel_description)

            val importance = NotificationManager.IMPORTANCE_HIGH
            val mChannel = NotificationChannel("1", name, importance)
            mChannel.description = descriptionText
            // Register the channel with the system; you can't change the importance
            // or other notification behaviors after this
            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(mChannel)
        }

        var builder = NotificationCompat.Builder(this, "1")
            .setSmallIcon(androidx.core.R.drawable.ic_call_answer)
            .setContentTitle("Siren Service")
            .setContentText("Do not dismiss the app")
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setOngoing(true)

        with(NotificationManagerCompat.from(this)){
            if (ActivityCompat.checkSelfPermission(
                    applicationContext,
                    Manifest.permission.POST_NOTIFICATIONS
                ) != PackageManager.PERMISSION_GRANTED
            ) {

            }
            notify(1, builder.build())
        }

        ServiceCompat.startForeground(
            this, 1, builder.build(),
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK
            } else {
                0
            },
        )
    }

    override fun onBind(p0: Intent?): IBinder? {
//        TODO("Not yet implemented")
        return null
    }

    override fun onDestroy() {
        Toast.makeText(this, "service done", Toast.LENGTH_SHORT).show()
//        unregisterReceiver(receiver)
    }
}