# 数字あてゲーム Clean Architecture 設計書

## 🏗️ アーキテクチャ概要

Clean Architectureの原則に基づき、依存関係を外側から内側への一方向に設計。
ビジネスロジックをフレームワークから独立させ、テスタブルで保守性の高い構成を実現する。

```
┌─────────────────────────────────────┐
│            Presentation             │  ← UI層
│  ┌─────────────┐ ┌─────────────┐   │
│  │   Screen    │ │  ViewModel  │   │
│  └─────────────┘ └─────────────┘   │
└─────────────────�┬───────────────────┘
                  │
┌─────────────────┴───────────────────┐
│              Domain                 │  ← ビジネスロジック層
│  ┌─────────────┐ ┌─────────────┐   │
│  │   UseCase   │ │   Entity    │   │
│  └─────────────┘ └─────────────┘   │
│  ┌─────────────┐                   │
│  │ Repository  │ (interface)       │
│  └─────────────┘                   │
└─────────────────┬───────────────────┘
                  │
┌─────────────────┴───────────────────┐
│               Data                  │  ← データアクセス層
│  ┌─────────────┐ ┌─────────────┐   │
│  │ Repository  │ │ DataSource  │   │
│  │ (implement) │ │             │   │
│  └─────────────┘ └─────────────┘   │
└─────────────────────────────────────┘
```

## 📦 モジュール構成詳細

### 1. Presentation層

#### 1.1 Screen Module
**責務**: ユーザーインターフェースの表示制御

```kotlin
// GameScreen.kt
@Composable
fun GameScreen(
    viewModel: GameViewModel = hiltViewModel()
) {
    // UI実装
}
```

**主要コンポーネント**:
- `GameScreen`: メインゲーム画面
- `ResultDialog`: 結果表示ダイアログ

#### 1.2 Component Module
**責務**: 再利用可能UIコンポーネント

```kotlin
// NumberKeypad.kt
@Composable
fun NumberKeypad(
    onNumberClick: (Int) -> Unit,
    onDeleteClick: () -> Unit,
    onEnterClick: () -> Unit
)

// HintDisplay.kt
@Composable
fun HintDisplay(
    hint: HintMessage,
    animationState: AnimationState
)

// AchievementBadge.kt
@Composable
fun AchievementBadge(
    achievement: Achievement,
    showAnimation: Boolean
)
```

#### 1.3 ViewModel Module
**責務**: UIの状態管理とビジネスロジックとの仲介

```kotlin
// GameViewModel.kt
@HiltViewModel
class GameViewModel @Inject constructor(
    private val playGameUseCase: PlayGameUseCase,
    private val getHintUseCase: GetHintUseCase,
    private val calculateAchievementUseCase: CalculateAchievementUseCase
) : ViewModel() {
    
    private val _uiState = MutableStateFlow(GameUiState())
    val uiState: StateFlow<GameUiState> = _uiState.asStateFlow()
    
    fun submitGuess(number: Int)
    fun startNewGame()
    fun resetGame()
}

// GameUiState.kt
data class GameUiState(
    val inputNumber: String = "",
    val hint: HintMessage? = null,
    val attemptCount: Int = 0,
    val isGameFinished: Boolean = false,
    val achievement: Achievement? = null,
    val isLoading: Boolean = false
)
```

### 2. Domain層

#### 2.1 Entity Module
**責務**: ビジネスドメインのエンティティ定義

```kotlin
// Game.kt
data class Game(
    val targetNumber: Int,
    val currentGuess: Int? = null,
    val attemptCount: Int = 0,
    val isFinished: Boolean = false,
    val isWon: Boolean = false
) {
    fun makeGuess(guess: Int): Game {
        return copy(
            currentGuess = guess,
            attemptCount = attemptCount + 1,
            isFinished = guess == targetNumber,
            isWon = guess == targetNumber
        )
    }
}

// HintMessage.kt
data class HintMessage(
    val type: HintType,
    val message: String,
    val intensity: HintIntensity
)

enum class HintType { HIGHER, LOWER, CORRECT }
enum class HintIntensity { MILD, MODERATE, STRONG, VERY_CLOSE }

// Achievement.kt
data class Achievement(
    val title: String,
    val description: String,
    val emoji: String,
    val rank: AchievementRank
)

enum class AchievementRank { 
    LEGENDARY, GENIUS, GREAT, GOOD, NICE, KEEP_TRYING 
}
```

