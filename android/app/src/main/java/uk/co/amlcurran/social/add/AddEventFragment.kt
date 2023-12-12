package uk.co.amlcurran.social.add

import android.app.TimePickerDialog
import android.os.Bundle
import android.text.format.DateFormat
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TimePicker
import androidx.core.widget.addTextChangedListener
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.ViewModelProvider
import com.google.android.gms.tasks.Task
import com.google.android.material.textfield.TextInputEditText
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.suspendCancellableCoroutine
import uk.co.amlcurran.social.databinding.AddEventFragmentBinding
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException

class AddEventFragment : Fragment() {

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
        val selectedPlace = MutableSharedFlow<AutocompletePlace>()

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
            TimePickerDialog(requireContext(), { _: TimePicker, hour: Int, minute: Int ->

            }, 18, 0, DateFormat.is24HourFormat(requireActivity())).show()
        }
        binding.addSelectPlace.onPlaceSelected = { autocompletePlace ->
            selectedPlace.tryEmit(autocompletePlace)
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
        binding.addSelectPlace.destroy()
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
    }

}

private fun TextInputEditText.textChanges(): Flow<String> {
    return callbackFlow {
        val watcher = addTextChangedListener { text ->
            this.trySend(text.toString())
        }
        awaitClose {
            removeTextChangedListener(watcher)
        }
    }
}

suspend fun <Result> Task<Result>.suspend(): Result {
    return suspendCancellableCoroutine { continuation ->
        addOnCanceledListener {
            continuation.cancel(CancellationException())
        }
        addOnSuccessListener {
            continuation.resume(it)
        }
        addOnFailureListener {
            continuation.resumeWithException(it)
        }
    }
}