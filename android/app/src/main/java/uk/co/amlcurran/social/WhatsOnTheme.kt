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
            afacad,
            body1 = Typography().body1.copy(
                fontFamily = afacad,
            ),
            h4 = Typography().h4.copy(
                fontFamily = afacad,
                fontWeight = FontWeight.Bold
            ),
            subtitle2 = Typography().subtitle2.copy(
                fontFamily = afacad
            )
        ),
        colors = if (isSystemInDarkTheme()) darkColors(
            primary = colorResource(id = R.color.colorPrimary),
            secondary = colorResource(id = R.color.colorSecondary),
            surface = colorResource(id = R.color.colorSurface),
            background = colorResource(id = R.color.background),
            onBackground = colorResource(id = R.color.colorOnBackground),
            onSurface = colorResource(id = R.color.colorOnSurface)
        ) else lightColors(
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