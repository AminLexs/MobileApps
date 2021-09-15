package aminlexscorp.cpu_catalog2

import aminlexscorp.cpu_catalog2.beans.CPU
import aminlexscorp.cpu_catalog2.dao.storage
import aminlexscorp.cpu_catalog2.dao.storePicture
import aminlexscorp.cpu_catalog2.helpers.Settings
import android.app.Activity
import android.content.Intent
import android.net.Uri
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.provider.MediaStore
import android.text.Editable
import android.util.Log
import android.widget.Button
import android.widget.EditText
import android.widget.ImageView
import android.widget.Toast
import com.bumptech.glide.Glide
import com.google.android.material.bottomnavigation.BottomNavigationView
import com.google.android.material.textfield.TextInputEditText
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import com.google.firebase.storage.StorageReference
import java.io.IOException
import java.util.*

class EditActivity : AppCompatActivity() {

    private lateinit var detailed_data: CPU
    private  var document_id: String?=null
    private var isEditing: Boolean=true

    private val pickImage = 100

    private lateinit var avatarImage: ImageView
    private lateinit var modelTextEdit: EditText
    private lateinit var manufacturerEditText: EditText
    private lateinit var frequencyTextEdit: EditText
    private lateinit var bitsdepthEditText: EditText
    private lateinit var numcoresEditText: EditText
    private lateinit var latitudeEditText: EditText
    private lateinit var longitudeEditText: EditText
    private lateinit var descEditText:  EditText
    private lateinit var bottomNav: BottomNavigationView
    internal var storageReference: StorageReference?=null
    private var filePath:Uri? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_edit)
        storageReference = storage!!.reference

        modelTextEdit=findViewById(R.id.editModel)
        manufacturerEditText=findViewById(R.id.editManufacturer)
        frequencyTextEdit=findViewById(R.id.editFrequency)
        bitsdepthEditText=findViewById(R.id.editBitsdepth)
        numcoresEditText=findViewById(R.id.editNumcores)
        avatarImage=findViewById(R.id.editAvatarImage)
        descEditText=findViewById(R.id.editDesc)
        latitudeEditText=findViewById(R.id.editLat)
        longitudeEditText=findViewById(R.id.editLon)
        bottomNav=findViewById(R.id.bottom_navigation)

        bottomNav.setOnNavigationItemSelectedListener(mOnNavigationItemSelectedListener)

        avatarImage.setOnClickListener{
            val gallery = Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI)
            gallery.type="image/*"
            startActivityForResult(gallery, pickImage)
        }

    }

    override fun onStart() {
        super.onStart()

        isEditing=intent.getBooleanExtra("is_editing",true)
        if (isEditing){
            detailed_data=intent.getSerializableExtra("detailed_data") as CPU
            document_id=intent.getStringExtra("document_id")
            modelTextEdit.text=detailed_data.model!!.toEditable()
            manufacturerEditText.text=detailed_data.manufacturer!!.toEditable()
            frequencyTextEdit.text=detailed_data.frequency!!.toEditable()
            bitsdepthEditText.text=detailed_data.bitdepth!!.toEditable()
            numcoresEditText.text=detailed_data.numcores!!.toEditable()
            descEditText.text=detailed_data.description!!.toEditable()
            latitudeEditText.text=detailed_data.latitude.toString().toEditable()
            longitudeEditText.text=detailed_data.longitude.toString().toEditable()
            Glide.with(getApplicationContext())
                .load(detailed_data.avatar).placeholder(R.drawable.ic_user)
                .into(avatarImage)
        }
    }

    private fun validateFields (): String?{
        if (modelTextEdit.text.trim().toString().isNotEmpty() && manufacturerEditText.text.trim().toString().isNotEmpty()
            && frequencyTextEdit.text.trim().toString().isNotEmpty()
            && bitsdepthEditText.text.trim().toString().isNotEmpty()
            && numcoresEditText.text.trim().toString().isNotEmpty()
            && latitudeEditText.text.trim().toString().isNotEmpty()
            && longitudeEditText.text.trim().toString().isNotEmpty()){

            val x=latitudeEditText.text.trim().toString().toDoubleOrNull()
            val y=longitudeEditText.text.trim().toString().toDoubleOrNull()
            if ((x!=null && (x > -89.3 && x< 89.3)) && (y!=null && (y > -89.3 && y< 89.3))){
                return null
            }
            else return getString(R.string.edit_coords_value)
        }
        else return getString(R.string.edit_fill_all)
    }

    private fun DispatchAction(model: String?, manufacturer: String?, frequency: String?, bitsdepth: String?, numcores: String?,
                               latitude: String?, longitude: String?, desc: String?){
        val res=validateFields()
        if (res!=null){
            Toast.makeText(baseContext, res,
                Toast.LENGTH_SHORT).show()
        }
        else{
            uploadImage() {
                EditCharacter(
                    model!!,
                    manufacturer!!,
                    frequency!!,
                    bitsdepth!!,
                    numcores!!,
                    latitude!!,
                    longitude!!,
                    desc,
                    it
                )
            }
        }

    }

    fun uploadImage(callback: (String) -> Unit) {
        var ImageUrl = ""
        if (filePath!=null) {
            val imageRef = storageReference!!.child("images/" + UUID.randomUUID().toString())
            imageRef.putFile(filePath!!).addOnSuccessListener {
                ImageUrl = imageRef.toString()

                imageRef.downloadUrl.addOnSuccessListener({ Uri ->
                    ImageUrl = Uri.toString()
                    callback(ImageUrl)

                }).addOnFailureListener({
                    val imageURL = ""
                })
            }
        }

    }

    fun getRandomString(length: Int) : String {
        val charset = ('a'..'z') + ('A'..'Z') + ('0'..'9')
        return (1..length)
            .map { charset.random() }
            .joinToString("")
    }

    private fun EditCharacter(model: String?, manufacturer: String?, frequency: String?, bitsdepth: String?, numcores: String?,
                              latitude: String?, longitude: String?, desc: String? , avatar: String?){
        val db = Firebase.firestore
        db.collection("users").document(document_id!!)
            .update(mapOf(
                "model" to model, "manufacturer" to manufacturer, "frequency" to frequency,"bitsdepth" to bitsdepth,
                "description" to desc,"latitude" to latitude, "longitude" to longitude,
                "avatar" to avatar
            ))
            .addOnSuccessListener {
                Log.d("TAG", "DocumentSnapshot successfully updated!")
                var intent= Intent(this, TableActivity::class.java)
                startActivity(intent)
            }
            .addOnFailureListener { e -> Log.w("TAG", "Error updating document", e) }

    }


    private val mOnNavigationItemSelectedListener = BottomNavigationView.OnNavigationItemSelectedListener { item ->
        when (item.itemId) {
            R.id.back -> {
                finish()
                return@OnNavigationItemSelectedListener true
            }
            R.id.saveEdit -> {
                DispatchAction(modelTextEdit.text.trim().toString(), manufacturerEditText.text.trim().toString(),
                    frequencyTextEdit.text.trim().toString(),
                    bitsdepthEditText.text.trim().toString(),
                    numcoresEditText.text.trim().toString(),
                    latitudeEditText.text.trim().toString(),
                    longitudeEditText.text.trim().toString(), descEditText.text.toString())
                return@OnNavigationItemSelectedListener true
            }

        }
        false
    }

    override fun onActivityResult(
        requestCode: Int,
        resultCode: Int,
        data: Intent?
    ) {
        super.onActivityResult(
            requestCode,
            resultCode,
            data
        )
        if (requestCode == pickImage && resultCode == Activity.RESULT_OK && data != null && data.data != null) {

            // Get the Uri of data
            val uri = data.data
            filePath = uri
            try {
                uri?.let { avatarImage.setImageURI(it) }
            } catch (e: IOException) {
                // Log the exception
                e.printStackTrace()
            }
        }
    }

    fun String.toEditable(): Editable =  Editable.Factory.getInstance().newEditable(this)
}