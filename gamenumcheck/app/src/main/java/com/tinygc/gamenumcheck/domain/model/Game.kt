package com.tinygc.gamenumcheck.domain.model

data class Game(
    val targetNumber: Int,
    val currentGuess: Int? = null,
    val attemptCount: Int = 0,
    val isFinished: Boolean = false,
    val isWon: Boolean = false
) {
    fun makeGuess(guess: Int): Game {
        return copy(
            currentGuess = guess,
            attemptCount = attemptCount + 1,
            isFinished = guess == targetNumber,
            isWon = guess == targetNumber
        )
    }
    
    fun isValidGuess(guess: Int): Boolean {
        return guess in 1..100
    }
}