package com.tinygc.gamenumcheck

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.ui.Modifier
import com.tinygc.gamenumcheck.presentation.screen.GameScreen
import com.tinygc.gamenumcheck.ui.theme.GamenumcheckTheme
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            GamenumcheckTheme {
                GameScreen(
                    modifier = Modifier.fillMaxSize()
                )
            }
        }
    }
}