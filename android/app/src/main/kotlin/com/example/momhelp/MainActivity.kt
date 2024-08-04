package com.example.momhelp

import android.app.AlarmManager
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(){

    private lateinit var channel: MethodChannel
    private val CHANNEL = "alarmChannel"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        )
        if (intent.action == "lock") {
            window.addFlags(
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
                        or WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
                        or WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
                        or WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
            )
            val getId = intent.getIntExtra("id",-1)
            channel.invokeMethod("receiveData",getId)

        }
        channel.setMethodCallHandler { call, result ->
            if (call.method == "alarmQueue") {
                val time = call.argument<Long>("alarmTime")
                val stocks = call.argument<String>("stocks")
                val id = call.argument<Int>("id")
                val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
                val intent = Intent(this, AlarmReceiver::class.java)
                intent.putExtra("id", id)
                val pendingIntent = PendingIntent.getBroadcast(
                    this,
                    id!!,
                    intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    alarmManager.setExactAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        time!!,
                        pendingIntent
                    )
                }
                result.success("alarm queue success")

            } else if (call.method == "setAlarm") {
                val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
                val intent = Intent(this, AlarmReceiver::class.java)
                val alarmIntent =
                    PendingIntent.getBroadcast(this, 3, intent, PendingIntent.FLAG_IMMUTABLE)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    alarmManager.setExactAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        System.currentTimeMillis() + 1000,
                        alarmIntent
                    )
                }

                result.success("a");
            }
        }

    }

}
