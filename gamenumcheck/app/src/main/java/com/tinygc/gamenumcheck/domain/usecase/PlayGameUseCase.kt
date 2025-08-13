package com.tinygc.gamenumcheck.domain.usecase

import com.tinygc.gamenumcheck.domain.model.Game
import com.tinygc.gamenumcheck.domain.repository.GameRepository
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

class PlayGameUseCase @Inject constructor(
    private val gameRepository: GameRepository
) {
    suspend operator fun invoke(): Flow<Game> {
        return gameRepository.startNewGame()
    }
}