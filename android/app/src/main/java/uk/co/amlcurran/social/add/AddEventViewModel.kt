package uk.co.amlcurran.social.add

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import com.google.android.libraries.places.api.Places
import com.google.android.libraries.places.api.model.AutocompleteSessionToken
import com.google.android.libraries.places.api.model.Place.Field
import com.google.android.libraries.places.api.net.FetchPlaceRequest
import com.google.android.libraries.places.api.net.FetchPlaceResponse
import com.google.android.libraries.places.api.net.FindAutocompletePredictionsRequest
import com.google.android.libraries.places.api.net.PlacesClient
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.flow.debounce
import kotlinx.coroutines.flow.filter
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.flow.onStart
import kotlinx.coroutines.launch
import uk.co.amlcurran.social.R
import kotlin.time.DurationUnit
import kotlin.time.toDuration

class AddEventViewModel(application: Application): AndroidViewModel(application) {

    private val _placeSelectorState = MutableLiveData<PlaceSelectorState>()
    val placeSelectorState: LiveData<PlaceSelectorState> = _placeSelectorState

    private val placesClient: PlacesClient by lazy {
        if (!Places.isInitialized()) {
            Places.initialize(application, application.getString(R.string.maps_api_key))
        }
        Places.createClient(application)
    }
    private val token: AutocompleteSessionToken by lazy {
        AutocompleteSessionToken.newInstance()
    }

    @OptIn(FlowPreview::class)
    fun bind(textChanges: Flow<String>, selectedPlace: Flow<AutocompletePlace>) {
        viewModelScope.launch {
            textChanges.debounce(100.toDuration(DurationUnit.MILLISECONDS))
                .onStart { _placeSelectorState.postValue(PlaceSelectorState.Initial) }
                .filter { it.length > 3 }
                .onEach { _placeSelectorState.postValue(PlaceSelectorState.Loading) }
                .map { geocode(it) }
                .collectLatest {
                    _placeSelectorState.postValue(it)
                }
        }

        viewModelScope.launch {
            selectedPlace
                .map { lookupPlace(it) }
                .map { Place(it.place.id!!, it.place.name!!, it.place.latLng!!) }
                .collectLatest { _placeSelectorState.postValue(PlaceSelectorState.SelectedPlace(it)) }
        }
    }

    private suspend fun lookupPlace(place: AutocompletePlace): FetchPlaceResponse {
        val fields = listOf(Field.LAT_LNG, Field.ID, Field.NAME)
        val placeRequest = FetchPlaceRequest.builder(place.id, fields)
            .setSessionToken(token)
            .build()
        return placesClient.fetchPlace(placeRequest)
            .suspend()
    }

    suspend fun geocode(string: String): PlaceSelectorState {
        val predictions = placesClient.findAutocompletePredictions(buildRequest(string)).suspend()
        val places = predictions.autocompletePredictions.map { prediction ->
            AutocompletePlace(
                prediction.placeId,
                prediction.getPrimaryText(null),
                prediction.getSecondaryText(null)
            )
        }
        return PlaceSelectorState.PlaceList(places)
    }

    private fun buildRequest(it: String): FindAutocompletePredictionsRequest {
        return FindAutocompletePredictionsRequest.builder()
            .setQuery(it)
            .setSessionToken(token)
            .build()
    }

    override fun onCleared() {
        super.onCleared()
    }

}