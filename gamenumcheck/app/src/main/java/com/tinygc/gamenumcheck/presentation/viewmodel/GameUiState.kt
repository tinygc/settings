package com.tinygc.gamenumcheck.presentation.viewmodel

import com.tinygc.gamenumcheck.domain.model.Achievement
import com.tinygc.gamenumcheck.domain.model.HintMessage

data class GameUiState(
    val inputNumber: String = "",
    val hint: HintMessage? = null,
    val attemptCount: Int = 0,
    val isGameFinished: Boolean = false,
    val achievement: Achievement? = null,
    val isLoading: Boolean = false,
    val targetNumber: Int = 0,
    val showCelebration: Boolean = false
)