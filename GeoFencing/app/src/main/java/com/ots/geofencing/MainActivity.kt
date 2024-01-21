package com.ots.geofencing

import android.Manifest
import android.content.IntentSender
import android.content.pm.PackageManager
import android.location.Location
import android.os.Bundle
import android.os.Looper
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.google.android.gms.common.api.ResolvableApiException
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.LocationSettingsRequest
import com.google.android.gms.location.LocationSettingsResponse
import com.google.android.gms.location.Priority
import com.google.android.gms.location.SettingsClient
import com.google.android.gms.tasks.Task
import com.ots.geofencing.ui.theme.GeoFencingTheme

class MainActivity : ComponentActivity() {

    val TAG = "Location Access"
    val LOC_TAG = "Location"

    private lateinit var fusedLocationClient: FusedLocationProviderClient
    lateinit var mCurrentLocation: Location
    lateinit var locationRequest : LocationRequest
    private lateinit var locationCallback: LocationCallback


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            GeoFencingTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    Greeting("Android")
                }
            }
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
                } else -> {
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
                    // In an educational UI, explain to the user why your app requires this
                    // permission for a specific feature to behave as expected, and what
                    // features are disabled if it's declined. In this UI, include a
                    // "cancel" or "no thanks" button that lets the user continue
                    // using your app without granting the permission.
                    Log.d("Location", "Grant a permission")
                    requestPermissionLauncher.launch(
                        arrayOf(
                            android.Manifest.permission.ACCESS_FINE_LOCATION,
                            android.Manifest.permission.ACCESS_COARSE_LOCATION
                        )
                    )
                }else -> {
                // You can directly ask for the permission.
                // The registered ActivityResultCallback gets the result of this request.
                requestPermissionLauncher.launch(
                    arrayOf(
                        android.Manifest.permission.ACCESS_FINE_LOCATION,
                        android.Manifest.permission.ACCESS_COARSE_LOCATION
                    )
                )
            }
        }
        createLocationRequest()

        locationCallback = object : LocationCallback() {
            override fun onLocationResult(p0: LocationResult) {
                p0
                for (location in p0.locations){
                    Log.d("Update", location.toString())
                }
            }
        }


    }

    fun createLocationRequest() {
        locationRequest = LocationRequest.Builder(5000)
            .setIntervalMillis(5000)
            .setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY)
            .build()

        val builder = LocationSettingsRequest.Builder()
            .addLocationRequest(locationRequest)

        val client: SettingsClient = LocationServices.getSettingsClient(this)
        val task: Task<LocationSettingsResponse> = client.checkLocationSettings(builder.build())
        task.addOnSuccessListener {
            response ->
            Log.i("Location Request Settings", response.locationSettingsStates.toString())
        }


        task.addOnFailureListener { exception ->
            if (exception is ResolvableApiException){
                // Location settings are not satisfied, but this can be fixed
                // by showing the user a dialog.
                try {
                    // Show the dialog by calling startResolutionForResult(),
                    // and check the result in onActivityResult().
                    exception.startResolutionForResult(this@MainActivity,
                        1)
                } catch (sendEx: IntentSender.SendIntentException) {
                    // Ignore the error.
                }
            }
        }


    }


    override fun onResume() {
        super.onResume()
        startLocationUpdates()
    }

    private fun startLocationUpdates() {
        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            return
        }
        fusedLocationClient.requestLocationUpdates(locationRequest,
            locationCallback,
            Looper.getMainLooper())
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
    GeoFencingTheme {
        Greeting("Android")
    }
}