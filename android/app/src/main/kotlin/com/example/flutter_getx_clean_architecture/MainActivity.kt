package com.example.flutter_getx_clean_architecture

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.google.android.gms.location.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.flutter_getx_clean_architecture/gps"
    private val EVENT_CHANNEL = "com.flutter_getx_clean_architecture/gps_stream"
    private val LOCATION_PERMISSION_REQUEST_CODE = 1001

    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private var locationCallback: LocationCallback? = null
    private var eventSink: EventChannel.EventSink? = null
    private var isTracking = false

    private val handler = Handler(Looper.getMainLooper())
    private var locationUpdateRunnable: Runnable? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        // Method Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "isGpsEnabled" -> {
                    result.success(isGpsEnabled())
                }
                "startGpsTracking" -> {
                    if (checkLocationPermission()) {
                        startGpsTracking()
                        result.success(true)
                    } else {
                        requestLocationPermission()
                        result.success(false)
                    }
                }
                "stopGpsTracking" -> {
                    stopGpsTracking()
                    result.success(true)
                }
                "getCurrentLocation" -> {
                    if (checkLocationPermission()) {
                        getCurrentLocation(result)
                    } else {
                        result.error("PERMISSION_DENIED", "Location permission not granted", null)
                    }
                }
                "requestLocationPermission" -> {
                    if (checkLocationPermission()) {
                        result.success(true)
                    } else {
                        requestLocationPermission()
                        result.success(false)
                    }
                }
                "openLocationSettings" -> {
                    openLocationSettings()
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        // Event Channel for streaming location updates
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            }
        )
    }

    private fun isGpsEnabled(): Boolean {
        val locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
        return locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
    }

    private fun checkLocationPermission(): Boolean {
        return ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestLocationPermission() {
        val permissions = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            arrayOf(
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION,
                Manifest.permission.ACCESS_BACKGROUND_LOCATION
            )
        } else {
            arrayOf(
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION
            )
        }

        ActivityCompat.requestPermissions(
            this,
            permissions,
            LOCATION_PERMISSION_REQUEST_CODE
        )
    }

    private fun startGpsTracking() {
        if (!checkLocationPermission()) {
            return
        }

        if (isTracking) {
            return
        }

        isTracking = true

        // Create location update runnable that runs every 2 seconds
        locationUpdateRunnable = object : Runnable {
            override fun run() {
                if (isTracking && checkLocationPermission()) {
                    try {
                        fusedLocationClient.lastLocation
                            .addOnSuccessListener { location: Location? ->
                                location?.let {
                                    sendLocationUpdate(it)
                                }
                            }
                            .addOnFailureListener { exception ->
                                eventSink?.error(
                                    "LOCATION_ERROR",
                                    "Failed to get location: ${exception.message}",
                                    null
                                )
                            }
                    } catch (e: SecurityException) {
                        eventSink?.error("PERMISSION_ERROR", e.message, null)
                    }

                    // Schedule next update after 2 seconds
                    handler.postDelayed(this, 2000)
                }
            }
        }

        // Start the periodic updates
        handler.post(locationUpdateRunnable!!)

        // Also request location updates from FusedLocationProviderClient
        val locationRequest = LocationRequest.Builder(
            Priority.PRIORITY_HIGH_ACCURACY,
            2000 // 2 seconds interval
        ).apply {
            setMinUpdateIntervalMillis(1000)
            setMaxUpdateDelayMillis(2000)
        }.build()

        locationCallback = object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult) {
                locationResult.lastLocation?.let { location ->
                    sendLocationUpdate(location)
                }
            }
        }

        try {
            fusedLocationClient.requestLocationUpdates(
                locationRequest,
                locationCallback!!,
                Looper.getMainLooper()
            )
        } catch (e: SecurityException) {
            eventSink?.error("PERMISSION_ERROR", e.message, null)
        }
    }

    private fun stopGpsTracking() {
        isTracking = false

        // Cancel periodic updates
        locationUpdateRunnable?.let {
            handler.removeCallbacks(it)
        }
        locationUpdateRunnable = null

        // Remove location updates from FusedLocationProviderClient
        locationCallback?.let {
            fusedLocationClient.removeLocationUpdates(it)
        }
        locationCallback = null
    }

    private fun sendLocationUpdate(location: Location) {
        val locationData = hashMapOf<String, Any>(
            "latitude" to location.latitude,
            "longitude" to location.longitude,
            "accuracy" to location.accuracy.toDouble(),
            "altitude" to location.altitude,
            "timestamp" to System.currentTimeMillis()
        )

        eventSink?.success(locationData)
    }

    private fun getCurrentLocation(result: MethodChannel.Result) {
        if (!checkLocationPermission()) {
            result.error("PERMISSION_DENIED", "Location permission not granted", null)
            return
        }

        try {
            fusedLocationClient.lastLocation
                .addOnSuccessListener { location: Location? ->
                    if (location != null) {
                        val locationData = hashMapOf<String, Any>(
                            "latitude" to location.latitude,
                            "longitude" to location.longitude,
                            "accuracy" to location.accuracy.toDouble(),
                            "altitude" to location.altitude,
                            "timestamp" to System.currentTimeMillis()
                        )
                        result.success(locationData)
                    } else {
                        result.error("NO_LOCATION", "No location available", null)
                    }
                }
                .addOnFailureListener { exception ->
                    result.error("LOCATION_ERROR", exception.message, null)
                }
        } catch (e: SecurityException) {
            result.error("PERMISSION_ERROR", e.message, null)
        }
    }

    private fun openLocationSettings() {
        val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
        startActivity(intent)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode == LOCATION_PERMISSION_REQUEST_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // Permission granted
                startGpsTracking()
            }
        }
    }

    override fun onDestroy() {
        stopGpsTracking()
        super.onDestroy()
    }
}