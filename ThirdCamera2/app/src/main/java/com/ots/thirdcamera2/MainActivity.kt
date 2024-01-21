package com.ots.thirdcamera2

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.hardware.usb.UsbAccessory
import android.hardware.usb.UsbConstants
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.camera.core.CameraSelector
import java.util.HashMap

class MainActivity : AppCompatActivity() {

    private val ACTION_USB_PERMISSION = "com.ots.thirdcamera2.USB_PERMISSION"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val usbManager = getSystemService(Context.USB_SERVICE) as UsbManager

        // Check if accessoryList is not null before accessing it
        val accessoryList: HashMap<String, UsbDevice>? = usbManager.deviceList
        if (accessoryList != null && accessoryList.isNotEmpty()) {
            // Iterate through the connected USB devices
            for ((_, device) in accessoryList) {
                if (true) {
                    // Request permission to access the USB camera device
                    Log.d("Device ", device.deviceClass.toString())
                    Toast.makeText(this, device.deviceClass.toString(), Toast.LENGTH_LONG).show()
                    val permissionIntent = PendingIntent.getBroadcast(
                        this,
                        0,
                        Intent(ACTION_USB_PERMISSION),
                        PendingIntent.FLAG_IMMUTABLE
                    )
                    usbManager.requestPermission(device, permissionIntent)
                }
            }
        } else {
            // Handle the case where no USB camera device is found
            Log.d("USB", "No USB camera found")
        }

        // Register broadcast receiver for USB permission result
        val filter = IntentFilter(ACTION_USB_PERMISSION)
        registerReceiver(usbReceiver, filter)
    }

    private val usbReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (ACTION_USB_PERMISSION == intent.action) {
                synchronized(this) {
                    val granted = intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)
                    if (granted) {
                        // USB permission granted, access the USB camera device here
                        val device: UsbDevice? = intent.getParcelableExtra(UsbManager.EXTRA_DEVICE)
                        if (device != null) {
                            Log.d("Device Name", device.deviceName.toString())
                        } else {
                            Log.d("Device Name", "None")
                        }
                    } else {
                        Log.d("USB Permission", "Permission denied for the USB camera")
                    }
                }
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(usbReceiver)
    }
}
