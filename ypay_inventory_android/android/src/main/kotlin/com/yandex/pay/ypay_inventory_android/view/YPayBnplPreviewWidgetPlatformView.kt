package com.yandex.pay.ypay_inventory_android.view

import android.content.Context
import android.widget.LinearLayout
import com.yandex.pay.widgets.badge.api.view.YPayBadgeView
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec
import java.math.BigDecimal
import java.util.EnumSet
import android.view.View
import com.yandex.pay.widgets.info.api.view.YPayBnplPreviewWidgetView
import com.yandex.pay.widgets.info.api.model.render.WidgetType
import android.graphics.Color
import com.yandex.pay.widgets.info.api.model.render.bnplpreview.WidgetHeader
import com.yandex.pay.widgets.info.api.model.render.bnplpreview.WidgetSize
import com.yandex.pay.widgets.info.api.model.render.bnplpreview.WidgetBackground
import com.yandex.pay.widgets.info.api.model.render.WidgetTheme
import com.yandex.pay.widgets.info.api.model.render.WidgetStyle
import android.view.ViewTreeObserver
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.FlutterException
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.util.TypedValue
import android.widget.FrameLayout
import android.view.View.MeasureSpec

class YPayBnplPreviewWidgetPlatformView(
    private val context: Context,
    private val id: Int,
    creationParams: Map<String?, Any?>?,
    private val messenger: BinaryMessenger
) : PlatformView,
    MethodChannel.MethodCallHandler {

    private val bnplPreviewWidget = YPayBnplPreviewWidgetView(context).apply {
    }

    private val controllerChannel =
        MethodChannel(
            messenger,
            "com.yandex.pay.flutter_channel/ypay-bnpl-preview-widget-view_" + id
        )


    init {
        controllerChannel.setMethodCallHandler(this)
        applyViewOptions(creationParams!!)
        // Устанавливаем слушатель кнопки «Оформить»
        bnplPreviewWidget.setCheckoutButtonClickListener { selectedPlan: Int ->
            // Используем MethodChannel для связи с Flutter
            controllerChannel.invokeMethod(
                "onCheckoutButtonClick",
                mapOf(
                    "selectedPlan" to selectedPlan,
                )
            )
        }


        bnplPreviewWidget.viewTreeObserver.addOnGlobalLayoutListener {
            if (bnplPreviewWidget.visibility != View.VISIBLE) {
                controllerChannel
                    .invokeMethod(
                        "onSizeChanged", mapOf(
                            "id" to id,
                            "viewType" to "ypay-bnpl-preview-widget-view",
                            "width" to 0.0,
                            "height" to 0.0
                        )
                    )

            } else {
                val width = bnplPreviewWidget.measuredWidth
                bnplPreviewWidget.measure(
                    MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY),
                    MeasureSpec.makeMeasureSpec(0, MeasureSpec.UNSPECIFIED)
                )
                val height = bnplPreviewWidget.measuredHeight
                val heightDp = pxToDp(context, height)
                // Отправляем размеры в Flutter
                controllerChannel
                    .invokeMethod(
                        "onSizeChanged", mapOf(
                            "id" to id,
                            "viewType" to "ypay-bnpl-preview-widget-view",
                            "height" to heightDp
                        )
                    )
            }
        }

    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "updateViewOptions" -> {
                updateViewOptions(call)
                result.success(null)
            }

            "waitForInit" -> {
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    fun updateViewOptions(call: MethodCall) {
        applyViewOptions(call.arguments as Map<String?, Any?>)
    }

    private fun applyViewOptions(params: Map<String?, Any?>) {

        if (params["theme"] != null) {
            bnplPreviewWidget.setTheme(
                WidgetTheme.valueOf((params!!["theme"] as? String)?.uppercase() ?: "SYSTEM")
            )
        }

        if (params["header"] != null) {
            bnplPreviewWidget.setHeader(
                WidgetHeader.valueOf((params!!["header"] as? String)?.uppercase() ?: "STANDARD")
            )
        }
        if (params["background"] != null) {
            val background =
                WidgetBackground.valueOf(
                    (params!!["background"] as? String)?.uppercase() ?: "STANDARD"
                )
            bnplPreviewWidget.setBackground(background)
        }

        if (params!!["backgroundColor"] != null) {
            val colorString = params!!["backgroundColor"] as? String
            if (colorString != null) {
                val backgroundColor = Color.parseColor("#$colorString")
                bnplPreviewWidget.setBackgroundColor(backgroundColor)
            }

        }

        if (params["hasOutline"] != null) {
            bnplPreviewWidget.setHasOutline((params!!["hasOutline"] as? Boolean) ?: true)
        }
        if (params["radius"] != null) {
            val radiusDp = (params!!["radius"] as? Double)?.toFloat() ?: 0f
            val radiusPx = dpToPx(context, radiusDp)
            bnplPreviewWidget.setRadius(radiusPx)
        }
        if (params["hasPadding"] != null) {
            bnplPreviewWidget.setHasPadding((params!!["hasPadding"] as? Boolean) ?: true)
        }
        if (params["size"] != null) {


            bnplPreviewWidget.setSize(
                WidgetSize.valueOf(
                    (params!!["size"] as? String)?.uppercase() ?: "MEDIUM"
                )
            )
        }
        if (params["hasCheckoutButton"] != null) {
            bnplPreviewWidget.setHasCheckoutButton(
                (params!!["hasCheckoutButton"] as? Boolean) ?: true
            )
        }


        if (params["withHeaderClickListener"] != null) {
            if ((params!!["withHeaderClickListener"] as? Boolean) ?: false) {
                // Устанавливаем слушатель клика по шапке
                bnplPreviewWidget.setHeaderClickListener {
                    // Используем MethodChannel для связи с Flutter
                    controllerChannel.invokeMethod(
                        "onHeaderClick", null
                    )
                }
            } else {
                bnplPreviewWidget.setHeaderClickListener(null)
            }
        }

        if (params["sum"] != null) {
            bnplPreviewWidget.setSum(BigDecimal((params!!["sum"] as? Double) ?: 0.0))
        }

    }


    override fun  dispose() {
        controllerChannel.setMethodCallHandler(null);
    }
    override fun getView(): View {
        return bnplPreviewWidget
    }

    fun dpToPx(context: Context, dp: Float): Float {
        return dp * context.resources.displayMetrics.density
    }

    private fun pxToDp(context: Context, px: Int): Float {
        val density = context.resources.displayMetrics.density
        return px / density
    }
}
