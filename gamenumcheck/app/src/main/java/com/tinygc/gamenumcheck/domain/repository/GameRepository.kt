package com.tinygc.gamenumcheck.domain.repository

import com.tinygc.gamenumcheck.domain.model.Game
import kotlinx.coroutines.flow.Flow

interface GameRepository {
    suspend fun startNewGame(): Flow<Game>
    suspend fun updateGame(game: Game): Game
    suspend fun getCurrentGame(): Game?
    suspend fun saveGameHistory(game: Game)
    suspend fun getGameHistory(): Flow<List<Game>>
}