package uk.co.amlcurran.starlinginterview

suspend fun <T> catching(action: suspend () -> T): Result<T> {
    return try {
        Result.success(action())
    } catch (throwable: Throwable) {
        Result.failure(throwable)
    }
}