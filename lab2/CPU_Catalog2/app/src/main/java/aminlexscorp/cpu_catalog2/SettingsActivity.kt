    package aminlexscorp.cpu_catalog2

    import aminlexscorp.cpu_catalog2.helpers.Settings
    import android.content.Context
    import android.content.Intent
    import android.content.res.Configuration
    import android.content.res.Resources
    import android.graphics.Typeface
    import android.os.Bundle
    import android.preference.PreferenceManager
    import android.view.View
    import android.widget.*
    import androidx.appcompat.app.AppCompatActivity
    import com.google.android.material.bottomnavigation.BottomNavigationView
    import java.util.*

    @Suppress("DEPRECATION")
    class SettingsActivity : AppCompatActivity() {
        lateinit var language_spinner: Spinner
        lateinit var fonttype_spinner: Spinner
        lateinit var seekBar :SeekBar
        lateinit var titleSetting : TextView
        private lateinit var bottomNav: BottomNavigationView
        private var currentLanguage = "en"
        private var currentLang: String? = null
        private var settings: Settings =Settings()
        var size_coef:Int=2
        val start_value:Float= 0.7F
        val step:Float=0.15F

        override fun onStart() {
            super.onStart()
            settings.setTextViewSettings(findViewById<TextView>(R.id.SettingsTitle),this)
        }
        override fun onCreate(savedInstanceState: Bundle?) {
            super.onCreate(savedInstanceState)
            setContentView(R.layout.activity_settings)
           val sharedPreferences = PreferenceManager.getDefaultSharedPreferences(this)//getPreferences(Context.MODE_PRIVATE)
           var mode = sharedPreferences.getString("Mode","");
            val btn = findViewById<Switch>(R.id.switch1)
            if (mode == "MODE_NIGHT_YES") {
                btn.text = getString(R.string.settings_dis_dm)
                btn.setChecked(true);
            }else { btn.text = getString(R.string.settings_enable_dm)
                btn.setChecked(false);}
            bottomNav=findViewById(R.id.bottom_navigation)
            bottomNav.setOnNavigationItemSelectedListener(mOnNavigationItemSelectedListener)

            btn.setOnCheckedChangeListener { _, isChecked ->
                if (btn.isChecked) {
                    btn.text = getString(R.string.settings_dis_dm)
                    settings.setMode("MODE_NIGHT_YES",this)

                } else {
                    btn.text = getString(R.string.settings_enable_dm)
                    settings.setMode("MODE_NIGHT_NO", this)
                }
            }

            currentLanguage = intent.getStringExtra(currentLang).toString()
            language_spinner = findViewById(R.id.language_spinner)
            val language_list = ArrayList<String>()
            language_list.add(getString(R.string.settings_selectlang))
            language_list.add(getString(R.string.settings_english))
            language_list.add(getString(R.string.settings_russian))
            val language_adapter = ArrayAdapter(this, R.layout.support_simple_spinner_dropdown_item, language_list)
            language_adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
            language_spinner.adapter = language_adapter
            language_spinner.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
                override fun onItemSelected(parent: AdapterView<*>, view: View?, position: Int, id: Long) {
                    when (position) {
                        0 -> {
                        }
                        1-> selectLocale("en")
                        2-> selectLocale("ru")
                    }
                }
                override fun onNothingSelected(parent: AdapterView<*>) {}
            }

            seekBar = findViewById<View>(R.id.seekBar) as SeekBar
            if (seekBar != null) {
                val settings = getSharedPreferences("UserInfo", MODE_PRIVATE);
                    size_coef = settings.getInt("size_coef", 2)
                    seekBar.setProgress(size_coef);

                seekBar.setOnSeekBarChangeListener(object : SeekBar.OnSeekBarChangeListener{
                    override fun onProgressChanged(seekBar: SeekBar?, progress: Int, fromUser: Boolean) {
                        size_coef = progress
                    }
                    override fun onStartTrackingTouch(seekBar: SeekBar?) {    }
                    override fun onStopTrackingTouch(seekBar: SeekBar?) {

                        val settings = getSharedPreferences("UserInfo", Context.MODE_PRIVATE)
                        val value_add = settings.edit()
                        value_add.putInt("size_coef", size_coef)
                        value_add.apply()

                        val res: Resources = resources
                        val сoef = start_value + size_coef * step //новый коэффициент увеличения шрифта

                        val configuration = Configuration(res.getConfiguration())
                        configuration.fontScale = сoef
                        res.updateConfiguration(configuration, res.getDisplayMetrics())
                    }
                })
            }

            fonttype_spinner = findViewById(R.id.fonttype_spinner)
            val fonttype_list = ArrayList<String>()
            fonttype_list.add(getString(R.string.settings_selectfont))
            fonttype_list.add("Roboto Regular")
            fonttype_list.add("Slimamif Medium")
            fonttype_list.add("Raleway")


            val fonttype_adapter = ArrayAdapter(this, R.layout.support_simple_spinner_dropdown_item, fonttype_list)
            fonttype_adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
            fonttype_spinner.adapter = fonttype_adapter
            fonttype_spinner.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
                override fun onItemSelected(parent: AdapterView<*>, view: View?, position: Int, id: Long) {
                    when (position) {
                        0 -> {
                        }
                        1-> settings.overrideFont(baseContext,"SANS_SERIF","font/robotoregular.ttf")
                        2-> settings.overrideFont(baseContext,"SANS_SERIF","font/slimamifmedium.ttf")
                        3-> settings.overrideFont(baseContext,"SANS_SERIF","font/raleway.ttf")
                    }

                }
                override fun onNothingSelected(parent: AdapterView<*>) {}
            }
        }


        private fun selectLocale(localeName: String) {
            settings.setLocale(localeName, this)
            val refresh = Intent(
                this,
                SettingsActivity::class.java
            )
            refresh.putExtra(currentLang, localeName)
            startActivity(refresh)
        }


        private val mOnNavigationItemSelectedListener = BottomNavigationView.OnNavigationItemSelectedListener { item ->
            when (item.itemId) {
                R.id.back -> {
                    val refresh = Intent(
                        this,
                        TableActivity::class.java
                    )
                    startActivity(refresh)
                    return@OnNavigationItemSelectedListener true
                }
            }
            false
        }
    }