package com.ots.businesscard

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.ots.businesscard.ui.theme.BusinessCardTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            BusinessCardTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    BusinessCardLayout()
                }
            }
        }
    }
}

@Composable
fun BusinessCardLayout() {
    Column(
       Modifier.background(Color(210,232,210))
    ) {
        Column(
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally,
            modifier = Modifier.weight(1F, true)
        ) {
            val image = painterResource(id = R.drawable.omkar)
            Image(
                painter = image,
                contentDescription = null,
                Modifier.weight(2f),
                contentScale = ContentScale.Crop,
                )

            Column(
                Modifier.weight(1f),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Bottom
                ) {
                Text(text = "Omkar Shirote", fontSize = 40.sp)
                Text(text = "Full Stack Developer", fontSize = 20.sp,
                    textAlign = TextAlign.Center,
                    color = Color(45, 137, 92)
                    )
            }


        }

        Column(
            modifier = Modifier
                .weight(1F, true)
                .fillMaxWidth()
                .padding(bottom = 30.dp),
            verticalArrangement = Arrangement.Bottom,
            horizontalAlignment = Alignment.CenterHorizontally,
        ) {
            val call_icon = painterResource(id = R.drawable.baseline_call_24)
            val share_icon = painterResource(id = R.drawable.baseline_share_24)
            val email_icon = painterResource(id = R.drawable.baseline_email_24)
            BottomText(icon = call_icon, text = "+918275564152")
            BottomText(icon = share_icon, text = "omkar.shirote")
            BottomText(icon = email_icon, text = "omkarshirote@gmail.com")
        }
    }
}

@Composable
private fun BottomText( modifier: Modifier = Modifier ,icon: Painter, text: String){
    Row {
        Icon(painter = icon, contentDescription = null, Modifier.padding(12.dp))
        Text(text = text, Modifier.padding(start = 0.dp, end = 12.dp, top = 12.dp, bottom = 12.dp))
    }
}


@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    BusinessCardTheme {
        BusinessCardLayout()
    }
}