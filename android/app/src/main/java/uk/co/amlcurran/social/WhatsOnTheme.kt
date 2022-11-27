package uk.co.amlcurran.social

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Typography
import androidx.compose.material.darkColors
import androidx.compose.material.lightColors
import androidx.compose.runtime.Composable
import androidx.compose.ui.res.colorResource
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight

val openSans = FontFamily(
    listOf(
        Font(R.font.opensansreg),
        Font(R.font.opensansbold, FontWeight.Bold),
        Font(R.font.opensanssemi, FontWeight.SemiBold)
    )
)

@Composable
fun WhatsOnTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        typography = Typography(
            FontFamily(
                Font(R.font.opensanssemi, FontWeight.SemiBold),
                Font(R.font.opensansbold, FontWeight.Bold),
                Font(R.font.opensansreg, FontWeight.Medium),
            ),
            body1 = Typography().body1.copy(
                fontFamily = openSans,
                fontWeight = FontWeight.SemiBold
            ),
            h4 = Typography().h4.copy(fontFamily = openSans, fontWeight = FontWeight.Bold)
        ),
        colors = if (isSystemInDarkTheme()) darkColors(
            primary = colorResource(id = R.color.colorPrimary),
            secondary = colorResource(id = R.color.colorOnBackground)
        ) else lightColors(
            primary = colorResource(id = R.color.colorPrimary),
            secondary = colorResource(id = R.color.colorOnBackground)
        ),
        content = content
    )
}