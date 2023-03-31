package uk.co.amlcurran.social

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.graphics.PathEffect
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.colorResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp

@Composable
fun EmptyView(modifier: Modifier = Modifier) {
    val color = colorResource(id = R.color.empty_color)
    val density = LocalContext.current.resources.displayMetrics.density
    Box(
        modifier
            .drawBehind {
                drawRoundRect(
                    color = color,
                    style = Stroke(
                        density * 2f,
                        pathEffect = PathEffect.dashPathEffect(
                            floatArrayOf(
                                8f * density,
                                4f * density
                            )
                        )
                    ),
                    cornerRadius = CornerRadius(x = density * 8f, y = density * 8f)
                )
            }
            .padding(16.dp)
    ) {
        Text(
            "Nothing on",
            modifier = Modifier
                .padding(),
            style = MaterialTheme.typography.body1,
            color = colorResource(id = R.color.empty_color)
        )
    }
}

@Preview
@Composable
fun EmptyViewPreview() {
    EmptyView(Modifier.fillMaxWidth())
}
