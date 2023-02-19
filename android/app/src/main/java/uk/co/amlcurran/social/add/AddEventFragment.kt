package uk.co.amlcurran.social.add

import android.app.TimePickerDialog
import android.os.Bundle
import android.widget.TimePicker
import android.text.format.DateFormat
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
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
import uk.co.amlcurran.social.R
import uk.co.amlcurran.social.databinding.AddEventFragmentBinding
import uk.co.amlcurran.social.databinding.SettingsBinding

class AddEventFragment : Fragment() {

    private val disposable = CompositeDisposable()
    private val viewModel: AddEventViewModel by viewModels {
        ViewModelProvider.AndroidViewModelFactory.getInstance(requireActivity().application)
    }
    private lateinit var binding: AddEventFragmentBinding

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        binding = AddEventFragmentBinding.inflate(inflater, container, false)
        return binding.root
    }

    @Deprecated("Deprecated in Java")
    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        binding.addSelectPlace.create(savedInstanceState)
        val selectedPlace = BehaviorSubject.create<AutocompletePlace>()

        viewModel.placeSelectorState.observe(viewLifecycleOwner) {
            binding.addSelectPlace.state = it
        }

        viewModel.bind(
            binding.addPlaceEdit.textChanges(),
            selectedPlace
        )

        binding.toolbar.setNavigationOnClickListener {
            requireActivity().finish()
        }

        binding.eventInputBeginTime.setOnClickListener {
            TimePickerDialog(requireContext(), TimePickerDialog.OnTimeSetListener { _: TimePicker, hour: Int, minute: Int ->

            }, 18, 0, DateFormat.is24HourFormat(requireActivity())).show()
        }
        binding.addSelectPlace.onPlaceSelected = { autocompletePlace ->
            selectedPlace.onNext(autocompletePlace)
        }
    }

    override fun onStart() {
        super.onStart()
        binding.addSelectPlace.start()
    }

    override fun onResume() {
        super.onResume()
        binding.addSelectPlace.resume()
    }

    override fun onPause() {
        super.onPause()
        binding.addSelectPlace.pause()
    }

    override fun onStop() {
        super.onStop()
        binding.addSelectPlace.stop()
    }

    override fun onDestroyView() {
        super.onDestroyView()
        binding.addSelectPlace?.destroy()
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        binding.addSelectPlace.saveInstanceState(outState)
    }

    override fun onLowMemory() {
        super.onLowMemory()
        binding.addSelectPlace.lowMemory()
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