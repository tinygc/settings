package com.tinygc.gamenumcheck.domain.model

data class HintMessage(
    val type: HintType,
    val message: String,
    val intensity: HintIntensity
)

enum class HintType { 
    HIGHER, 
    LOWER, 
    CORRECT 
}

enum class HintIntensity { 
    MILD,       // 1-3回目: 「もっと大きい！」「もっと小さい！」
    MODERATE,   // 4-6回目: 「かなり大きい！」「ちょっと小さい！」
    STRONG,     // 7-9回目: 「あと少し！」「もうちょっと！」
    VERY_CLOSE  // 10回目以降: 「惜しい！○○に近いよ！」
}