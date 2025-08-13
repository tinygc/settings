package com.tinygc.gamenumcheck.domain.usecase

import com.tinygc.gamenumcheck.domain.model.Game
import com.tinygc.gamenumcheck.domain.repository.GameRepository
import javax.inject.Inject

class SubmitGuessUseCase @Inject constructor(
    private val gameRepository: GameRepository
) {
    suspend operator fun invoke(
        game: Game, 
        guess: Int
    ): Result<Game> {
        return try {
            if (!game.isValidGuess(guess)) {
                return Result.failure(IllegalArgumentException("Invalid guess: $guess. Must be between 1 and 100"))
            }
            
            val updatedGame = game.makeGuess(guess)
            gameRepository.updateGame(updatedGame)
            Result.success(updatedGame)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}