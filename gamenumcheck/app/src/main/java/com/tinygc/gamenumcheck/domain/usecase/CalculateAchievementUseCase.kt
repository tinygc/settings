package com.tinygc.gamenumcheck.domain.usecase

import com.tinygc.gamenumcheck.domain.model.Achievement
import com.tinygc.gamenumcheck.domain.model.AchievementRank
import javax.inject.Inject

class CalculateAchievementUseCase @Inject constructor() {
    
    operator fun invoke(attemptCount: Int): Achievement {
        return when (attemptCount) {
            1 -> Achievement("🌟超能力者！", "一発で当てるなんて神すぎ！", "🌟", AchievementRank.LEGENDARY)
            in 2..3 -> Achievement("🎯天才！", "めっちゃすごい直感力！", "🎯", AchievementRank.GENIUS)
            in 4..5 -> Achievement("✨すごい！", "センス抜群だね！", "✨", AchievementRank.GREAT)
            in 6..7 -> Achievement("👍やったね！", "よく頑張った！", "👍", AchievementRank.GOOD)
            in 8..10 -> Achievement("🌱がんばったね！", "諦めない心が素敵！", "🌱", AchievementRank.NICE)
            else -> Achievement("💪ファイト！", "次こそは！応援してるよ！", "💪", AchievementRank.KEEP_TRYING)
        }
    }
}