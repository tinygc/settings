package com.tinygc.gamenumcheck.domain.usecase

import com.tinygc.gamenumcheck.domain.model.HintMessage
import com.tinygc.gamenumcheck.domain.model.HintType
import com.tinygc.gamenumcheck.domain.model.HintIntensity
import javax.inject.Inject
import kotlin.math.abs

class GetHintUseCase @Inject constructor() {
    
    operator fun invoke(
        targetNumber: Int,
        guess: Int,
        attemptCount: Int
    ): HintMessage {
        val difference = abs(targetNumber - guess)
        val type = if (guess < targetNumber) HintType.HIGHER else HintType.LOWER
        
        return when {
            difference <= 5 -> HintMessage(type, "あと少し！", HintIntensity.VERY_CLOSE)
            difference <= 15 -> HintMessage(type, "もうちょっと！", HintIntensity.STRONG)
            difference <= 30 -> HintMessage(type, getModerateMessage(type), HintIntensity.MODERATE)
            else -> HintMessage(type, getMildMessage(type), HintIntensity.MILD)
        }
    }
    
    private fun getMildMessage(type: HintType): String = when(type) {
        HintType.HIGHER -> "もっと大きい！"
        HintType.LOWER -> "もっと小さい！"
        else -> ""
    }
    
    private fun getModerateMessage(type: HintType): String = when(type) {
        HintType.HIGHER -> "かなり大きい！"
        HintType.LOWER -> "ちょっと小さい！"
        else -> ""
    }
}