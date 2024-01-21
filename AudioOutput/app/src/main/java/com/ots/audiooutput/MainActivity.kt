package com.ots.audiooutput

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.mediarouter.media.MediaRouteSelector
import com.ots.audiooutput.ui.theme.AudioOutputTheme

class MainActivity : ComponentActivity() {

    private var mSelector: MediaRouteSelector? = null


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            AudioOutputTheme {
                // Set up your UI
            }
        }
    }
}

