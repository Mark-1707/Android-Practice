package com.ots.learntogether

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.ots.learntogether.ui.theme.LearnTogetherTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            LearnTogetherTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    ComposeArticleApp()
                }
            }
        }
    }
}

@Composable
fun ComposeArticleApp(){
    ComposeArticleCard(title = stringResource(R.string.title), shortDesc = stringResource(R.string.shortDesc), longDesc = stringResource(R.string.longDesc
    ), imagePainter = painterResource(id = R.drawable.bg_compose_background))
}

@Composable
fun ComposeArticleCard(
    title: String,
    shortDesc: String,
    longDesc: String,
    imagePainter: Painter,
    modifier: Modifier = Modifier,
){
    Column(modifier = modifier) {
        Image(painter = imagePainter, contentDescription = null )
        Text(text = title, modifier = Modifier.padding(16.dp), fontSize = 24.sp)
        Text(text = shortDesc, modifier = Modifier.padding(16.dp, 0.dp), textAlign =  TextAlign.Justify)
        Text(text = longDesc, modifier = Modifier.padding(16.dp), textAlign =  TextAlign.Justify)
    }
}

@Preview(showBackground = true)
@Composable
fun ComposeArticleAppPreview() {
    LearnTogetherTheme {
        ComposeArticleApp()
    }
}