package com.tinygc.gamenumcheck.data.repository

import com.tinygc.gamenumcheck.data.datasource.GameDataSource
import com.tinygc.gamenumcheck.domain.model.Game
import com.tinygc.gamenumcheck.domain.repository.GameRepository
import com.tinygc.gamenumcheck.domain.repository.RandomNumberRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.flowOf
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GameRepositoryImpl @Inject constructor(
    private val randomNumberRepository: RandomNumberRepository,
    private val gameDataSource: GameDataSource
) : GameRepository {
    
    private val _currentGame = MutableStateFlow<Game?>(null)
    
    override suspend fun startNewGame(): Flow<Game> {
        val targetNumber = randomNumberRepository.generateNumber()
        val newGame = Game(targetNumber = targetNumber)
        _currentGame.value = newGame
        return flowOf(newGame)
    }
    
    override suspend fun updateGame(game: Game): Game {
        _currentGame.value = game
        if (game.isFinished) {
            gameDataSource.saveGame(game)
        }
        return game
    }
    
    override suspend fun getCurrentGame(): Game? {
        return _currentGame.value
    }
    
    override suspend fun saveGameHistory(game: Game) {
        gameDataSource.saveGame(game)
    }
    
    override suspend fun getGameHistory(): Flow<List<Game>> {
        return gameDataSource.getGameHistory()
    }
}