package com.tinygc.gamenumcheck.presentation.component

import androidx.compose.animation.*
import androidx.compose.animation.core.*
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import com.tinygc.gamenumcheck.domain.model.Achievement
import com.tinygc.gamenumcheck.domain.model.AchievementRank

@Composable
fun AchievementDialog(
    achievement: Achievement?,
    showDialog: Boolean,
    onDismiss: () -> Unit,
    modifier: Modifier = Modifier
) {
    if (showDialog && achievement != null) {
        Dialog(
            onDismissRequest = onDismiss,
            properties = DialogProperties(
                dismissOnBackPress = true,
                dismissOnClickOutside = true
            )
        ) {
            AchievementContent(
                achievement = achievement,
                modifier = modifier
            )
        }
    }
}

@Composable
private fun AchievementContent(
    achievement: Achievement,
    modifier: Modifier = Modifier
) {
    var isVisible by remember { mutableStateOf(false) }
    
    LaunchedEffect(Unit) {
        isVisible = true
    }
    
    val scale by animateFloatAsState(
        targetValue = if (isVisible) 1f else 0.8f,
        animationSpec = spring(
            dampingRatio = Spring.DampingRatioLowBouncy,
            stiffness = Spring.StiffnessMedium
        ),
        label = "scale"
    )
    
    Card(
        modifier = modifier
            .scale(scale)
            .fillMaxWidth(0.9f),
        colors = CardDefaults.cardColors(
            containerColor = Color.Transparent
        ),
        elevation = CardDefaults.cardElevation(defaultElevation = 16.dp)
    ) {
        Box(
            modifier = Modifier
                .background(
                    brush = getAchievementGradient(achievement.rank),
                    shape = RoundedCornerShape(20.dp)
                )
                .padding(32.dp),
            contentAlignment = Alignment.Center
        ) {
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center
            ) {
                // 称号アイコン
                Text(
                    text = achievement.emoji,
                    fontSize = 72.sp
                )
                
                Spacer(modifier = Modifier.height(16.dp))
                
                // 称号タイトル
                Text(
                    text = achievement.title,
                    fontSize = 28.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color.White,
                    textAlign = TextAlign.Center
                )
                
                Spacer(modifier = Modifier.height(12.dp))
                
                // 説明文
                Text(
                    text = achievement.description,
                    fontSize = 16.sp,
                    color = Color.White.copy(alpha = 0.9f),
                    textAlign = TextAlign.Center
                )
                
                Spacer(modifier = Modifier.height(24.dp))
                
                // 閉じるボタン
                Button(
                    onClick = { /* onDismiss() */ },
                    colors = ButtonDefaults.buttonColors(
                        containerColor = Color.White.copy(alpha = 0.2f),
                        contentColor = Color.White
                    ),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Text(
                        text = "もう一回！",
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Bold
                    )
                }
            }
        }
    }
}

@Composable
private fun getAchievementGradient(rank: AchievementRank): Brush {
    return when (rank) {
        AchievementRank.LEGENDARY -> Brush.radialGradient(
            colors = listOf(Color(0xFFFFD700), Color(0xFFFF6B35)) // Gold to Orange
        )
        AchievementRank.GENIUS -> Brush.radialGradient(
            colors = listOf(Color(0xFFAE8E0F), Color(0xFF6B46C1)) // Gold to Purple
        )
        AchievementRank.GREAT -> Brush.radialGradient(
            colors = listOf(Color(0xFF06D6A0), Color(0xFF118AB2)) // Teal to Blue
        )
        AchievementRank.GOOD -> Brush.radialGradient(
            colors = listOf(Color(0xFF4CAF50), Color(0xFF2196F3)) // Green to Blue
        )
        AchievementRank.NICE -> Brush.radialGradient(
            colors = listOf(Color(0xFF9C27B0), Color(0xFFE91E63)) // Purple to Pink
        )
        AchievementRank.KEEP_TRYING -> Brush.radialGradient(
            colors = listOf(Color(0xFFFF5722), Color(0xFFFF9800)) // Red to Orange
        )
    }
}