package com.ots.gridpractice.model

import androidx.annotation.DrawableRes
import androidx.annotation.StringRes

data class Topic(
    @StringRes val titleStringResourceId: Int,
    val associatedCount: Int,
    @DrawableRes val imageResourceId: Int
)
