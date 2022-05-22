package uk.co.amlcurran.social.add

import android.content.Context
import android.os.Bundle
import android.util.AttributeSet
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.MarkerOptions
import uk.co.amlcurran.social.R
import uk.co.amlcurran.social.databinding.ItemPlaceBinding
import uk.co.amlcurran.social.databinding.PlaceSelectorBinding
import uk.co.amlcurran.social.details.alphaIn
import uk.co.amlcurran.social.details.alphaOut
import uk.co.amlcurran.social.inflate
import kotlin.properties.Delegates

data class AutocompletePlace(val id: String, val name: CharSequence, val secondLine: CharSequence)

data class Place(val id: String, val name: CharSequence, val latLng: LatLng)

private class ViewHolder(val binding: ItemPlaceBinding) : RecyclerView.ViewHolder(binding.root)

private class ListAdapter : RecyclerView.Adapter<ViewHolder>() {

    var onPlaceSelected: (AutocompletePlace) -> Unit = { _ -> }
    var autocompletePlaces: List<AutocompletePlace> by Delegates.observable(initialValue = emptyList()) { _, _, _ ->
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        return ViewHolder(ItemPlaceBinding.inflate(LayoutInflater.from(parent.context), parent, false))
    }

    override fun getItemCount(): Int = autocompletePlaces.size

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.binding.placeName.text = autocompletePlaces[position].name
        holder.binding.placeDescription.text = autocompletePlaces[position].secondLine
        holder.itemView.setOnClickListener {
            onPlaceSelected(autocompletePlaces[position])
        }
    }

}

class PlaceSelectorView @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null, defStyleAttr: Int = 0
) : FrameLayout(context, attrs, defStyleAttr) {

    val binding: PlaceSelectorBinding
    private val placesAdapter: ListAdapter by lazy { ListAdapter() }
    var onPlaceSelected: (AutocompletePlace) -> Unit by Delegates.observable(initialValue = { _ -> }) { _, _, new ->
        placesAdapter.onPlaceSelected = onPlaceSelected
    }

    init {
        binding = PlaceSelectorBinding.inflate(LayoutInflater.from(context), this)
        LayoutInflater.from(context).inflate(R.layout.place_selector, this)
        binding.placeSelectorList.adapter = placesAdapter
        binding.placeSelectorList.layoutManager = LinearLayoutManager(context, LinearLayoutManager.VERTICAL, false)
    }

    var state: PlaceSelectorState by Delegates.observable<PlaceSelectorState>(initialValue = PlaceSelectorState.Initial) { _, _, newValue ->
        when (newValue) {
            is PlaceSelectorState.Loading -> goLoading()
            is PlaceSelectorState.SelectedPlace -> displayMap(newValue.autocompletePlace.latLng)
            is PlaceSelectorState.PlaceList -> showList(newValue.autocompletePlaces)
            is PlaceSelectorState.Initial -> hideAll()
        }
    }

    private fun hideAll() {
        binding.placeSelectorLoader.visibility = View.GONE
        binding.placeSelectorList.visibility = View.GONE
        binding.placeSelectorMap.visibility = View.GONE
    }

    private fun showList(autocompletePlaces: List<AutocompletePlace>) {
        binding.placeSelectorLoader.alphaOut()
        binding.placeSelectorMap.alphaOut()
        placesAdapter.autocompletePlaces = autocompletePlaces
        binding.placeSelectorList.alphaIn(translate = true)
    }

    private fun displayMap(latLng: LatLng) {
        binding.placeSelectorLoader.alphaOut()
        binding.placeSelectorList.alphaOut()
        binding.placeSelectorMap.getMapAsync {
            it.clear()
            it.uiSettings.setAllGesturesEnabled(false)
            it.addMarker(MarkerOptions().position(latLng))
            it.moveCamera(CameraUpdateFactory.newLatLngZoom(latLng, 13f))
        }
        binding.placeSelectorMap.alphaIn(translate = true)
    }

    private fun goLoading() {
        binding.placeSelectorList.alphaOut()
        binding.placeSelectorMap.alphaOut()
        binding.placeSelectorLoader.alphaIn()
    }

    fun create(savedInstanceState: Bundle?) = binding.placeSelectorMap.onCreate(savedInstanceState)

    fun start() = binding.placeSelectorMap.onStart()

    fun resume() = binding.placeSelectorMap.onResume()

    fun pause() = binding.placeSelectorMap.onPause()

    fun stop() = binding.placeSelectorMap.onStop()

    fun destroy() = binding.placeSelectorMap.onDestroy()

    fun saveInstanceState(bundle: Bundle) = binding.placeSelectorMap.onSaveInstanceState(bundle)

    fun lowMemory() = binding.placeSelectorMap.onLowMemory()

}

sealed class PlaceSelectorState {
    data class PlaceList(val autocompletePlaces: List<AutocompletePlace>) : PlaceSelectorState()
    data class SelectedPlace(val autocompletePlace: Place) : PlaceSelectorState()
    object Loading : PlaceSelectorState()
    object Initial : PlaceSelectorState()
}