#### 2.2 UseCase Module
**責務**: ビジネスロジックの実装

```kotlin
// PlayGameUseCase.kt
class PlayGameUseCase @Inject constructor(
    private val gameRepository: GameRepository
) {
    suspend operator fun invoke(): Flow<Game> {
        return gameRepository.startNewGame()
    }
}

// SubmitGuessUseCase.kt
class SubmitGuessUseCase @Inject constructor(
    private val gameRepository: GameRepository
) {
    suspend operator fun invoke(
        game: Game, 
        guess: Int
    ): Result<Game> {
        return try {
            val updatedGame = game.makeGuess(guess)
            gameRepository.updateGame(updatedGame)
            Result.success(updatedGame)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}

// GetHintUseCase.kt
class GetHintUseCase @Inject constructor() {
    operator fun invoke(
        targetNumber: Int,
        guess: Int,
        attemptCount: Int
    ): HintMessage {
        val difference = kotlin.math.abs(targetNumber - guess)
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

// CalculateAchievementUseCase.kt
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
```

#### 2.3 Repository Interface Module
**責務**: データアクセスの抽象化

```kotlin
// GameRepository.kt
interface GameRepository {
    suspend fun startNewGame(): Flow<Game>
    suspend fun updateGame(game: Game): Game
    suspend fun getCurrentGame(): Game?
    suspend fun saveGameHistory(game: Game)
    suspend fun getGameHistory(): Flow<List<Game>>
}

// RandomNumberRepository.kt
interface RandomNumberRepository {
    fun generateNumber(min: Int = 1, max: Int = 100): Int
}
```

### 3. Data層

#### 3.1 Repository Implementation Module
**責務**: リポジトリインターフェースの具体実装

```kotlin
// GameRepositoryImpl.kt
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

// RandomNumberRepositoryImpl.kt
@Singleton
class RandomNumberRepositoryImpl @Inject constructor() : RandomNumberRepository {
    private val random = Random.Default
    
    override fun generateNumber(min: Int, max: Int): Int {
        return random.nextInt(min, max + 1)
    }
}
```

#### 3.2 DataSource Module
**責務**: 具体的なデータの永続化処理

```kotlin
// GameDataSource.kt
interface GameDataSource {
    suspend fun saveGame(game: Game)
    suspend fun getGameHistory(): Flow<List<Game>>
    suspend fun clearHistory()
}

// InMemoryGameDataSource.kt
@Singleton
class InMemoryGameDataSource @Inject constructor() : GameDataSource {
    private val gameHistory = mutableListOf<Game>()
    
    override suspend fun saveGame(game: Game) {
        gameHistory.add(game)
    }
    
    override suspend fun getGameHistory(): Flow<List<Game>> {
        return flowOf(gameHistory.toList())
    }
    
    override suspend fun clearHistory() {
        gameHistory.clear()
    }
}
```

## 🔧 依存性注入設定

```kotlin
// GameModule.kt
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
```

## 🎯 設計原則の遵守

### 1. 依存関係逆転の原則
- Domain層は具象に依存せず、抽象（interface）に依存
- Presentation層はDomain層の抽象に依存

### 2. 単一責任の原則
- 各クラス・モジュールは単一の責務を持つ
- UseCase は一つのビジネス機能のみを担当

### 3. オープン・クローズドの原則
- 新機能追加は拡張で対応、既存コード修正は最小限

### 4. インターフェース分離の原則
- 小さく特化したインターフェースを定義
- 不要な依存を強制しない

---

*設計書作成日: 2025年8月*
*アーキテクチャ: Clean Architecture*