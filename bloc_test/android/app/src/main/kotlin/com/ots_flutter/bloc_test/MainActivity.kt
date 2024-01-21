package com.ots_flutter.bloc_test

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.util.Log

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.ots_flutter.bloc_test/bloc_int_test"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if(call.method == "getValueFromNative"){
                Log.d("Check Function Call", true.toString())
                val returnValue= getValueFromNative();
                result.success(returnValue)
            }else{
                result.notImplemented()
            }
        }
    }

    private fun getValueFromNative(): Int {
        return 10
    }
}
