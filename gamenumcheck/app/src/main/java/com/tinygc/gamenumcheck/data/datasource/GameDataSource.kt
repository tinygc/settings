package com.tinygc.gamenumcheck.data.datasource

import com.tinygc.gamenumcheck.domain.model.Game
import kotlinx.coroutines.flow.Flow

interface GameDataSource {
    suspend fun saveGame(game: Game)
    suspend fun getGameHistory(): Flow<List<Game>>
    suspend fun clearHistory()
}