package uk.co.amlcurran.starlinginterview

import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.map

fun <T> asyncAction(action: suspend () -> T): Flow<AsyncResult<T>> {
    return flow {
        emit(AsyncResult.Loading())
        try {
            emit(AsyncResult.Success(action()))
        } catch (throwable: Throwable) {
            emit(AsyncResult.Error(throwable))
        }

    }
}

fun <T> asyncActionFromResult(action: suspend () -> Result<T>): Flow<AsyncResult<T>> {
    return flow {
        emit(AsyncResult.Loading())
        try {
            val result = action()
                .fold(
                    onSuccess = { successOf(it) },
                    onFailure = { failureWith(it) }
                )
            emit(result)
        } catch (throwable: Throwable) {
            emit(AsyncResult.Error(throwable))
        }

    }
}