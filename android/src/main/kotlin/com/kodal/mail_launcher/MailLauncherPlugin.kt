package com.kodal.mail_launcher

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** MailLauncherPlugin */
class MailLauncherPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    // ... rest of the code remains the same ...

    private fun launch(email: Map<String, String>?) {
        email?.let {
            val to = it["to"]
            val subject = it["subject"]
            val body = it["body"]
            val dialogTitle = it["dialogTitle"]

            val intent = Intent(Intent.ACTION_SENDTO).apply {
                data = Uri.parse("mailto:")
                putExtra(Intent.EXTRA_EMAIL, arrayOf(to))
                putExtra(Intent.EXTRA_SUBJECT, subject)
                putExtra(Intent.EXTRA_TEXT, body)
            }
            activity?.startActivityForResult(Intent.createChooser(intent, dialogTitle), REQUEST_CODE)
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) =
            when (call.method) {
                "launch" -> launch(call.arguments() as? Map<String, String>)
                else -> {
                    result.notImplemented()
                }
            }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
