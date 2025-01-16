package com.yandex.pay.ypay_inventory_android

import android.content.Context
import android.content.Intent
import androidx.activity.ComponentActivity
import com.yandex.pay.inventory.api.YPayInventory
import io.flutter.plugin.common.MethodCall
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import android.util.Log
import com.yandex.pay.inventory.api.YPayMerchantId
import com.yandex.pay.inventory.api.YPayNetworkEnvironment
import com.yandex.pay.widgets.badge.api.badges
import com.yandex.pay.widgets.badge.api.model.config.HidingPolicy
import com.yandex.pay.widgets.info.api.widgets

object YPayInventoryPluginDelegate : PluginRegistry.ActivityResultListener {
    private const val CONFIG_PAYMENT_METHOD_NAME = "init"
    private const val CLEAR_WIDGETS_METHOD_NAME = "clearWidgets"
    private const val CLEAR_BADGES_METHOD_NAME = "clearBadges"

    private val channels = ChannelHolder()

    private val methodCallHandler = MethodChannel.MethodCallHandler { call, result ->
        when (call.method) {
            CONFIG_PAYMENT_METHOD_NAME -> configPayment(call, result)
            CLEAR_WIDGETS_METHOD_NAME -> clearWidgets(call, result)
            CLEAR_BADGES_METHOD_NAME -> clearBadges(call, result)
            else -> result.notImplemented()
        }
    }
    private val eventStreamHandler = PendingEventStreamHandler()

    private var activityBinding: ActivityPluginBinding? = null


    fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channels.add(
            MethodChannel(binding.binaryMessenger, YPayInventoryAndroidPlugin.METHOD_CHANNEL_NAME),
            methodCallHandler,
        )
        channels.add(
            EventChannel(binding.binaryMessenger, YPayInventoryAndroidPlugin.EVENT_CHANNEL_NAME),
            eventStreamHandler,
        )
    }

    fun onDetachedFromEngine() {
        eventStreamHandler.clear()
        channels.clear()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        return when (requestCode) {
//            START_PAYMENT_REQUEST_CODE -> {
//                onPaymentResult(resultCode, data)
//                true
//            }

            else -> false
        }
    }

    fun setActivityBinding(binding: ActivityPluginBinding?) {
        activityBinding?.removeActivityResultListener(this)
        activityBinding = binding
        activityBinding?.addActivityResultListener(this)

        val act = activityBinding?.activity as? FlutterFragmentActivity
    }

    private fun clearBadges(call: MethodCall, result: MethodChannel.Result) {
        YPayInventory.clear()
            .badges()
        result.success("clear badges")
    }
    private fun clearWidgets(call: MethodCall, result: MethodChannel.Result) {
        YPayInventory.clear()
            .widgets()
        result.success("clear widgets")
    }


    private fun configPayment(call: MethodCall, result: MethodChannel.Result) {
        val activity = activityBinding?.activity
        if (activity == null) {
            result.error("errorNoActivity", null, null)
            return
        }
        if (call.arguments is HashMap<*, *>) {
            val args = call.arguments as HashMap<*, *>
            val configMerchantId: String = args["merchantId"] as String
            val testMode: Boolean = args["testMode"] as Boolean
            val config = YPayInventory.init {
                // контекст вашего приложения:
                appContext = activity.applicationContext
                // ваш Merchant ID :
                merchantId = YPayMerchantId(configMerchantId)
                // вариант сетевого окружения PROD / SANDBOX:
                environment =
                    if (testMode) YPayNetworkEnvironment.SANDBOX else YPayNetworkEnvironment.PROD
            };
            config.badges {
                // режим скрытия бейджей в случае отсутствия данных
                hidingPolicy = HidingPolicy.valueOf(
                    (args["badgeHidingPolicy"] as? String)?.uppercase() ?: "GONE"
                )
            }
            config.widgets { }
            result.success("initialized")
        } else {
            result.error("-1", "Initialization error", "Wrong argument type")
        }
    }
}