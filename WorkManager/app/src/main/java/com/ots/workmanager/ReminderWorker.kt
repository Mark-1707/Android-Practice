package com.ots.workmanager

import android.content.Context
import android.util.Log
import android.widget.Toast
import androidx.work.Worker
import androidx.work.WorkerParameters

class ReminderWorker(context: Context, workerParams: WorkerParameters) : Worker(context,
    workerParams
) {

    override fun doWork(): Result {

        Log.d("Tag", "It works after every 15 minutes")
        return Result.success()

    }

}