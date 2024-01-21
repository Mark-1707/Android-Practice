package com.ots.smsintent

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.os.Looper
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.lifecycle.ViewModelProvider
import androidx.work.Worker
import androidx.work.WorkerParameters
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.LocationSettingsRequest
import com.google.android.gms.location.LocationSettingsResponse
import com.google.android.gms.location.SettingsClient
import com.google.android.gms.tasks.Task
import com.ots.smsintent.data.LocationData
import com.ots.smsintent.network.ApiService
import com.ots.smsintent.network.LocationApi
import kotlinx.coroutines.runBlocking
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import kotlin.properties.Delegates


class LogLocationWorker(private val context: Context, workerParams: WorkerParameters) :
    Worker(context, workerParams) {


    lateinit var locationRequest : LocationRequest
    private lateinit var locationCallback: LocationCallback
    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private var startTime by Delegates.notNull<Long>()
    val locationsList = mutableListOf<Pair<Double, Double>>()

    override fun doWork(): Result {
        Log.d("Tag", "Work starts after specific time")

        locationCallback = object : LocationCallback() {
            override fun onLocationResult(p0: LocationResult) {



                val retrofit = Retrofit.Builder()
                    .baseUrl("http://192.168.1.8:3000/rapidResponseAPI/api/v1/attendance/")
                    .addConverterFactory(GsonConverterFactory.create())
                    .build()
                val apiService = retrofit.create(ApiService::class.java)

                // Prepare your list of data
                p0
                for (location in p0.locations){
                    val longitude = location.longitude
                    val latitude = location.latitude
                    locationsList.add(Pair(longitude, latitude))
                    Log.d("Update", location.toString())

                }
                if (System.currentTimeMillis() - startTime >= 1 * 60 * 100) {
                    try{
                        runBlocking{
                            val postData = LocationData(1, locationsList)
                            val response = apiService.sendLocationData(postData)
                            if(response.isSuccessful){
                                Log.d("Response", response.body().toString())
                            }else{
                                Log.d("Response", Result.failure().toString())
                            }
                        }
                    }catch (e: Exception){
                        Log.e("MyWorker", "Error making POST request", e)
                    }
                    stopLocationUpdates()
                }
            }
        }


        createLocationRequest(context)
        startTime = System.currentTimeMillis()
        startLocationUpdates(context)

        return Result.success()
    }

    private fun startLocationUpdates(context: Context) {
        if (ActivityCompat.checkSelfPermission(
                context,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                context,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {

            return
        }

        fusedLocationClient = LocationServices.getFusedLocationProviderClient(context)

        fusedLocationClient.requestLocationUpdates(locationRequest,
            locationCallback,
            Looper.getMainLooper())
    }

    fun createLocationRequest(context: Context) {
        locationRequest = LocationRequest.Builder(2000)
            .setIntervalMillis(2000)
            .setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY)
            .build()

        val builder = LocationSettingsRequest.Builder()
            .addLocationRequest(locationRequest)

        val client: SettingsClient = LocationServices.getSettingsClient(context)
        val task: Task<LocationSettingsResponse> = client.checkLocationSettings(builder.build())
        task.addOnSuccessListener {
                response ->
            Log.i("Location Request Settings", response.locationSettingsStates.toString())
        }


//        task.addOnFailureListener { exception ->
//            if (exception is ResolvableApiException){
//                // Location settings are not satisfied, but this can be fixed
//                // by showing the user a dialog.
//                try {
//                    // Show the dialog by calling startResolutionForResult(),
//                    // and check the result in onActivityResult().
//                    exception.startResolutionForResult(this,
//                        1)
//                } catch (sendEx: IntentSender.SendIntentException) {
//                    // Ignore the error.
//                }
//            }
//        }


    }

    private fun stopLocationUpdates() {
        if (::fusedLocationClient.isInitialized) {
            fusedLocationClient.removeLocationUpdates(locationCallback)
            Log.d("Update", "Location updates stopped")

        }
    }

}