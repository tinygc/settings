package com.tinygc.gamenumcheck.data.repository

import com.tinygc.gamenumcheck.domain.repository.RandomNumberRepository
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.random.Random

@Singleton
class RandomNumberRepositoryImpl @Inject constructor() : RandomNumberRepository {
    
    private val random = Random.Default
    
    override fun generateNumber(min: Int, max: Int): Int {
        return random.nextInt(min, max + 1)
    }
}