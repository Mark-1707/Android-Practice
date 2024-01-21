package com.ots.artspace

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.annotation.StringRes
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.ots.artspace.ui.theme.ArtSpaceTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            ArtSpaceTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    ArtSpaceBase()
                }
            }
        }
    }
}

@Composable
fun ArtSpaceBase(){

    var index by remember { mutableStateOf(1) }

    val artwork = when (index) {
        1 -> R.drawable.artwork1
        2 -> R.drawable.artwork2
        else -> R.drawable.artwork3
    }

    val artist = when (index) {
        1 -> R.string.artist1
        2 -> R.string.artist2
        else -> R.string.artist3
    }

    val quote = when (index) {
        1 -> R.string.quote1
        2 -> R.string.quote2
        else -> R.string.quote3
    }

    Column(
        modifier = Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.SpaceEvenly,
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        Surface(shadowElevation = 20.dp) {
            Column(
                modifier = Modifier.padding(20.dp)
            ){
                val image = painterResource(id = artwork)
                Image(painter = image, contentDescription = "Main Image", modifier = Modifier.width(300.dp).height(500.dp))
            }
        }

        Column(
            modifier = Modifier
                .background(color = Color(android.graphics.Color.parseColor("#AEC7F6")))
                .width(310.dp)
                .height(120.dp)
                .padding(20.dp),
            horizontalAlignment = Alignment.Start,
            verticalArrangement = Arrangement.Center
        ) {

            TextForArtist(modifier = Modifier, text = quote, textStyle = 400)
            TextForArtist(modifier = Modifier, text = artist, textStyle = 800)

        }

        Row(
            horizontalArrangement = Arrangement.SpaceBetween,
            modifier = Modifier.fillMaxWidth()
                .padding(horizontal = 40.dp)
        ) {

            ActionButtons(modifier = Modifier.width(120.dp), text = R.string.previous_btn , onClick = {
                if(index == 0) index = 3
                else index -= 1
            })

            ActionButtons(modifier = Modifier.width(120.dp), text = R.string.next_btn , onClick = {
                if(index == 3) index = 1
                else index += 1
            })
        }

    }
}

@Composable
fun TextForArtist(modifier: Modifier = Modifier, @StringRes text: Int, textStyle: Int){
    Text(text = stringResource(id = text), modifier =  modifier, fontWeight = FontWeight(textStyle))
}

@Composable
fun ActionButtons(modifier: Modifier = Modifier, @StringRes text: Int, onClick: () -> Unit){
    Button(modifier = modifier, onClick = onClick) {
        Text(text = stringResource(id = text))
    }
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    ArtSpaceTheme {
        ArtSpaceBase()
    }
}