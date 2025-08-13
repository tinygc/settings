package com.tinygc.gamenumcheck.domain.model

data class Achievement(
    val title: String,
    val description: String,
    val emoji: String,
    val rank: AchievementRank
)

enum class AchievementRank { 
    LEGENDARY,      // 1回: 🌟超能力者！
    GENIUS,         // 2-3回: 🎯天才！
    GREAT,          // 4-5回: ✨すごい！
    GOOD,           // 6-7回: 👍やったね！
    NICE,           // 8-10回: 🌱がんばったね！
    KEEP_TRYING     // 11回以上: 💪ファイト！
}