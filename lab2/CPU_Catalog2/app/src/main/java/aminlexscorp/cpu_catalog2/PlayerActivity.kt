package aminlexscorp.cpu_catalog2

import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.ImageButton
import android.widget.MediaController
import android.widget.VideoView
import androidx.appcompat.app.AppCompatActivity
import aminlexscorp.cpu_catalog2.R

class PlayerActivity: AppCompatActivity() {

    private var ctlr: MediaController? = null
    private lateinit var closePlayer: ImageButton
    private lateinit var videoView: VideoView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_player)
        closePlayer=findViewById(R.id.closePlayerButton)
        closePlayer.setOnClickListener{
            videoView.resume()
            finish()
        }
    }

    override fun onStart() {
        super.onStart()
        val url=intent.getStringExtra("video_url") as String
        videoView = findViewById(R.id.playerView)
        videoView.setVideoPath(url)
        videoView.start()
        ctlr = MediaController(this)
        ctlr!!.setMediaPlayer(videoView)
        videoView.setMediaController(ctlr)
        videoView.requestFocus()
    }
}