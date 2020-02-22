package uk.co.amlcurran.social.add

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.widget.addTextChangedListener
import androidx.fragment.app.Fragment
import com.google.android.gms.tasks.Task
import com.google.android.libraries.places.api.Places
import com.google.android.libraries.places.api.model.AutocompleteSessionToken
import com.google.android.libraries.places.api.model.Place
import com.google.android.libraries.places.api.net.FetchPlaceRequest
import com.google.android.libraries.places.api.net.FindAutocompletePredictionsRequest
import com.google.android.libraries.places.api.net.PlacesClient
import com.google.android.material.textfield.TextInputEditText
import io.reactivex.Maybe
import io.reactivex.Observable
import io.reactivex.Single
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.CompositeDisposable
import io.reactivex.disposables.Disposables
import io.reactivex.rxkotlin.addTo
import io.reactivex.rxkotlin.subscribeBy
import io.reactivex.schedulers.Schedulers
import kotlinx.android.synthetic.main.add_event_fragment.*
import uk.co.amlcurran.social.R
import uk.co.amlcurran.social.inflate
import java.util.concurrent.TimeUnit

class AddEventFragment : Fragment() {

    private val disposable = CompositeDisposable()
    private val placesClient: PlacesClient by lazy {
        if (!Places.isInitialized()) {
            Places.initialize(requireContext(), getString(R.string.maps_api_key))
        }
        Places.createClient(requireContext())
    }
    private val token: AutocompleteSessionToken by lazy {
        AutocompleteSessionToken.newInstance()
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return container?.inflate(R.layout.add_event_fragment, false)
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        add_select_place.create(savedInstanceState)

        add_place_edit.textChanges()
            .debounce(100, TimeUnit.MILLISECONDS)
            .subscribeOn(Schedulers.io())
            .filter { it.length > 3 }
            .flatMapSingle { geocode(it) }
            .startWith(PlaceSelectorState.Initial)
            .observeOn(AndroidSchedulers.mainThread())
            .subscribeBy(
                onNext = { add_select_place.state = it },
                onError = { Log.w("Foo", it) }
            )
            .addTo(disposable)

        add_select_place.onPlaceSelected = { autocompletePlace ->
            val fields = listOf(Place.Field.LAT_LNG, Place.Field.ID, Place.Field.NAME)
            placesClient.fetchPlace(FetchPlaceRequest.builder(autocompletePlace.id, fields)
                .setSessionToken(token)
                .build())
                .reactive()
                .subscribeOn(Schedulers.io())
                .map { Place(it.place.id!!, it.place.name!!, it.place.latLng!!) }
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeBy(
                    onSuccess = { add_select_place.state = PlaceSelectorState.SelectedPlace(it) },
                    onError = { Log.w("Error", it) }
                )
                .addTo(disposable)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onStart() {
        super.onStart()
        add_select_place.start()
    }

    override fun onResume() {
        super.onResume()
        add_select_place.resume()
    }

    override fun onPause() {
        super.onPause()
        add_select_place.pause()
    }

    override fun onStop() {
        super.onStop()
        add_select_place.stop()
    }

    override fun onDestroy() {
        super.onDestroy()
        add_select_place.destroy()
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        add_select_place.saveInstanceState(outState)
    }

    override fun onLowMemory() {
        super.onLowMemory()
        add_select_place.lowMemory()
    }

    fun geocode(string: String): Single<PlaceSelectorState> {
        return Single.just(string)
            .map { buildRequest(it) }
            .flatMapMaybe { placesClient.findAutocompletePredictions(it).reactive() }
            .map {
                it.autocompletePredictions.map { prediction ->
                    AutocompletePlace(prediction.placeId, prediction.getPrimaryText(null))
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

    override fun onDetach() {
        super.onDetach()
        disposable.clear()
    }

}

private fun TextInputEditText.textChanges(): Observable<String> {
    return Observable.create<String> { emitter ->
        val watcher = addTextChangedListener { text ->
            emitter.onNext(text.toString())
        }
        Disposables.fromAction {
            removeTextChangedListener(watcher)
        }
    }
}

private fun <Result> Task<Result>.reactive(): Maybe<Result> {
    return Maybe.create<Result> { emitter ->
        addOnCanceledListener {
            emitter.onComplete()
        }
        addOnSuccessListener {
            emitter.onSuccess(it)
        }
        addOnFailureListener {
            emitter.onError(it)
        }
        Disposables.empty()
    }
}