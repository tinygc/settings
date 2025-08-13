package com.tinygc.gamenumcheck.domain.usecase

import com.tinygc.gamenumcheck.domain.model.AchievementRank
import org.junit.Test
import org.junit.Assert.*

class CalculateAchievementUseCaseTest {

    private val useCase = CalculateAchievementUseCase()

    @Test
    fun `should return LEGENDARY achievement for 1 attempt`() {
        // When
        val result = useCase(1)

        // Then
        assertEquals(AchievementRank.LEGENDARY, result.rank)
        assertEquals("🌟超能力者！", result.title)
        assertEquals("一発で当てるなんて神すぎ！", result.description)
        assertEquals("🌟", result.emoji)
    }

    @Test
    fun `should return GENIUS achievement for 2-3 attempts`() {
        // When
        val result2 = useCase(2)
        val result3 = useCase(3)

        // Then
        assertEquals(AchievementRank.GENIUS, result2.rank)
        assertEquals("🎯天才！", result2.title)
        assertEquals("めっちゃすごい直感力！", result2.description)
        assertEquals("🎯", result2.emoji)

        assertEquals(AchievementRank.GENIUS, result3.rank)
    }

    @Test
    fun `should return GREAT achievement for 4-5 attempts`() {
        // When
        val result4 = useCase(4)
        val result5 = useCase(5)

        // Then
        assertEquals(AchievementRank.GREAT, result4.rank)
        assertEquals("✨すごい！", result4.title)
        assertEquals("センス抜群だね！", result4.description)
        assertEquals("✨", result4.emoji)

        assertEquals(AchievementRank.GREAT, result5.rank)
    }

    @Test
    fun `should return GOOD achievement for 6-7 attempts`() {
        // When
        val result6 = useCase(6)
        val result7 = useCase(7)

        // Then
        assertEquals(AchievementRank.GOOD, result6.rank)
        assertEquals("👍やったね！", result6.title)
        assertEquals("よく頑張った！", result6.description)
        assertEquals("👍", result6.emoji)

        assertEquals(AchievementRank.GOOD, result7.rank)
    }

    @Test
    fun `should return NICE achievement for 8-10 attempts`() {
        // When
        val result8 = useCase(8)
        val result10 = useCase(10)

        // Then
        assertEquals(AchievementRank.NICE, result8.rank)
        assertEquals("🌱がんばったね！", result8.title)
        assertEquals("諦めない心が素敵！", result8.description)
        assertEquals("🌱", result8.emoji)

        assertEquals(AchievementRank.NICE, result10.rank)
    }

    @Test
    fun `should return KEEP_TRYING achievement for 11+ attempts`() {
        // When
        val result11 = useCase(11)
        val result20 = useCase(20)

        // Then
        assertEquals(AchievementRank.KEEP_TRYING, result11.rank)
        assertEquals("💪ファイト！", result11.title)
        assertEquals("次こそは！応援してるよ！", result11.description)
        assertEquals("💪", result11.emoji)

        assertEquals(AchievementRank.KEEP_TRYING, result20.rank)
    }
}