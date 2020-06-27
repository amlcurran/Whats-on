package uk.co.amlcurran.social.add

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.widget.addTextChangedListener
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.observe
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
import io.reactivex.subjects.BehaviorSubject
import kotlinx.android.synthetic.main.add_event_fragment.*
import uk.co.amlcurran.social.R
import uk.co.amlcurran.social.inflate
import java.util.concurrent.TimeUnit

class AddEventFragment : Fragment() {

    private val disposable = CompositeDisposable()
    private val viewModel: AddEventViewModel by viewModels {
        ViewModelProvider.AndroidViewModelFactory.getInstance(requireActivity().application)
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return container?.inflate(R.layout.add_event_fragment, false)
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        add_select_place.create(savedInstanceState)
        val selectedPlace = BehaviorSubject.create<AutocompletePlace>()

        viewModel.placeSelectorState.observe(viewLifecycleOwner) {
            add_select_place.state = it
        }

        viewModel.bind(
            add_place_edit.textChanges(),
            selectedPlace
        )

        toolbar.setNavigationOnClickListener {
            requireActivity().finish()
        }

        add_select_place.onPlaceSelected = { autocompletePlace ->
            selectedPlace.onNext(autocompletePlace)
        }
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

    override fun onDestroyView() {
        super.onDestroyView()
        add_select_place?.destroy()
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        add_select_place.saveInstanceState(outState)
    }

    override fun onLowMemory() {
        super.onLowMemory()
        add_select_place.lowMemory()
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

fun <Result> Task<Result>.reactive(): Maybe<Result> {
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