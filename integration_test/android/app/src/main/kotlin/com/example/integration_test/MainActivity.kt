package com.example.integration_test

import android.content.Intent
import android.os.Build.VERSION_CODES
import android.util.Log
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/battery"

    @RequiresApi(VERSION_CODES.O)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->

            Log.d("Test Servie Call", "In Main")
            if (call.method == "getBatteryLevel") {
                val batteryLevel = getBatteryLevel()

                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    @RequiresApi(VERSION_CODES.O)
    private fun getBatteryLevel(): Int {
        Log.d("Test Servie Intent", "In Main")
        startForegroundService(Intent(this, SmsForegroundService::class.java))
        return 1
    }
}
