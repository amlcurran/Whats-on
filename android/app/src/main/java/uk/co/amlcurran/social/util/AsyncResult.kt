package uk.co.amlcurran.starlinginterview

import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

sealed class AsyncResult<T> {
    data class Success<T>(val data: T): AsyncResult<T>()
    data class Loading<T>(val foo: Unit = Unit): AsyncResult<T>()
    data class Error<T>(val error: Throwable): AsyncResult<T>()

    val result: T? get() = when (this) {
        is Success -> this.data
        is Loading -> null
        is Error -> null
    }

}

fun <T> failureWith(error: Throwable): AsyncResult<T> {
    return AsyncResult.Error(error)
}

fun <T> successOf(data: T): AsyncResult<T> {
    return AsyncResult.Success(data)
}

fun <T, U> Flow<AsyncResult<T>>.mapSuccess(action: (T) -> U): Flow<AsyncResult<U>> {
    return map {
        when (it) {
            is AsyncResult.Error -> AsyncResult.Error(it.error)
            is AsyncResult.Loading -> AsyncResult.Loading()
            is AsyncResult.Success -> AsyncResult.Success(action(it.data))
        }
    }
}