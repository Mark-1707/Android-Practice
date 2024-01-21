package com.ots.backgroundtest

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class RestartServiceReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == Intent.ACTION_BOOT_COMPLETED) {
            // Restart the service when the device boots
            val serviceIntent = Intent(context, ForegroundService::class.java)
            context?.startService(serviceIntent)
        } else if (intent?.action == "RESTART_SERVICE") {
            // Restart the service when it's killed
            val serviceIntent = Intent(context, ForegroundService::class.java)
            context?.startService(serviceIntent)
        }
    }
}
