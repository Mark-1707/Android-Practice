package com.ots.gridpractice

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.ots.gridpractice.model.Topic
import com.ots.gridpractice.ui.theme.GridPracticeTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            GridPracticeTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    color = MaterialTheme.colorScheme.background
                ) {
                    GridApp()
                }
            }
        }
    }
}

@Composable
fun GridApp(){
    GridList(topicList = DataSource.topics)
}

@Composable
fun GridCard(topic: Topic , modifier: Modifier = Modifier){
    Row(
        modifier = Modifier
            .height(68.dp)
            .background(color = Color(230, 224, 235), RoundedCornerShape(10.dp))
            .clip(shape = RoundedCornerShape(10.dp))
    ) {
        Image(
            modifier = Modifier.width(68.dp),
            painter = painterResource(topic.imageResourceId),
            contentDescription = stringResource(id = topic.titleStringResourceId),
            contentScale = ContentScale.Crop
        )

        Column(
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.Start,
            modifier = Modifier.padding(16.dp, 16.dp, 16.dp, 0.dp)
        ) {
            Text(
                modifier = Modifier.padding(0.dp, 0.dp, 0.dp, 8.dp),
                fontWeight = FontWeight.Medium,
                text = stringResource(
                    id = topic.titleStringResourceId
                )
            )

            Row {
                Image(
                    painter = painterResource(id = R.drawable.ic_grain),
                    contentDescription = "crafts",
                    colorFilter = ColorFilter.tint(color = Color(71,69,77)),
                    modifier = Modifier.padding(0.dp, 0.dp, 8.dp, 0.dp)
                )

                Text(
                    text = topic.associatedCount.toString(),
                    fontWeight = FontWeight.SemiBold
                )
            }
        }
    }
}

@Composable
fun GridList(topicList : List<Topic>){
    LazyVerticalGrid(
        columns = GridCells.Fixed(2),
        contentPadding = PaddingValues(8.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp),
        horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
        items(topicList){topic->
            GridCard(
                topic = topic
            )
        }
    }
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    GridPracticeTheme {
//        GridCard()
    }
}