package uk.co.amlcurran.social

import android.content.res.Configuration.UI_MODE_NIGHT_YES
import android.text.format.DateFormat
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import java.util.Date
import java.util.Locale

@Composable
fun HeaderView(modifier: Modifier = Modifier) {
    Column(
        modifier = modifier
            .background(MaterialTheme.colorScheme.background)
            .padding(16.dp)
            .fillMaxWidth()
    ) {
        Text(
            text = DateFormat.getMediumDateFormat(LocalContext.current).format(Date())
                .uppercase(Locale.getDefault()),
            style = MaterialTheme.typography.bodyLarge.copy(
                fontWeight = FontWeight.SemiBold
            ),
            color = MaterialTheme.colorScheme.primary
        )
        Text(
            text = "What's on",
            style = MaterialTheme.typography.titleMedium,
            color = MaterialTheme.colorScheme.onBackground
        )
    }
}

@Preview
@Composable
fun HeaderViewPreview() {
    WhatsOnTheme {
        HeaderView()
    }
}

@Preview(uiMode = UI_MODE_NIGHT_YES)
@Composable
fun HeaderViewPreviewDark() {
    WhatsOnTheme {
        HeaderView()
    }
}
