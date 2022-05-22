package uk.co.amlcurran.social

import android.content.res.Configuration.UI_MODE_NIGHT_YES
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.*
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material.icons.rounded.MoreVert
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.colorResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
fun HeaderView() {
    MaterialTheme(
        if (isSystemInDarkTheme()) darkColors(
            primary = colorResource(id = R.color.colorPrimary),
            secondary = colorResource(id = R.color.colorOnBackground)
        ) else lightColors(
            primary = colorResource(id = R.color.colorPrimary),
            secondary = colorResource(id = R.color.colorOnBackground)
        )
    ) {
        Column(modifier = Modifier
            .background(MaterialTheme.colors.background)
            .padding(8.dp)) {
            Row {
                Column {
                    Text(text = "Foodle", color = MaterialTheme.colors.primary, fontSize = 14.sp, fontWeight = FontWeight.SemiBold)
                    Text(text = "What's on", color = MaterialTheme.colors.secondary, fontWeight = FontWeight.Black, letterSpacing = 0.sp, fontSize = 32.sp)
                }
                Spacer(modifier = Modifier.width(16.dp))
                Icon(Icons.Default.MoreVert, contentDescription = "More", tint = MaterialTheme.colors.onBackground)
            }
        }
    }
}

@Preview
@Composable
fun HeaderViewPreview() {
    HeaderView()
}

@Preview(uiMode = UI_MODE_NIGHT_YES)
@Composable
fun HeaderViewPreviewDark() {
    HeaderView()
}
