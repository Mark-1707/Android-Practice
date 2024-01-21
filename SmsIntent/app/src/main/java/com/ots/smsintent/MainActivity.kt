package com.ots.smsintent

import android.Manifest
import android.app.AlertDialog
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationRequest
import android.os.Build
import android.os.Bundle
import android.provider.Telephony.Sms.Intents.SMS_RECEIVED_ACTION
import android.util.Log
import android.view.WindowManager
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.annotation.RequiresApi
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.wrapContentSize
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Card
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.work.Constraints
import androidx.work.NetworkType
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import com.ots.smsintent.ui.theme.SmsIntentTheme


class MainActivity : ComponentActivity() {

    private val smsPermissionRequestCode = 101
    private val notificationPermissionRequestCode = 102

    val TAG = "Location Access"
    val LOC_TAG = "Location"

    private lateinit var fusedLocationClient: FusedLocationProviderClient
    lateinit var mCurrentLocation: Location

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContent {
            SmsIntentTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    MyApp()
                }
            }
        }



        requestPermissions()

        val manufacturer = "xiaomi"
        if (manufacturer.equals(Build.MANUFACTURER, ignoreCase = true)) {
            //this will open auto start screen where user can enable permission for your app
            val intent = Intent()
            intent.setComponent(
                ComponentName(
                    "com.miui.securitycenter",
                    "com.miui.permcenter.autostart.AutoStartManagementActivity"
                )
            )
            startActivity(intent)
        }

        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)


        val requestPermissionLauncher =   registerForActivityResult(ActivityResultContracts.RequestMultiplePermissions()){
                permissions ->
            when {
                permissions.getOrDefault(android.Manifest.permission.ACCESS_FINE_LOCATION, false) -> {
                    Log.d(TAG, "ACCESS_FINE_LOCATION")
                }
                permissions.getOrDefault(android.Manifest.permission.ACCESS_COARSE_LOCATION, false) -> {
                    // Only approximate location access granted.
                    Log.d(TAG, "ACCESS_COARSE_LOCATION")
                }
                permissions.getOrDefault(android.Manifest.permission.SYSTEM_ALERT_WINDOW, false) -> {
                Log.d(TAG, "SYSTEM_ALERT_WINDOW")
            }
                else -> {
                // No location access granted.
                Log.d(TAG, "Denied")
            }
            }

        }


        when{
            ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION)
                    == PackageManager.PERMISSION_GRANTED ->{
                Log.d("Location", "Permission is granted")
                fusedLocationClient.lastLocation
                    .addOnSuccessListener {
                            location: Location ->
                        mCurrentLocation = location
                        Log.d(LOC_TAG, location.toString())
                    }

                fusedLocationClient.getCurrentLocation(Priority.PRIORITY_HIGH_ACCURACY, null).addOnSuccessListener {
                        location: Location ->
                    mCurrentLocation = location
                    Log.d("Current Location", location.toString())
                }
            }
            ActivityCompat.shouldShowRequestPermissionRationale(
                this, android.Manifest.permission.ACCESS_FINE_LOCATION

            ) -> {
                Log.d("Location", "Grant a permission")
                requestPermissionLauncher.launch(
                    arrayOf(
                        android.Manifest.permission.ACCESS_FINE_LOCATION,
                        android.Manifest.permission.ACCESS_COARSE_LOCATION,
                        android.Manifest.permission.SYSTEM_ALERT_WINDOW
                    )
                )
            }else -> {
            requestPermissionLauncher.launch(
                arrayOf(
                    android.Manifest.permission.ACCESS_FINE_LOCATION,
                    android.Manifest.permission.ACCESS_COARSE_LOCATION,
                    android.Manifest.permission.SYSTEM_ALERT_WINDOW
                )
            )
        }
        }


    }

    private fun askForPermission(){

    }


    @RequiresApi(Build.VERSION_CODES.O)
    private fun requestPermissions() {
        if (!hasSmsPermission()) {
            requestSmsPermission()
        }

        if (!hasNotificationPermission()) {
            requestNotificationPermission()
        }
    }

    private fun hasSmsPermission(): Boolean {
        return ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.RECEIVE_SMS
        ) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestSmsPermission() {

        val smsReceiver = SmsReceiver()
        val intentFilter = IntentFilter("android.provider.Telephony.SMS_RECEIVED")
        registerReceiver(smsReceiver, intentFilter)

        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.RECEIVE_SMS),
            smsPermissionRequestCode
        )
    }

    private fun hasNotificationPermission(): Boolean {
        return ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.VIBRATE
        ) == PackageManager.PERMISSION_GRANTED
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun requestNotificationPermission() {
        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.VIBRATE),
            notificationPermissionRequestCode
        )

        startForegroundService(Intent(this, MyTest::class.java))
    }



}


@Composable
fun SmsReceiverScreen() {
    var smsSender by remember { mutableStateOf("") }
    var smsContent by remember { mutableStateOf("") }

    val context = LocalContext.current

    // Check SMS conditions and show notification
    if (smsSender.isNotBlank() && smsContent.isNotBlank()) {
        showNotification(context, smsSender, smsContent)
        // Reset values to avoid showing the same notification multiple times
        smsSender = ""
        smsContent = ""
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text("SMS Receiver App", style = MaterialTheme.typography.bodySmall)

        Spacer(modifier = Modifier.height(16.dp))

        Text("Sender: $smsSender")
        Text("Content: $smsContent")
    }
}

fun showNotification(context: Context, sender: String, content: String) {
    // Create notification channel
    createNotificationChannel(context)

    val builder = NotificationCompat.Builder(context, "sms_channel")
        .setSmallIcon(R.drawable.ic_launcher_foreground)
        .setContentTitle("New SMS from $sender")
        .setContentText(content)
        .setPriority(NotificationCompat.PRIORITY_DEFAULT)

    with(NotificationManagerCompat.from(context)) {
        if (ActivityCompat.checkSelfPermission(
                context,
                Manifest.permission.POST_NOTIFICATIONS
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            return
        }
        notify(1, builder.build())
    }
}

fun createNotificationChannel(context: Context) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        val channel = NotificationChannel(
            "sms_channel",
            "SMS Channel",
            NotificationManager.IMPORTANCE_DEFAULT
        )
        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.createNotificationChannel(channel)
    }
}

@Composable
fun MyApp() {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = "smsReceiverScreen") {
        composable("smsReceiverScreen") { SmsReceiverScreen() }
        // Add other destinations as needed
    }
}

@Preview(showBackground = true)
@Composable
fun DefaultPreview() {
    SmsIntentTheme {
        MyApp()
    }
}
