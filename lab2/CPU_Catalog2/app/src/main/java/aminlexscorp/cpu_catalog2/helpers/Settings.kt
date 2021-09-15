package aminlexscorp.cpu_catalog2.helpers

import android.app.Activity
import android.content.Context
import android.graphics.Typeface
import android.preference.PreferenceManager
import android.util.Log
import android.widget.Spinner
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.app.AppCompatDelegate
import java.lang.reflect.Field
import java.util.*


@Suppress("DEPRECATION")
class Settings: AppCompatActivity()  {

     fun setTextViewSettings(text: TextView, activity: Activity){
        var settings= activity.getSharedPreferences("UserInfo",Context.MODE_PRIVATE)
        text.setTextSize(settings.getFloat("FontSize", 15.0F))
        Log.d("TAG", settings.getFloat("FontSize", 15.0F).toString())

    }
    /*val face = Typeface.createFromAsset(assets,
            "fonts/epimodem.ttf")
    text.setTypeface(face)*/

    fun setLocale(localeName: String, activity: Activity) {
       var settings= PreferenceManager.getDefaultSharedPreferences(activity)//activity.getPreferences(Context.MODE_PRIVATE)
       var editor = settings.edit()
       val currentLanguage=settings.getString("Language","en")
        if (localeName != currentLanguage) {
            val locale = Locale(localeName)
            val res = activity.resources //getResources()
            val dm = res.displayMetrics
            val conf = res.configuration
            conf.locale = locale
            editor.putString("Language", localeName)
            editor.commit()
            res.updateConfiguration(conf, dm)
        }
    }



     fun setMode(mode: String,activity: Activity){

        var settings= PreferenceManager.getDefaultSharedPreferences(activity);//activity.getPreferences(Context.MODE_PRIVATE)
        var editor = settings.edit()
        if (mode=="MODE_NIGHT_YES"){
            AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES)
            editor.putString("Mode", "MODE_NIGHT_YES")
            editor.commit()
        }
        else{
            AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO)
            editor.putString("Mode", "MODE_NIGHT_NO")
            editor.commit()
        }

    }


    fun overrideFont(
            context: Context,
            defaultFontNameToOverride: String?,
            customFontFileNameInAssets: String?
    ) {
        try {
            val customFontTypeface =
                    Typeface.createFromAsset(context.assets, customFontFileNameInAssets)
            val defaultFontTypefaceField: Field =
                    Typeface::class.java.getDeclaredField(defaultFontNameToOverride)
            defaultFontTypefaceField.setAccessible(true)
            defaultFontTypefaceField.set(null, customFontTypeface)
        } catch (e: Exception) {
        }

    }

}
