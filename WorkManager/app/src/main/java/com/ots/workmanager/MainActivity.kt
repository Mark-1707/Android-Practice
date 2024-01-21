package com.ots.workmanager

import android.content.Context
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
import androidx.work.Constraints
import androidx.work.OneTimeWorkRequest
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.OutOfQuotaPolicy
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.WorkRequest
import com.ots.workmanager.ui.theme.WorkManagerTheme
import java.util.concurrent.TimeUnit

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            WorkManagerTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    Greeting("Android")
                }
            }
        }

        RequestWork(this)
    }
}

fun RequestWork(context: Context){
//    val workRequest: WorkRequest =
//        OneTimeWorkRequest.from(ReminderWorker::class.java)

    /*
    * One time work request
    */
//    val workRequest : WorkRequest = OneTimeWorkRequest
//        .Builder(ReminderWorker::class.java)
//        .setExpedited(OutOfQuotaPolicy.RUN_AS_NON_EXPEDITED_WORK_REQUEST)
//        .build()

    /*
        Periodic Work Request
     */

    val workRequest : WorkRequest =
        PeriodicWorkRequestBuilder<ReminderWorker>(15, TimeUnit.MINUTES, 1, TimeUnit.MINUTES)
        .build()

    WorkManager.getInstance(context)
        .enqueue(workRequest)
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
    WorkManagerTheme {
        Greeting("Android")
    }
}