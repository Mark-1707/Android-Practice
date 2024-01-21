package com.ots.smsintent

import android.content.Context
import android.media.MediaPlayer

object MediaPlayerSingleton {

    private var mediaPlayer: MediaPlayer? = null

    fun getMediaPlayer(context: Context): MediaPlayer {
        if (mediaPlayer == null) {
            mediaPlayer = MediaPlayer.create(context.applicationContext, R.raw.alarm)
        }
        return mediaPlayer!!
    }

    fun isPlaying(): Boolean? {
        return mediaPlayer?.isPlaying
    }

    fun releaseMediaPlayer() {
        mediaPlayer?.release()
        mediaPlayer = null
    }
}
