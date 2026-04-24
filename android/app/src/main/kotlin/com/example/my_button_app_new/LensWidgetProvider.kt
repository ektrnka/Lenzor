package com.example.my_button_app_new

import android.appwidget.AppWidgetManager
import android.graphics.Color
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import java.util.Calendar
import java.util.concurrent.TimeUnit

class LensWidgetProvider : HomeWidgetProvider() {

    private val colorNormal = Color.parseColor("#1E3A5C")
    private val colorOverdue = Color.parseColor("#FF5252")

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: android.content.SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val languageCode = (widgetData.getString("lens_language_code", "en") ?: "en").lowercase()
            val (value, isOverdue) = computeRemainingTextAndOverdue(widgetData, languageCode)
            val views = RemoteViews(context.packageName, R.layout.lens_widget).apply {
                val startMillis = (widgetData.getString("lens_start_date_millis", "0") ?: "0")
                    .toLongOrNull() ?: 0L
                val hasActiveCycle = startMillis > 0L
                val label = if (hasActiveCycle) {
                    if (isOverdue) labelOverdueBy(languageCode) else labelUntilReplacement(languageCode)
                } else {
                    labelUntilReplacement(languageCode)
                }

                setTextViewText(R.id.text_lens_label, label)
                setTextViewText(R.id.text_lens_value, value)
                setInt(R.id.text_lens_value, "setTextColor", if (isOverdue) colorOverdue else colorNormal)

                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                )
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    /**
     * Вычисляет актуальный текст «До замены» и флаг просрочки из сырых данных.
     * Вызывается при каждом onUpdate (в т.ч. когда приложение закрыто).
     */
    private fun computeRemainingTextAndOverdue(
        prefs: android.content.SharedPreferences,
        languageCode: String,
    ): Pair<String, Boolean> {
        val startMillisStr = prefs.getString("lens_start_date_millis", "0") ?: "0"
        val startMillis = startMillisStr.toLongOrNull() ?: 0L
        if (startMillis <= 0) {
            return (prefs.getString("lens_remaining_text", "—") ?: "—") to false
        }

        val totalDays = prefs.getInt("lens_total_days", 30)
        val startCal = Calendar.getInstance().apply { timeInMillis = startMillis }
        val nowCal = Calendar.getInstance()

        return if (totalDays == 1) {
            val diffMs = nowCal.timeInMillis - startCal.timeInMillis
            val hoursPassed = TimeUnit.MILLISECONDS.toHours(diffMs).toInt()
            val maxHours = 14
            if (hoursPassed >= maxHours) {
                val overdue = hoursPassed - maxHours
                "$overdue ${getHoursLabel(overdue, languageCode)}" to true
            } else {
                val remaining = maxHours - hoursPassed
                "$remaining ${getHoursLabel(remaining, languageCode)}" to false
            }
        } else {
            var daysWorn = calculateInclusiveCalendarDays(startCal, nowCal)
            if (daysWorn < 1) daysWorn = 1
            if (daysWorn > totalDays) {
                val overdue = daysWorn - totalDays
                "$overdue ${getDaysLabel(overdue, languageCode)}" to true
            } else {
                val remaining = totalDays - daysWorn
                "$remaining ${getDaysLabel(remaining, languageCode)}" to false
            }
        }
    }

    /**
     * Инклюзивный расчёт дней по календарным датам (как на главном экране Flutter):
     * startDate=today -> 1 день.
     */
    private fun calculateInclusiveCalendarDays(start: Calendar, end: Calendar): Int {
        val startOnly = (start.clone() as Calendar).apply {
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }
        val endOnly = (end.clone() as Calendar).apply {
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }
        val diffMs = endOnly.timeInMillis - startOnly.timeInMillis
        val diffDays = TimeUnit.MILLISECONDS.toDays(diffMs).toInt()
        return if (diffDays >= 0) diffDays + 1 else 0
    }

    private fun getHoursLabel(hours: Int, languageCode: String): String {
        if (!languageCode.startsWith("ru")) {
            return if (hours == 1) "hour" else "hours"
        }
        val mod10 = hours % 10
        val mod100 = hours % 100
        return when {
            mod10 == 1 && mod100 != 11 -> "час"
            mod10 in 2..4 && mod100 !in 12..14 -> "часа"
            else -> "часов"
        }
    }

    private fun getDaysLabel(days: Int, languageCode: String): String {
        if (!languageCode.startsWith("ru")) {
            return if (days == 1) "day" else "days"
        }
        val mod10 = days % 10
        val mod100 = days % 100
        return when {
            mod10 == 1 && mod100 != 11 -> "день"
            mod10 in 2..4 && mod100 !in 12..14 -> "дня"
            else -> "дней"
        }
    }

    private fun labelUntilReplacement(languageCode: String): String {
        return if (languageCode.startsWith("ru")) "До замены линз" else "Until replacement"
    }

    private fun labelOverdueBy(languageCode: String): String {
        return if (languageCode.startsWith("ru")) "Линзы просрочены на" else "Overdue by"
    }
}
