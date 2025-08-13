package com.tinygc.gamenumcheck.data.datasource

import com.tinygc.gamenumcheck.domain.model.Game
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flowOf
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class InMemoryGameDataSource @Inject constructor() : GameDataSource {
    
    private val gameHistory = mutableListOf<Game>()
    
    override suspend fun saveGame(game: Game) {
        gameHistory.add(game)
    }
    
    override suspend fun getGameHistory(): Flow<List<Game>> {
        return flowOf(gameHistory.toList())
    }
    
    override suspend fun clearHistory() {
        gameHistory.clear()
    }
}