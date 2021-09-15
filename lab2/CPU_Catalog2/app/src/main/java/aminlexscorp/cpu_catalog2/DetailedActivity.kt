package aminlexscorp.cpu_catalog2

import aminlexscorp.cpu_catalog2.beans.CPU
import aminlexscorp.cpu_catalog2.helpers.Settings
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.text.Editable
import android.widget.ImageView
import android.widget.TextView
import com.bumptech.glide.Glide
import com.google.android.material.bottomnavigation.BottomNavigationView
import com.google.android.material.textfield.TextInputEditText

class DetailedActivity : AppCompatActivity() {

    private lateinit var detailed_data: CPU
    private  var document_id: String?=null
    private var settings: Settings = Settings()

    private lateinit var model: TextView
    private lateinit var manufacturer: TextView
    private lateinit var bitsdepth: TextView
    private lateinit var frequency: TextView
    private lateinit var numcores: TextView
    private lateinit var avatar: ImageView
    private lateinit var desc: TextInputEditText
    private lateinit var bottomNav: BottomNavigationView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_detailed)

        model=findViewById(R.id.detailedModel)
        manufacturer=findViewById(R.id.detailedManufacturer)
        bitsdepth=findViewById(R.id.detailedBitsdepth)
        frequency=findViewById(R.id.detailedFrequency)
        numcores=findViewById(R.id.detailedNumcores)
        avatar=findViewById(R.id.detailedImage)
        desc=findViewById(R.id.detailedDescription)
        bottomNav=findViewById(R.id.bottom_navigation)
        bottomNav.setOnNavigationItemSelectedListener(mOnNavigationItemSelectedListener)
    }

    override fun onStart() {
        super.onStart()
        detailed_data=intent.getSerializableExtra("detailed_data") as CPU
        document_id=intent.getStringExtra("document_id")
        model.text=detailed_data.model
        manufacturer.text=detailed_data.manufacturer
        bitsdepth.text=getString(R.string.detailed_bitsdepth) + " " + detailed_data.bitdepth
        frequency.text=detailed_data.frequency
        numcores.text=detailed_data.numcores +" "+ getString(R.string.detailed_core)
        desc.text=detailed_data.description!!.toEditable()

        Glide.with(getApplicationContext())
            .load(detailed_data.avatar).placeholder(R.drawable.ic_user)
            .into(avatar)

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
            R.id.photo_button -> {
                if (!(detailed_data.images!!.size==0 || detailed_data.images==null)) {
                    var intent = Intent(this, ImageActivity::class.java)
                    intent.putExtra("detailed_data", detailed_data)
                    startActivity(intent)
                }
                return@OnNavigationItemSelectedListener true
            }
            R.id.video_button -> {
                var intent= Intent(this, PlayerActivity::class.java)
                intent.putExtra("video_url", detailed_data.video)
                startActivity(intent)
                return@OnNavigationItemSelectedListener true
            }
            R.id.edit_button-> {
                var intent= Intent(this, EditActivity::class.java)
                intent.putExtra("is_editing", true)
                intent.putExtra("detailed_data", detailed_data)
                intent.putExtra("document_id", document_id)
                startActivity(intent)
                return@OnNavigationItemSelectedListener true
            }

        }
        false
    }
    fun String.toEditable(): Editable =  Editable.Factory.getInstance().newEditable(this)
}