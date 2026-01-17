package uk.co.amlcurran.social.details

import android.content.Context
import android.content.Intent
import android.location.Address
import android.location.Geocoder
import android.util.Log
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.core.net.toUri
import com.google.android.gms.maps.model.CameraPosition
import com.google.android.gms.maps.model.LatLng
import com.google.maps.android.compose.CameraPositionState
import com.google.maps.android.compose.GoogleMap
import com.google.maps.android.compose.MapUiSettings
import com.google.maps.android.compose.Marker
import com.google.maps.android.compose.MarkerState
import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.supervisorScope
import uk.co.amlcurran.social.Event
import kotlin.coroutines.suspendCoroutine

private suspend fun findLocation(context: Context, location: String): LatLng? {
    return suspendCoroutine { continuation ->
        try {
            Geocoder(context).getFromLocationName(location, 10, object : Geocoder.GeocodeListener {
                override fun onGeocode(addresses: List<Address?>) {
                    val latLng = addresses.firstOrNull()?.let { LatLng(it.latitude, it.longitude) }
                    continuation.resumeWith(Result.success(latLng))
                }
            })
        } catch (e: Exception) {
            continuation.resumeWith(Result.failure(e))
        }
    }
}

private val handler = CoroutineExceptionHandler { _, e ->
    Log.e("Caught", e.toString())
}

@Composable
fun EventMap(modifier: Modifier = Modifier, event: Event) {
    val (location, setLocation) = remember { mutableStateOf<LatLng?>(null) }
    val context = LocalContext.current
    LaunchedEffect(event.location) {
        delay(300)
        event.location?.let {
            supervisorScope {
                launch(handler) {
                    if (it.isNotBlank()) {
                        findLocation(context, it)?.let {
                            setLocation(it)
                        }
                    }
                }
            }
        }
    }
    if (location != null) {
        GoogleMap(
            modifier = modifier
                .height(200.dp)
                .clip(
                    RoundedCornerShape(
                        topStart = 0.dp,
                        topEnd = 0.dp,
                        bottomStart = 8.dp,
                        bottomEnd = 8.dp
                    )
                ),
            onMapClick = {
                context.startActivity(Intent(Intent.ACTION_VIEW).apply {
                    data =
                        "https://www.google.com/maps/dir/?api=1&destination=${location.latitude},${location.longitude}".toUri()
                })
            },
            uiSettings = MapUiSettings(
                zoomControlsEnabled = false,
                rotationGesturesEnabled = false,
                scrollGesturesEnabled = false,
                tiltGesturesEnabled = false,
                zoomGesturesEnabled = false
            ),
            cameraPositionState = CameraPositionState(
                CameraPosition.fromLatLngZoom(
                    location,
                    15f
                )
            )
        ) {
            Marker(state = MarkerState(position = location))
        }
    }
}