package uk.co.amlcurran.starlinginterview

import androidx.compose.animation.Crossfade
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier

@Composable
fun <T> AsyncContent(
    state: AsyncResult<T>,
    modifier: Modifier = Modifier,
    content: @Composable (T) -> Unit
) {
    Crossfade(
        targetState = state, modifier = modifier
    ) { subscriptions ->
        when (subscriptions) {
            is AsyncResult.Error -> {
                Column {
                    Text(
                        text = "Oh no! Something went wrong",
                        style = MaterialTheme.typography.bodyLarge)
                    Text(
                        text = subscriptions.error.localizedMessage ?: "No more information about this error",
                        style = MaterialTheme.typography.bodySmall
                    )
                }
            }
            is AsyncResult.Loading -> {
                Box(contentAlignment = Alignment.Center, modifier = Modifier.fillMaxSize()) {
                    CircularProgressIndicator()
                }
            }
            is AsyncResult.Success ->
                content(subscriptions.data)
        }
    }
}