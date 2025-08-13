package com.tinygc.gamenumcheck.presentation.component

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
fun NumberKeypad(
    onNumberClick: (String) -> Unit,
    onDeleteClick: () -> Unit,
    onEnterClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Column(
        modifier = modifier,
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        // 1-3行
        Row(
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            NumberButton("1", onClick = { onNumberClick("1") }, modifier = Modifier.weight(1f))
            NumberButton("2", onClick = { onNumberClick("2") }, modifier = Modifier.weight(1f))
            NumberButton("3", onClick = { onNumberClick("3") }, modifier = Modifier.weight(1f))
        }
        
        // 4-6行
        Row(
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            NumberButton("4", onClick = { onNumberClick("4") }, modifier = Modifier.weight(1f))
            NumberButton("5", onClick = { onNumberClick("5") }, modifier = Modifier.weight(1f))
            NumberButton("6", onClick = { onNumberClick("6") }, modifier = Modifier.weight(1f))
        }
        
        // 7-9行
        Row(
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            NumberButton("7", onClick = { onNumberClick("7") }, modifier = Modifier.weight(1f))
            NumberButton("8", onClick = { onNumberClick("8") }, modifier = Modifier.weight(1f))
            NumberButton("9", onClick = { onNumberClick("9") }, modifier = Modifier.weight(1f))
        }
        
        // 削除・0・決定行
        Row(
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            ActionButton("⌫", onClick = onDeleteClick, modifier = Modifier.weight(1f))
            NumberButton("0", onClick = { onNumberClick("0") }, modifier = Modifier.weight(1f))
            ActionButton("✓", onClick = onEnterClick, modifier = Modifier.weight(1f))
        }
    }
}

@Composable
private fun NumberButton(
    text: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Button(
        onClick = onClick,
        modifier = modifier.height(60.dp),
        colors = ButtonDefaults.buttonColors(
            containerColor = MaterialTheme.colorScheme.primary,
            contentColor = Color.White
        ),
        shape = RoundedCornerShape(12.dp)
    ) {
        Text(
            text = text,
            fontSize = 24.sp,
            fontWeight = FontWeight.Bold
        )
    }
}

@Composable
private fun ActionButton(
    text: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Button(
        onClick = onClick,
        modifier = modifier.height(60.dp),
        colors = ButtonDefaults.buttonColors(
            containerColor = MaterialTheme.colorScheme.secondary,
            contentColor = Color.White
        ),
        shape = RoundedCornerShape(12.dp)
    ) {
        Text(
            text = text,
            fontSize = 20.sp,
            fontWeight = FontWeight.Bold
        )
    }
}