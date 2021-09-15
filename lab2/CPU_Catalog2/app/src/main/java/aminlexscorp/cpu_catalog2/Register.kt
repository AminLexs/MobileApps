package aminlexscorp.cpu_catalog2

//import android.R
import android.app.Activity
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.net.Uri
import android.os.Bundle
import android.util.Patterns
import android.view.View
import android.widget.EditText
import android.widget.ImageView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.text.isDigitsOnly
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.storage.FirebaseStorage
import com.google.firebase.storage.StorageReference
import java.io.IOException
import java.util.*
import kotlin.collections.HashMap


class Register : AppCompatActivity() {
    lateinit var editEmail: EditText
    lateinit var editPassword: EditText
    lateinit var editManufacturer: EditText
    lateinit var editModel: EditText
    lateinit var editBitsdepth: EditText
    lateinit var editFrequency: EditText
    lateinit var editNumcores: EditText
    lateinit var imageView: ImageView
    internal var storage:FirebaseStorage?=null
    internal var storageReference:StorageReference?=null
    private var filePath:Uri? = null


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_register)
        editEmail = findViewById(R.id.RegisterEditTextEmailAddress) as EditText
        editPassword = findViewById(R.id.RegisterEditTextPassword) as EditText
        editManufacturer = findViewById(R.id.RegisterEditTextManufacturer) as EditText
        editModel = findViewById(R.id.RegisterEditTextModel) as EditText
        editBitsdepth = findViewById(R.id.RegisterEditTextBitsdepth) as EditText
        editFrequency = findViewById(R.id.RegisterEditTextFrequency) as EditText
        editNumcores = findViewById(R.id.RegisterEditTextNumcores) as EditText
        imageView  = findViewById(R.id.RegisterImageViewAvatar) as ImageView
        imageView.setOnClickListener {
            selectImage()
        }
        storage= FirebaseStorage.getInstance()
        storageReference = storage!!.reference
    }

    private fun selectImage() {

        val intent = Intent()
        intent.type = "image/*"
        intent.action = Intent.ACTION_GET_CONTENT
        startActivityForResult(
            Intent.createChooser(
                intent,
                "Select Image from here..."
            ),
            PICK_IMAGE_REQUEST
        )
    }

    fun registerClick(view: View) {
        val fAuth: FirebaseAuth =  FirebaseAuth.getInstance();
        val db: FirebaseFirestore = FirebaseFirestore.getInstance()

        if(!Patterns.EMAIL_ADDRESS.matcher(editEmail.text.toString()).matches()){
            Toast.makeText( baseContext,"Wrong email.", Toast.LENGTH_SHORT).show()
            return
        }
        if(editPassword.text.toString().isEmpty()){
            Toast.makeText( baseContext,"Empty password.", Toast.LENGTH_SHORT).show()
            return
        }


        fAuth.createUserWithEmailAndPassword(editEmail.text.toString(),editPassword.text.toString()).addOnCompleteListener(this){
            task ->
            if (task.isSuccessful){
                val user: MutableMap<String, Any> = HashMap()

                    uploadImage(){
                        user["image"] = it
                        user["manufacturer"] = editManufacturer.text.toString()
                    user["model"] = editModel.text.toString()
                    user["bitsdepth"] = "x" + editBitsdepth.text.toString()
                    user["frequency"] = editFrequency.text.toString() + " GHz"
                    user["numcores"] = editNumcores.text.toString()

                    db.collection("users").add(user).addOnCompleteListener(this){
                    task ->
                    if (task.isSuccessful){
                        val intent = Intent(this, MainActivity::class.java)
                        startActivity(intent)
                    }else{
                            Toast.makeText( baseContext,"Database failed.", Toast.LENGTH_SHORT).show()
                        }
                    }
                }
            }else{
                Toast.makeText( baseContext,"Registration failed.", Toast.LENGTH_SHORT).show()
            }
        }

    }

    fun uploadImage(callback: (String) -> Unit){
        var ImageUrl = ""
        if (filePath!=null) {
            val imageRef = storageReference!!.child("images/" + UUID.randomUUID().toString())
            imageRef.putFile(filePath!!)
            ImageUrl = imageRef.toString()

            imageRef.downloadUrl.addOnSuccessListener( { Uri->
                ImageUrl = Uri.toString()
                callback(ImageUrl)

            }).addOnFailureListener({
                val imageURL = ""
            })
        }

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
        if (requestCode == PICK_IMAGE_REQUEST && resultCode == Activity.RESULT_OK && data != null && data.data != null) {

            // Get the Uri of data
            val uri = data.data
            filePath = uri
            try {
                uri?.let { imageView.setImageURI(it) }
            } catch (e: IOException) {
                // Log the exception
                e.printStackTrace()
            }
        }
    }

    companion object {
        const val PICK_IMAGE_REQUEST = 22
    }
}