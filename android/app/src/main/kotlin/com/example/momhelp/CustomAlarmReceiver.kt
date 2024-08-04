package com.example.momhelp

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.Toast

class CustomAlarmReceiver :BroadcastReceiver(){
    override fun onReceive(context: Context?, intent: Intent?) {
        if (context != null && intent!=null) {
            val id = intent.getIntExtra("id",-1)
            val serviceIntent = Intent(context, CustomAlarmService::class.java)
            serviceIntent.putExtra("id",id)
            Toast.makeText(context, "알림 울림", Toast.LENGTH_SHORT).show()
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(serviceIntent)
            }else{
                context.startService(serviceIntent);
            }
        }
    }
}