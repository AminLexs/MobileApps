package aminlexscorp.cpu_catalog2

//import android.R
import aminlexscorp.cpu_catalog2.beans.CPU
import aminlexscorp.cpu_catalog2.beans.CPUList
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.widget.*
import androidx.appcompat.app.AppCompatActivity
import com.bumptech.glide.Glide
import com.google.android.material.bottomnavigation.BottomNavigationView
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.QueryDocumentSnapshot
import androidx.navigation.findNavController
import androidx.navigation.ui.AppBarConfiguration
import androidx.navigation.ui.setupActionBarWithNavController
import androidx.navigation.ui.setupWithNavController
import com.google.firebase.firestore.QuerySnapshot
import com.google.firebase.storage.StorageReference



class TableActivity : AppCompatActivity() {
    lateinit var cpuList: QuerySnapshot
    var currDocument:QueryDocumentSnapshot? = null
    private lateinit var bottomNav: BottomNavigationView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_table)

        bottomNav=findViewById(R.id.bottom_navigation)
        bottomNav.setOnNavigationItemSelectedListener(mOnNavigationItemSelectedListener)

        val db: FirebaseFirestore = FirebaseFirestore.getInstance()
        db.collection("users").get().addOnCompleteListener(){
                task ->
            if (task.isSuccessful){
                cpuList = task.result!!
                var i = 0
                for (document in task.result!!) {
                    addRow(document, i)
                    i++
                }
            }
        }
    }

    fun addRow(document: QueryDocumentSnapshot, position: Int) {

        val c0 =  document.getData()["manufacturer"].toString()
        val c1 =  document.getData()["model"].toString()
        val c2 = document.getData()["frequency"].toString()
        val c3 = document.getData()["numcores"].toString()
        val c4 = document.getData()["avatar"].toString()

        val tableLayout = findViewById<View>(R.id.TableActivityTableLayout) as TableLayout
        val inflater = LayoutInflater.from(this)
        val tr = inflater.inflate(R.layout.table_row, null) as TableRow
        //Находим ячейку для номера дня по идентификатору
        tr.setOnClickListener {
            var cpu=RepackCPUData(position)
            var intent= Intent(this, DetailedActivity::class.java)
            intent.putExtra("detailed_data", cpu)
            intent.putExtra("document_id", cpuList.documents[position].id)
            startActivity(intent)
           // currDocument = document
            //Toast.makeText( baseContext,getResources().getString(R.string.home_selected)+ " " + c1, Toast.LENGTH_SHORT).show()
        }

        var tv = tr.findViewById(R.id.col2) as TextView
        tv.text = c0
        tv = tr.findViewById<View>(R.id.col3) as TextView
        tv.text = c1
        tv = tr.findViewById(R.id.col4) as TextView
        tv.text = c2
        tv = tr.findViewById<View>(R.id.col5) as TextView
        tv.text = c3
        var tvIV = tr.findViewById(R.id.col1) as ImageView
            Glide.with(getApplicationContext())
            .load(c4).placeholder(R.drawable.ic_user)
            .into(tvIV)
        tableLayout.addView(tr) //добавляем созданную строку в таблицу
    }



    private val mOnNavigationItemSelectedListener = BottomNavigationView.OnNavigationItemSelectedListener { item ->
        when (item.itemId) {
            R.id.home_button -> {
               // finish()
                var intent= Intent(this, TableActivity::class.java)
                startActivity(intent)
                return@OnNavigationItemSelectedListener true
            }
            R.id.map_button-> {

                var data=arrayListOf<CPU>()
                var documents=arrayListOf<String>()
                for(i in 0..cpuList.count()-1){
                    data.add(RepackCPUData(i))
                    documents.add(cpuList.documents[i].id)
                }

                var characters=CPUList(data)

                var intent= Intent(this, MapActivity::class.java)
                intent.putExtra("cpu_data", characters)
                intent.putExtra("documents", documents)
                startActivity(intent)

                return@OnNavigationItemSelectedListener true
            }
            R.id.settings_button-> {
                var intent= Intent(this, SettingsActivity::class.java)
                startActivity(intent)
                return@OnNavigationItemSelectedListener true
            }
        }
        false
    }


    private fun RepackCPUData(position: Int): CPU{
        var cpu=CPU(
            cpuList.documents[position].data?.get("model") as String?,
            cpuList.documents[position].data?.get("manufacturer") as String?,
            cpuList.documents[position].data?.get("bitsdepth") as String?,
            cpuList.documents[position].data?.get("frequency") as String?,
            cpuList.documents[position].data?.get("numcores") as String?,
            cpuList.documents[position].data?.get("avatar") as String?,
            cpuList.documents[position].data?.get("description") as String?,
            cpuList.documents[position].data?.get("images") as ArrayList<String>?,
            cpuList.documents[position].data?.get("video") as String?,
            cpuList.documents[position].data?.get("latitude") as String?,
            cpuList.documents[position].data?.get("longitude") as String?
        )
        return cpu;
    }

}



