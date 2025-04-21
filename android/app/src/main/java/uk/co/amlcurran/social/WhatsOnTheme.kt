package uk.co.amlcurran.social

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Typography
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.res.colorResource
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp

val openSans = FontFamily(
    listOf(
        Font(R.font.opensansreg),
        Font(R.font.opensansbold, FontWeight.Bold),
        Font(R.font.opensanssemi, FontWeight.SemiBold)
    )
)

val afacad = FontFamily(
    listOf(
        Font(R.font.afacad_regular),
        Font(R.font.afacad_bold, FontWeight.Bold),
        Font(R.font.afacad_semibold, FontWeight.SemiBold)
    )
)

@Composable
fun WhatsOnTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        typography = Typography(
            bodySmall = Typography().bodySmall.copy(
                fontFamily = afacad,
                fontSize = 18.sp
            ),
            bodyMedium = Typography().bodyMedium.copy(
                fontFamily = afacad,
                fontSize = 18.sp
            ),
            bodyLarge = Typography().bodyLarge.copy(
                fontFamily = afacad,
            ),
            titleLarge = Typography().titleLarge.copy(
                fontFamily = afacad
            ),
            titleMedium = Typography().titleMedium.copy(
                fontFamily = afacad,
                fontWeight = FontWeight.Bold,
                fontSize = 36.sp
            ),
            titleSmall = Typography().titleSmall.copy(
                fontFamily = afacad,
            ),
            displayLarge = Typography().displayLarge.copy(
                fontFamily = afacad,
            ),
            displayMedium = Typography().displayMedium.copy(
                fontFamily = afacad,
            ),
            displaySmall = Typography().displaySmall.copy(
                fontFamily = afacad,
            ),
        ),
        colorScheme = if (isSystemInDarkTheme()) darkColorScheme(
            primary = colorResource(id = R.color.colorPrimary),
            secondary = colorResource(id = R.color.colorSecondary),
            surface = colorResource(id = R.color.colorSurface),
            background = colorResource(id = R.color.background),
            onBackground = colorResource(id = R.color.colorOnBackground),
            onSurface = colorResource(id = R.color.colorOnSurface)
        ) else lightColorScheme(
            primary = colorResource(id = R.color.colorPrimary),
            secondary = colorResource(id = R.color.colorOnBackground),
            surface = colorResource(id = R.color.colorSurface),
            background = colorResource(id = R.color.background),
            onBackground = colorResource(id = R.color.colorOnBackground),
            onSurface = colorResource(id = R.color.colorOnSurface)
        ),
        content = content
    )
}