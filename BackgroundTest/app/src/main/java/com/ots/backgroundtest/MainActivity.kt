package com.ots.backgroundtest

import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import com.ots.backgroundtest.ui.theme.BackgroundTestTheme
import androidx.work.*
import java.util.concurrent.TimeUnit


class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
//
//        // Schedule the worker without constraints
//        val notificationWorkRequest: WorkRequest =
//            PeriodicWorkRequestBuilder<NotificationWorker>(
//                repeatInterval = 15, // Set your desired repeat interval in minutes
//                repeatIntervalTimeUnit = TimeUnit.MINUTES
//            )
//                .build()
//
//        WorkManager.getInstance(this).enqueue(notificationWorkRequest)

//        startService(Intent(this, BackgroundService::class.java))

        val serviceIntent = Intent(this, ForegroundService::class.java)
        startService(serviceIntent)

//        val receiver = RestartServiceReceiver()
//        val filter = IntentFilter().apply {
//            addAction("RESTART_SERVICE")
//        }
//        registerReceiver(receiver, filter)

        setContent {
            BackgroundTestTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    Greeting("Android")
                }
            }
        }
    }
}

@Composable
fun Greeting(name: String, modifier: Modifier = Modifier) {
    Text(
        text = "Hello $name!",
        modifier = modifier
    )
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    BackgroundTestTheme {
        Greeting("Android")
    }
}