package aminlexscorp.cpu_catalog2

import aminlexscorp.cpu_catalog2.beans.CPU
import android.content.Context
import android.os.Bundle
import android.view.GestureDetector
import android.view.GestureDetector.SimpleOnGestureListener
import android.view.MotionEvent
import android.view.View
import android.view.View.OnTouchListener
import android.widget.ImageView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.bumptech.glide.Glide


class ImageActivity : AppCompatActivity() {

    private lateinit var detailed_data: CPU
    private lateinit var imageview: ImageView
    var index = 0
    var count = 0
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_image_view)
        detailed_data=intent.getSerializableExtra("detailed_data") as CPU
        imageview=findViewById(R.id.image_preview)
        Glide.with(getApplicationContext())
            .load(detailed_data.images!![index]).placeholder(R.drawable.ic_user)
            .into(imageview)
        count = detailed_data.images!!.size

        imageview.setOnTouchListener(object : View.OnTouchListener  {

            private val gestureDetector: GestureDetector
            fun onSwipeLeft() {
                if(index < count - 1) {
                    index++
                    Glide.with(getApplicationContext())
                        .load(detailed_data.images!![index]).placeholder(R.drawable.ic_user)
                        .into(imageview)

                }
            }
            fun onSwipeRight() {
                if(index!=0) {
                    index--
                    Glide.with(getApplicationContext())
                        .load(detailed_data.images!![index]).placeholder(R.drawable.ic_user)
                        .into(imageview)

                }
            }
            override fun onTouch(v: View?, event: MotionEvent?): Boolean {
                return gestureDetector.onTouchEvent(event)
            }

            private inner class GestureListener : SimpleOnGestureListener() {
                override fun onDown(e: MotionEvent): Boolean {
                    return true
                }

                override fun onFling(
                    e1: MotionEvent,
                    e2: MotionEvent,
                    velocityX: Float,
                    velocityY: Float
                ): Boolean {
                    val distanceX = e2.x - e1.x
                    val distanceY = e2.y - e1.y
                    if (Math.abs(distanceX) > Math.abs(distanceY) && Math.abs(
                            distanceX
                        ) > SWIPE_DISTANCE_THRESHOLD && Math.abs(
                            velocityX
                        ) > SWIPE_VELOCITY_THRESHOLD
                    ) {
                        if (distanceX > 0) onSwipeRight() else onSwipeLeft()
                        return true
                    }
                    return false
                }


                private  val SWIPE_DISTANCE_THRESHOLD = 100
                private  val SWIPE_VELOCITY_THRESHOLD = 100

            }

            init {
                gestureDetector = GestureDetector(baseContext, GestureListener())
            }


        }
        )

    }

}

