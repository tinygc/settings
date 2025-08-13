package com.tinygc.gamenumcheck.di

import com.tinygc.gamenumcheck.data.datasource.GameDataSource
import com.tinygc.gamenumcheck.data.datasource.InMemoryGameDataSource
import com.tinygc.gamenumcheck.data.repository.GameRepositoryImpl
import com.tinygc.gamenumcheck.data.repository.RandomNumberRepositoryImpl
import com.tinygc.gamenumcheck.domain.repository.GameRepository
import com.tinygc.gamenumcheck.domain.repository.RandomNumberRepository
import dagger.Binds
import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent

@Module
@InstallIn(SingletonComponent::class)
abstract class GameModule {
    
    @Binds
    abstract fun bindGameRepository(
        gameRepositoryImpl: GameRepositoryImpl
    ): GameRepository
    
    @Binds
    abstract fun bindRandomNumberRepository(
        randomNumberRepositoryImpl: RandomNumberRepositoryImpl
    ): RandomNumberRepository
    
    @Binds
    abstract fun bindGameDataSource(
        inMemoryGameDataSource: InMemoryGameDataSource
    ): GameDataSource
}