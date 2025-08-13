package com.tinygc.gamenumcheck.presentation.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.tinygc.gamenumcheck.domain.model.Game
import com.tinygc.gamenumcheck.domain.usecase.CalculateAchievementUseCase
import com.tinygc.gamenumcheck.domain.usecase.GetHintUseCase
import com.tinygc.gamenumcheck.domain.usecase.PlayGameUseCase
import com.tinygc.gamenumcheck.domain.usecase.SubmitGuessUseCase
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class GameViewModel @Inject constructor(
    private val playGameUseCase: PlayGameUseCase,
    private val submitGuessUseCase: SubmitGuessUseCase,
    private val getHintUseCase: GetHintUseCase,
    private val calculateAchievementUseCase: CalculateAchievementUseCase
) : ViewModel() {
    
    private val _uiState = MutableStateFlow(GameUiState())
    val uiState: StateFlow<GameUiState> = _uiState.asStateFlow()
    
    private var currentGame: Game? = null
    
    init {
        startNewGame()
    }
    
    fun startNewGame() {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true)
            
            try {
                val game = playGameUseCase().first()
                currentGame = game
                
                _uiState.value = GameUiState(
                    targetNumber = game.targetNumber,
                    isLoading = false
                )
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(isLoading = false)
            }
        }
    }
    
    fun onNumberInput(digit: String) {
        val currentInput = _uiState.value.inputNumber
        if (currentInput.length < 3) { // 最大3桁まで
            _uiState.value = _uiState.value.copy(
                inputNumber = currentInput + digit
            )
        }
    }
    
    fun onDeleteInput() {
        val currentInput = _uiState.value.inputNumber
        if (currentInput.isNotEmpty()) {
            _uiState.value = _uiState.value.copy(
                inputNumber = currentInput.dropLast(1)
            )
        }
    }
    
    fun onClearInput() {
        _uiState.value = _uiState.value.copy(inputNumber = "")
    }
    
    fun submitGuess() {
        val inputNumber = _uiState.value.inputNumber
        if (inputNumber.isBlank()) return
        
        val guess = inputNumber.toIntOrNull() ?: return
        val game = currentGame ?: return
        
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true)
            
            try {
                val result = submitGuessUseCase(game, guess)
                result.onSuccess { updatedGame ->
                    currentGame = updatedGame
                    
                    if (updatedGame.isWon) {
                        // 正解時の処理
                        val achievement = calculateAchievementUseCase(updatedGame.attemptCount)
                        _uiState.value = _uiState.value.copy(
                            inputNumber = "",
                            attemptCount = updatedGame.attemptCount,
                            isGameFinished = true,
                            achievement = achievement,
                            showCelebration = true,
                            isLoading = false
                        )
                    } else {
                        // ヒント表示
                        val hint = getHintUseCase(
                            updatedGame.targetNumber, 
                            guess, 
                            updatedGame.attemptCount
                        )
                        _uiState.value = _uiState.value.copy(
                            inputNumber = "",
                            hint = hint,
                            attemptCount = updatedGame.attemptCount,
                            isLoading = false
                        )
                    }
                }.onFailure { error ->
                    _uiState.value = _uiState.value.copy(isLoading = false)
                }
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(isLoading = false)
            }
        }
    }
    
    fun resetGame() {
        _uiState.value = _uiState.value.copy(showCelebration = false)
        startNewGame()
    }
    
    fun dismissCelebration() {
        _uiState.value = _uiState.value.copy(showCelebration = false)
    }
}