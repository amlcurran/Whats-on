package uk.co.amlcurran.social.add

import android.app.TimePickerDialog
import android.os.Bundle
import android.widget.TimePicker
import android.text.format.DateFormat
import androidx.core.widget.addTextChangedListener
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.observe
import com.google.android.gms.tasks.Task
import com.google.android.material.textfield.TextInputEditText
import io.reactivex.Maybe
import io.reactivex.Observable
import io.reactivex.disposables.CompositeDisposable
import io.reactivex.disposables.Disposables
import io.reactivex.subjects.BehaviorSubject
import kotlinx.android.synthetic.main.add_event_fragment.*
import uk.co.amlcurran.social.R

class AddEventFragment : Fragment(R.layout.add_event_fragment) {

    private val disposable = CompositeDisposable()
    private val viewModel: AddEventViewModel by viewModels {
        ViewModelProvider.AndroidViewModelFactory.getInstance(requireActivity().application)
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

        event_input_begin_time_text.setOnClickListener {
            TimePickerDialog(requireContext(), TimePickerDialog.OnTimeSetListener { _: TimePicker, hour: Int, minute: Int ->

            }, 18, 0, DateFormat.is24HourFormat(requireActivity())).show()
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