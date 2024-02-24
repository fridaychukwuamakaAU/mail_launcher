package com.kodal.mail_launcher

import android.app.Activity
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
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "mail_launcher")
        channel.setMethodCallHandler(this)
    }

  private fun launch(@NonNull email: Map<String, String>) {
    Intent(Intent.ACTION_SENDTO).apply {
        data = Uri.parse("mailto:")
        putExtra(Intent.EXTRA_EMAIL, arrayOf(email.get("to")))
        putExtra(Intent.EXTRA_SUBJECT, email.get("subject"))
        putExtra(Intent.EXTRA_TEXT, email.get("body"))
        activity?.startActivity(Intent.createChooser(this, email.get("dialogTitle")))
    }
}


   override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
        "launch" -> {
            val arguments = call.arguments<Map<String, String>>()
            if (arguments != null) {
                launch(arguments)
            } else {
                result.error("ARGUMENTS_NULL", "The arguments for 'launch' cannot be null", null)
            }
        }
        else -> result.notImplemented()
    }
}

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    }

   override fun onAttachedToActivity(activityPluginBinding: ActivityPluginBinding) {
        activity = activityPluginBinding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

      override fun onReattachedToActivityForConfigChanges(activityPluginBinding: ActivityPluginBinding) {
        activity = activityPluginBinding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}