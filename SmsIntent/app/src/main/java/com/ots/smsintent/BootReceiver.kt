package com.ots.smsintent

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.core.content.ContextCompat.startForegroundService

open class BootReceiver: BroadcastReceiver() {



    override fun onReceive(p0: Context, p1: Intent?) {

        startForegroundService(p0, Intent(p0, MyTest::class.java))
        Log.d("Boot Receiver", "Boot Receiver Called")
    }
}