package uk.co.amlcurran.social.add

import android.app.Application
import android.util.Log
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.google.android.libraries.places.api.Places
import com.google.android.libraries.places.api.model.AutocompleteSessionToken
import com.google.android.libraries.places.api.model.Place.Field
import com.google.android.libraries.places.api.net.FetchPlaceRequest
import com.google.android.libraries.places.api.net.FetchPlaceResponse
import com.google.android.libraries.places.api.net.FindAutocompletePredictionsRequest
import com.google.android.libraries.places.api.net.PlacesClient
import io.reactivex.Maybe
import io.reactivex.Observable
import io.reactivex.Single
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.CompositeDisposable
import io.reactivex.rxkotlin.addTo
import io.reactivex.rxkotlin.subscribeBy
import io.reactivex.schedulers.Schedulers
import uk.co.amlcurran.social.R
import java.util.concurrent.TimeUnit

class AddEventViewModel(application: Application): AndroidViewModel(application) {

    private val _placeSelectorState = MutableLiveData<PlaceSelectorState>()
    val placeSelectorState: LiveData<PlaceSelectorState> = _placeSelectorState

    private val disposables = CompositeDisposable()
    private val placesClient: PlacesClient by lazy {
        if (!Places.isInitialized()) {
            Places.initialize(application, application.getString(R.string.maps_api_key))
        }
        Places.createClient(application)
    }
    private val token: AutocompleteSessionToken by lazy {
        AutocompleteSessionToken.newInstance()
    }

    fun bind(textChanges: Observable<String>, selectedPlace: Observable<AutocompletePlace>) {
        textChanges.debounce(100, TimeUnit.MILLISECONDS)
            .subscribeOn(Schedulers.io())
            .doOnSubscribe { _placeSelectorState.postValue(PlaceSelectorState.Initial) }
            .filter { it.length > 3 }
            .observeOn(AndroidSchedulers.mainThread())
            .doOnNext { _placeSelectorState.postValue(PlaceSelectorState.Loading) }
            .observeOn(Schedulers.io())
            .switchMapSingle { geocode(it) }
            .subscribeBy(
                onNext = { _placeSelectorState.postValue(it) },
                onError = { Log.w("Foo", it) }
            )
            .addTo(disposables)

        selectedPlace
            .flatMapMaybe { lookupPlace(it) }
            .subscribeOn(Schedulers.io())
            .map { Place(it.place.id!!, it.place.name!!, it.place.latLng!!) }
            .observeOn(AndroidSchedulers.mainThread())
            .subscribeBy(
                onNext = { _placeSelectorState.postValue(PlaceSelectorState.SelectedPlace(it)) },
                onError = { Log.w("Error", it) }
            )
            .addTo(disposables)
    }

    private fun lookupPlace(place: AutocompletePlace): Maybe<FetchPlaceResponse> {
        val fields = listOf(Field.LAT_LNG, Field.ID, Field.NAME)
        val placeRequest = FetchPlaceRequest.builder(place.id, fields)
            .setSessionToken(token)
            .build()
        return placesClient.fetchPlace(placeRequest)
        .reactive()
    }

    fun geocode(string: String): Single<PlaceSelectorState> {
        return Single.just(string)
            .map { buildRequest(it) }
            .flatMapMaybe { placesClient.findAutocompletePredictions(it).reactive() }
            .map {
                it.autocompletePredictions.map { prediction ->
                    AutocompletePlace(prediction.placeId, prediction.getPrimaryText(null), prediction.getSecondaryText(null))
                }
            }
            .toSingle(emptyList())
            .map { PlaceSelectorState.PlaceList(it) }

    }

    private fun buildRequest(it: String): FindAutocompletePredictionsRequest {
        return FindAutocompletePredictionsRequest.builder()
            .setQuery(it)
            .setSessionToken(token)
            .build()
    }

    override fun onCleared() {
        super.onCleared()
        disposables.clear()
    }

}