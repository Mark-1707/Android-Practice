package com.ots.remindme

import android.app.PendingIntent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import java.util.Calendar

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            AlarmApp()
        }
    }
}

@Composable
fun AlarmApp() {
    val context = LocalContext.current
    var isAlarmSet by remember { mutableStateOf(false) }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp)
    ) {
        Text("Alarm App", style = MaterialTheme.typography.bodyLarge)

        Spacer(modifier = Modifier.height(16.dp))

        Button(
            onClick = {
                setAlarm(context)
                isAlarmSet = true
            },
            enabled = !isAlarmSet
        ) {
            Text("Set Alarm")
        }

        Spacer(modifier = Modifier.height(16.dp))

        Text(
            if (isAlarmSet) "Alarm is set for 11 PM daily."
            else "Alarm is not set."
        )
    }
}

fun setAlarm(context: android.content.Context) {
    val calendar = Calendar.getInstance().apply {
        set(Calendar.HOUR_OF_DAY, 15)
        set(Calendar.MINUTE, 51)
        set(Calendar.SECOND, 0)
    }

    val alarmIntent = android.content.Intent(context, AlarmReceiver::class.java)
    val pendingIntent = android.app.PendingIntent.getBroadcast(
        context,
        0,
        alarmIntent,
        PendingIntent.FLAG_MUTABLE
    )

    val alarmManager =
        context.getSystemService(android.content.Context.ALARM_SERVICE) as android.app.AlarmManager
    alarmManager.setRepeating(
        android.app.AlarmManager.RTC_WAKEUP,
        calendar.timeInMillis,
        android.app.AlarmManager.INTERVAL_DAY,
        pendingIntent
    )
}
