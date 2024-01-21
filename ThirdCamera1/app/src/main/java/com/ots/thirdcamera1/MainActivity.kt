package com.ots.thirdcamera1
import android.Manifest
import android.app.PendingIntent
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.hardware.camera2.CameraMetadata.LENS_FACING_BACK
import android.hardware.usb.UsbConstants
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import androidx.appcompat.app.AppCompatActivity
import androidx.camera.core.ImageCapture
import androidx.camera.video.Recorder
import androidx.camera.video.Recording
import androidx.camera.video.VideoCapture
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.ots.thirdcamera1.databinding.ActivityMainBinding
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.core.Preview
import androidx.camera.core.CameraSelector
import android.util.Log
import androidx.annotation.OptIn
import androidx.camera.core.CameraSelector.LENS_FACING_EXTERNAL
import androidx.camera.core.CameraSelector.LENS_FACING_UNKNOWN
import androidx.camera.core.ExperimentalLensFacing
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.ImageCaptureException
import androidx.camera.core.ImageProxy
import androidx.camera.video.FallbackStrategy
import androidx.camera.video.MediaStoreOutputOptions
import androidx.camera.video.Quality
import androidx.camera.video.QualitySelector
import androidx.camera.video.VideoRecordEvent
import androidx.core.content.PermissionChecker
import java.nio.ByteBuffer
import java.text.SimpleDateFormat
import java.util.Locale
import androidx.lifecycle.LifecycleOwner

typealias LumaListener = (luma: Double) -> Unit


class MainActivity : AppCompatActivity() {



    private lateinit var usbManager: UsbManager
    private lateinit var usbReceiver: UsbReceiver


    private lateinit var viewBinding: ActivityMainBinding

    private var imageCapture: ImageCapture? = null

    private var videoCapture: VideoCapture<Recorder>? = null
    private var recording: Recording? = null

    private lateinit var cameraExecutor: ExecutorService

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        viewBinding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(viewBinding.root)

        usbManager = getSystemService(Context.USB_SERVICE) as UsbManager



        // Request camera permissions
        if (allPermissionsGranted()) {
//            startCamera()
            checkAndRequestUsbPermission()
            requestCameraPermission()
        } else {
            requestPermissions()
        }

        usbReceiver = UsbReceiver()
        val filter = IntentFilter(UsbManager.ACTION_USB_DEVICE_ATTACHED)
        filter.addAction(ACTION_USB_PERMISSION)
        registerReceiver(usbReceiver, filter)

        // Set up the listeners for take photo and video capture buttons
        viewBinding.imageCaptureButton.setOnClickListener { takePhoto() }
        viewBinding.videoCaptureButton.setOnClickListener { captureVideo() }

        cameraExecutor = Executors.newSingleThreadExecutor()
    }

    private fun takePhoto() {}

    private fun captureVideo() {}


    @OptIn(ExperimentalLensFacing::class) private fun startCamera() {
        val cameraProviderFuture = ProcessCameraProvider.getInstance(this)

        cameraProviderFuture.addListener({
            // Used to bind the lifecycle of cameras to the lifecycle owner
            val cameraProvider: ProcessCameraProvider = cameraProviderFuture.get()

            // Preview
            val preview = Preview.Builder()
                .build()
                .also {
                    it.setSurfaceProvider(viewBinding.viewFinder.surfaceProvider)
                }

            // Select back camera as a default
f 
            Log.e("Result", cameraSelector.toString())

            try {
                // Unbind use cases before rebinding
                cameraProvider.unbindAll()

//                 Bind use cases to camera
                cameraProvider.bindToLifecycle(
                    this, cameraSelector, preview)

            } catch(exc: Exception) {
                Log.e(TAG, "Use case binding failed", exc)
            }

        }, ContextCompat.getMainExecutor(this))
    }

    private fun requestPermissions() {
        activityResultLauncher.launch(REQUIRED_PERMISSIONS)
    }

    private fun allPermissionsGranted() = REQUIRED_PERMISSIONS.all {
        ContextCompat.checkSelfPermission(
            baseContext, it) == PackageManager.PERMISSION_GRANTED
    }

    override fun onDestroy() {
        super.onDestroy()
        cameraExecutor.shutdown()
    }

    private val activityResultLauncher =
        registerForActivityResult(
            ActivityResultContracts.RequestMultiplePermissions())
        { permissions ->
            // Handle Permission granted/rejected
            var permissionGranted = true
            permissions.entries.forEach {
                if (it.key in REQUIRED_PERMISSIONS && it.value == false)
                    permissionGranted = false
            }
            if (!permissionGranted) {
                Toast.makeText(baseContext,
                    "Permission request denied",
                    Toast.LENGTH_SHORT).show()
            } else {
                startCamera()
            }
        }

    private val requestPermissionLauncher =
        registerForActivityResult(ActivityResultContracts.RequestPermission()) { isGranted: Boolean ->
            if (isGranted) {
                startCamera()
            } else {
                Toast.makeText(this, "Permission denied", Toast.LENGTH_SHORT).show()
            }
        }

    private fun requestCameraPermission() {
        when {
            ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.CAMERA
            ) == PackageManager.PERMISSION_GRANTED -> {
                // You have the camera permission, proceed with starting the camera
                startCamera()
            }
            else -> {
                // You don't have the camera permission, request it
                requestPermissionLauncher.launch(Manifest.permission.CAMERA)
            }
        }
    }

    private fun checkAndRequestUsbPermission() {
        val usbDevices: HashMap<String, UsbDevice> = usbManager.deviceList

        for ((_, device) in usbDevices) {
            // Check if the USB device matches the desired device
            if (device.deviceClass == UsbConstants.USB_CLASS_VIDEO) {
                // Check permission and request it if not granted
                Log.e("Device", device.deviceId.toString())
                if (!usbManager.hasPermission(device)) {
                    val permissionIntent = PendingIntent.getBroadcast(
                        this,
                        0,
                        Intent(ACTION_USB_PERMISSION),
                        PendingIntent.FLAG_IMMUTABLE
                    )
                    usbManager.requestPermission(device, permissionIntent)
                } else {
                    // You have permission, proceed with accessing the USB device
                    // Handle device connection and communication here
                }
            }

        }
    }


    companion object {
        private const val TAG = "CameraXApp"
        private const val FILENAME_FORMAT = "yyyy-MM-dd-HH-mm-ss-SSS"
        const val ACTION_USB_PERMISSION = "com.ots.thirdcamera1.USB_PERMISSION"
        private val REQUIRED_PERMISSIONS =
            mutableListOf (
                Manifest.permission.CAMERA,
                Manifest.permission.RECORD_AUDIO
            ).apply {
                if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.P) {
                    add(Manifest.permission.WRITE_EXTERNAL_STORAGE)
                }
            }.toTypedArray()
    }
}