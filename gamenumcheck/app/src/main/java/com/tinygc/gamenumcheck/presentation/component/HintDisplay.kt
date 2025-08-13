package com.tinygc.gamenumcheck.presentation.component

import androidx.compose.animation.*
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.tinygc.gamenumcheck.domain.model.HintMessage
import com.tinygc.gamenumcheck.domain.model.HintIntensity
import com.tinygc.gamenumcheck.domain.model.HintType

@Composable
fun HintDisplay(
    hint: HintMessage?,
    modifier: Modifier = Modifier
) {
    AnimatedVisibility(
        visible = hint != null,
        enter = slideInVertically() + fadeIn(),
        exit = slideOutVertically() + fadeOut(),
        modifier = modifier
    ) {
        hint?.let { hintMessage ->
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp),
                colors = CardDefaults.cardColors(
                    containerColor = getHintBackgroundColor(hintMessage.intensity)
                ),
                elevation = CardDefaults.cardElevation(defaultElevation = 8.dp)
            ) {
                Column(
                    modifier = Modifier.padding(24.dp),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Text(
                        text = "ヒント",
                        fontSize = 16.sp,
                        color = Color.White.copy(alpha = 0.8f)
                    )
                    
                    Spacer(modifier = Modifier.height(8.dp))
                    
                    Text(
                        text = hintMessage.message,
                        fontSize = 24.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color.White,
                        textAlign = TextAlign.Center
                    )
                    
                    Spacer(modifier = Modifier.height(8.dp))
                    
                    Text(
                        text = getIntensityIndicator(hintMessage.intensity),
                        fontSize = 32.sp
                    )
                }
            }
        }
    }
}

@Composable
private fun getHintBackgroundColor(intensity: HintIntensity): Color {
    return when (intensity) {
        HintIntensity.MILD -> Color(0xFF6366F1)       // Indigo
        HintIntensity.MODERATE -> Color(0xFF8B5CF6)   // Purple
        HintIntensity.STRONG -> Color(0xFFEC4899)     // Pink
        HintIntensity.VERY_CLOSE -> Color(0xFFF59E0B) // Amber
    }
}

private fun getIntensityIndicator(intensity: HintIntensity): String {
    return when (intensity) {
        HintIntensity.MILD -> "🤔"
        HintIntensity.MODERATE -> "🧐"  
        HintIntensity.STRONG -> "😤"
        HintIntensity.VERY_CLOSE -> "🔥"
    }
}