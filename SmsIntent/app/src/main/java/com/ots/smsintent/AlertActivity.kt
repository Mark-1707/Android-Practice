package com.ots.smsintent

import android.os.Build
import android.os.Bundle
import android.view.ContextThemeWrapper
import android.view.WindowManager
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity

class AlertActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        showOverlayDialog()
    }

    private fun showOverlayDialog() {
        val dialogBuilder = AlertDialog.Builder(ContextThemeWrapper(this, R.style.Theme_Transparent))
        val dialogView = layoutInflater.inflate(R.layout.overlay_dialog, null)
        dialogBuilder.setView(dialogView)

        // Retrieve UI components
        val alertText = dialogView.findViewById<TextView>(R.id.alertText)
        val closeButton = dialogView.findViewById<Button>(R.id.closeButton)

        // Customize the dialog UI components
        alertText.text = "Emergency"

        // Set click listener for the close button


        val alertDialog = dialogBuilder.create()

        closeButton.setOnClickListener {
            alertDialog.dismiss()
            MediaPlayerSingleton.releaseMediaPlayer()
        }

        // Set the window type for Android 8.0 and higher
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            alertDialog.window?.setType(WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY)
        }

        // Set a dismiss listener to handle dialog dismissal
        alertDialog.setOnDismissListener {
            finish()
        }

        // Show the dialog
//        alertDialog.show()
    }

}
