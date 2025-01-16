package com.yandex.pay.ypay_inventory_android.view

import android.content.Context
import android.widget.LinearLayout
import com.yandex.pay.widgets.badge.api.view.YPayBadgeView
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec
import java.math.BigDecimal
import android.view.View
import android.view.ViewGroup
import  com.yandex.pay.widgets.badge.api.model.renderdata.BadgeRenderData
import  com.yandex.pay.widgets.badge.api.model.renderdata.BadgeTheme
import  com.yandex.pay.widgets.badge.api.model.renderdata.SplitBadgeColor
import  com.yandex.pay.widgets.badge.api.model.renderdata.BadgeAlign
import  com.yandex.pay.widgets.badge.api.model.renderdata.SplitBadgeVariant
import  com.yandex.pay.widgets.badge.api.model.renderdata.CashbackBadgeColor
import  com.yandex.pay.widgets.badge.api.model.renderdata.CashbackBadgeVariant
import android.view.ViewTreeObserver
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.FlutterException
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.util.TypedValue
import android.widget.FrameLayout
import android.view.View.MeasureSpec

class YPayBadgePlatformView(
    private val context: Context,
    private val id: Int,
    creationParams: Map<String?, Any?>?,
    private val messenger: BinaryMessenger
) : PlatformView,
    MethodChannel.MethodCallHandler {

    private val yPayBadgeView = YPayBadgeView(context).apply {
    }

    private val controllerChannel =
        MethodChannel(
            messenger,
            "com.yandex.pay.flutter_channel/ypay-badge-view_" + id
        )

    var width: Int = 0
    var height: Int = 0

    init {
        controllerChannel.setMethodCallHandler(this)
        applyViewOptions(creationParams!!)
        yPayBadgeView.viewTreeObserver.addOnGlobalLayoutListener {
            if (yPayBadgeView.visibility != View.VISIBLE) {
                controllerChannel
                    .invokeMethod(
                        "onSizeChanged", mapOf(
                            "width" to 0.0,
                            "height" to 0.0
                        )
                    )

            } else {
                val viewWidth = yPayBadgeView.measuredWidth
                val viewHeight = yPayBadgeView.measuredHeight

                val heightDp = pxToDp(context, viewHeight)
                // Отправляем размеры в Flutter
                controllerChannel
                    .invokeMethod(
                        "onSizeChanged", mapOf(
                            "id" to id,
                            "viewType" to "ypay-badge-view",
                            "width" to pxToDp(context, viewWidth.toInt()),
                            "height" to heightDp
                        )
                    )
            }
        }
    }

    fun dpToPx(context: Context, dp: Float): Float {
        return dp * context.resources.displayMetrics.density
    }

    override fun  dispose() {
        controllerChannel.setMethodCallHandler(null);
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

//
        if (params["style"] != null) {
            yPayBadgeView.setRenderData(
                if (params["style"] == "split") BadgeRenderData.SplitBadgeRenderData(
                    theme = BadgeTheme.valueOf(
                        (params["theme"] as? String)?.uppercase() ?: "SYSTEM"
                    ),
                    align = BadgeAlign.valueOf(
                        (params["align"] as? String)?.uppercase() ?: "LEFT"
                    ),
                    color = SplitBadgeColor.valueOf(
                        (params["color"] as? String)?.uppercase() ?: "PRIMARY"
                    ),
                    variant = SplitBadgeVariant.valueOf(
                        (params["variant"] as? String)?.uppercase() ?: "SIMPLE"
                    )
                ) else BadgeRenderData.CashbackBadgeRenderData(
                    theme = BadgeTheme.valueOf(
                        (params["theme"] as? String)?.uppercase() ?: "SYSTEM"
                    ),
                    align = BadgeAlign.valueOf(
                        (params["align"] as? String)?.uppercase() ?: "LEFT"
                    ),
                    color = CashbackBadgeColor.valueOf(
                        (params["color"] as? String)?.uppercase() ?: "PRIMARY"
                    ),
                    variant = CashbackBadgeVariant.valueOf(
                        (params["variant"] as? String)?.uppercase() ?: "DETAILED"
                    )
                )
            )
        }

        if (params["width"] != null) {
            width = ((params["width"] as? Double) ?: 0.0).toInt()
        }
        if (params["height"] != null) {
            height = ((params["height"] as? Double) ?: 0.0).toInt()
        }
        setSize(dpToPx(context, width.toFloat()).toInt(), dpToPx(context, height.toFloat()).toInt())

        if ((params["sum"] as? Double) != null) {
            yPayBadgeView.visibility = View.VISIBLE
            yPayBadgeView.setSum(BigDecimal((params["sum"] as? Double) ?: 0.0))
        }

    }

    fun setSize(view_width: Int, view_height: Int) {
        // Получаем layoutParams для targetView
        val params = yPayBadgeView.layoutParams ?: ViewGroup.LayoutParams(
            ViewGroup.LayoutParams.WRAP_CONTENT,
            ViewGroup.LayoutParams.WRAP_CONTENT
        )

        // Логика для установки ширины
        params.width = when {
            view_width > 0 -> view_width // Если ширина задана, устанавливаем фиксированное значение
            else -> ViewGroup.LayoutParams.WRAP_CONTENT // Иначе WRAP_CONTENT
        }

        // Логика для установки высоты
        params.height = when {
            view_height > 0 -> view_height // Если высота задана, устанавливаем фиксированное значение
            view_width > 0 -> ViewGroup.LayoutParams.WRAP_CONTENT // Если ширина задана, а высота нет
            else -> ViewGroup.LayoutParams.MATCH_PARENT // Если ничего не задано, высота MATCH_PARENT
        }

        // Применяем обновленные параметры
        yPayBadgeView.layoutParams = params
    }

    override fun getView(): View {
        return yPayBadgeView
    }


    private fun pxToDp(context: Context, px: Int): Float {
        val density = context.resources.displayMetrics.density
        return px / density
    }
}
