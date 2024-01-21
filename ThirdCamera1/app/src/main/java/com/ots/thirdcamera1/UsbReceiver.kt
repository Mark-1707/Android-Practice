package com.ots.thirdcamera1

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import com.ots.thirdcamera1.MainActivity.Companion.ACTION_USB_PERMISSION

class UsbReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        if (UsbManager.ACTION_USB_DEVICE_ATTACHED == action) {
            val usbDevice = intent.getParcelableExtra<UsbDevice>(UsbManager.EXTRA_DEVICE)
            // Check if the USB device matches the desired device
            if (usbDevice != null) {
                // Check permission and request it if not granted
                if (context.getSystemService(UsbManager::class.java).hasPermission(usbDevice)) {
                    // You have permission, proceed with accessing the USB device
                    // Handle device connection and communication here
                } else {
                    // Request USB permission from the user
                    val permissionIntent = PendingIntent.getBroadcast(
                        context,
                        0,
                        Intent(ACTION_USB_PERMISSION),
                        PendingIntent.FLAG_IMMUTABLE
                    )
                    context.getSystemService(UsbManager::class.java)
                        .requestPermission(usbDevice, permissionIntent)
                }
            }
        }
    }
}
