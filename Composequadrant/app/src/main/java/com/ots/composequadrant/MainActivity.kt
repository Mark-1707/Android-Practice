package com.ots.composequadrant

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.ots.composequadrant.R
import com.ots.composequadrant.ui.theme.ComposeQuadrantTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            ComposeQuadrantTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    QuadrantCard()
                }
            }
        }
    }
}

@Composable
fun QuadrantCard(){
    Column(
        Modifier
            .fillMaxWidth()
            .padding(16.dp)
    ) {
        Row(
            Modifier.weight(1f)
        ) {
            Card(
                title = stringResource(R.string.first_title),
                desc = stringResource(R.string.first_description),
                modifier = Modifier.weight(1f),
                backgroundColor = 0xFFEADDFF,
            )
            Card(
                title = stringResource(R.string.second_title),
                desc = stringResource(R.string.second_description),
                modifier = Modifier.weight(1f),
                backgroundColor = 0xFFD0BCFF,
            )
        }

        Row(
            Modifier.weight(1f)
        ) {
            Card(
                title = stringResource(R.string.third_title),
                desc = stringResource(R.string.third_description),
                modifier = Modifier.weight(1f),
                backgroundColor = 0xFFB69DF8,
            )
            Card(
                title = stringResource(R.string.fourth_title),
                desc = stringResource(R.string.fourth_description),
                modifier = Modifier.weight(1f),
                backgroundColor = 0xFFF6EDFF,
                )
        }
    }
}

@Composable
private fun Card(
    title: String,
    desc: String,
    modifier: Modifier = Modifier,
    backgroundColor: Long
){
    Column(
        modifier = modifier
            .fillMaxSize()
            .background(color = Color(backgroundColor))
        .padding(16.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        Text(text = title, fontWeight = FontWeight.Bold, modifier = Modifier.padding(bottom = 16.dp))
        Text(text = desc, textAlign = TextAlign.Center)
    }
}

@Preview(showBackground = true)
@Composable
fun ComposeQuadrantAppPreview() {
    ComposeQuadrantTheme {
        QuadrantCard()
    }
}