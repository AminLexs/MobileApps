package aminlexscorp.cpu_catalog2

//import android.R
import aminlexscorp.cpu_catalog2.helpers.Settings
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.res.Configuration
import android.content.res.Resources
import android.os.Bundle
import android.preference.PreferenceManager
import android.util.Patterns
import android.view.View
import android.widget.EditText
import android.widget.Switch
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.google.firebase.auth.FirebaseAuth
import java.util.*

@Suppress("DEPRECATION")
class MainActivity : AppCompatActivity() {
    lateinit var editEmail: EditText
    lateinit var editPassword: EditText
    private var locale: Locale? = null
    private var lang: String? = null
    private var settings: Settings = Settings()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        editEmail = findViewById(R.id.AuthEditTextEmail) as EditText
        editPassword = findViewById(R.id.AuthEditTextPassword) as EditText

        val sharedPreferences = PreferenceManager.getDefaultSharedPreferences(this)//getPreferences(Context.MODE_PRIVATE)
        lang = sharedPreferences?.getString("Language", "default")
        if (lang.equals("default")) {
            lang = resources.configuration.locale.country
        }
        locale = Locale(lang)
        Locale.setDefault(locale)
        val config = Configuration()
        config.locale = locale
        baseContext.resources.updateConfiguration(config, null)

        var mode = sharedPreferences.getString("Mode","");

        if (mode == "MODE_NIGHT_YES") {
            settings.setMode("MODE_NIGHT_YES",this)
        }else {settings.setMode("MODE_NIGHT_NO", this)}



        val start_value:Float= 0.7F
        val step:Float=0.15F
        val res: Resources = resources
        val settings = getSharedPreferences("UserInfo", Context.MODE_PRIVATE)
        var size_coef:Int= settings.getInt("size_coef", 2)
        val new_value = start_value + size_coef * step
        val configuration = Configuration(res.configuration)
        configuration.fontScale = new_value
        res.updateConfiguration(configuration, res.displayMetrics)
    }
    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig!!)
        locale = Locale(lang)
        Locale.setDefault(locale)
        val config = Configuration()
        config.locale = locale
        baseContext.resources.updateConfiguration(config, null)
    }


    fun regClick(view: View) {
        val intent = Intent(this, Register::class.java)
        startActivity(intent)
    }

    fun logInClick(view: View) {
        //val intent = Intent(this, TableActivity::class.java)
        //startActivity(intent)
        val fAuth: FirebaseAuth =  FirebaseAuth.getInstance();
        if(!Patterns.EMAIL_ADDRESS.matcher(editEmail.text.toString()).matches()){
            Toast.makeText( baseContext,"Wrong email.", Toast.LENGTH_SHORT).show()
            return
        }
        if(editPassword.text.toString().isEmpty()){
            Toast.makeText( baseContext,"Empty password.", Toast.LENGTH_SHORT).show()
            return
        }

        fAuth.signInWithEmailAndPassword(editEmail.text.toString(),editPassword.text.toString()).addOnCompleteListener(this){
            task ->
            if (task.isSuccessful){
                val intent = Intent(this, TableActivity::class.java)
                startActivity(intent)
            }else{
                Toast.makeText( baseContext,"Authentication failed.", Toast.LENGTH_SHORT).show()
            }
        }

    }

}