package com.tinygc.gamenumcheck.domain.usecase

import com.tinygc.gamenumcheck.domain.model.HintIntensity
import com.tinygc.gamenumcheck.domain.model.HintType
import org.junit.Test
import org.junit.Assert.*

class GetHintUseCaseTest {

    private val useCase = GetHintUseCase()

    @Test
    fun `should return HIGHER hint when guess is lower than target`() {
        // Given
        val targetNumber = 50
        val guess = 30
        val attemptCount = 1

        // When
        val result = useCase(targetNumber, guess, attemptCount)

        // Then
        assertEquals(HintType.HIGHER, result.type)
        assertTrue(result.message.contains("大きい"))
    }

    @Test
    fun `should return LOWER hint when guess is higher than target`() {
        // Given
        val targetNumber = 50
        val guess = 70
        val attemptCount = 1

        // When
        val result = useCase(targetNumber, guess, attemptCount)

        // Then
        assertEquals(HintType.LOWER, result.type)
        assertTrue(result.message.contains("小さい"))
    }

    @Test
    fun `should return VERY_CLOSE intensity when difference is 5 or less`() {
        // Given
        val targetNumber = 50
        val guess = 47  // difference = 3
        val attemptCount = 10

        // When
        val result = useCase(targetNumber, guess, attemptCount)

        // Then
        assertEquals(HintIntensity.VERY_CLOSE, result.intensity)
        assertTrue(result.message.contains("あと少し"))
    }

    @Test
    fun `should return STRONG intensity when difference is between 6 and 15`() {
        // Given
        val targetNumber = 50
        val guess = 40  // difference = 10
        val attemptCount = 7

        // When
        val result = useCase(targetNumber, guess, attemptCount)

        // Then
        assertEquals(HintIntensity.STRONG, result.intensity)
        assertTrue(result.message.contains("もうちょっと"))
    }

    @Test
    fun `should return MODERATE intensity when difference is between 16 and 30`() {
        // Given
        val targetNumber = 50
        val guess = 25  // difference = 25
        val attemptCount = 4

        // When
        val result = useCase(targetNumber, guess, attemptCount)

        // Then
        assertEquals(HintIntensity.MODERATE, result.intensity)
        assertTrue(result.message.contains("かなり") || result.message.contains("ちょっと"))
    }

    @Test
    fun `should return MILD intensity when difference is more than 30`() {
        // Given
        val targetNumber = 50
        val guess = 10  // difference = 40
        val attemptCount = 1

        // When
        val result = useCase(targetNumber, guess, attemptCount)

        // Then
        assertEquals(HintIntensity.MILD, result.intensity)
        assertTrue(result.message.contains("もっと"))
    }
}