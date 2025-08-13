package com.tinygc.gamenumcheck.domain.repository

interface RandomNumberRepository {
    fun generateNumber(min: Int = 1, max: Int = 100): Int
}