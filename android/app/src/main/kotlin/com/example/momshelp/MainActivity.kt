package com.example.momshelp

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.PowerManager
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity(){
    private lateinit var wakeLock: PowerManager.WakeLock
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        acquireWakeLock()
        requestIgnoreBatteryOptimizations()
        super.configureFlutterEngine(flutterEngine)
    }
    private fun acquireWakeLock() {
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "MyApp::WakeLock")
        wakeLock.acquire(10*60*1000L /*10 minutes*/)
    }
    private fun requestIgnoreBatteryOptimizations() {
        val packageName = packageName
        val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS)
        intent.data = Uri.parse("package:$packageName")
        startActivity(intent)
    }

}
