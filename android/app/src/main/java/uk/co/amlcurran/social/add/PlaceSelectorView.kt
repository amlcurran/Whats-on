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
import kotlinx.android.synthetic.main.item_place.view.*
import kotlinx.android.synthetic.main.place_selector.view.*
import uk.co.amlcurran.social.R
import uk.co.amlcurran.social.details.alphaIn
import uk.co.amlcurran.social.details.alphaOut
import uk.co.amlcurran.social.inflate
import kotlin.properties.Delegates

data class AutocompletePlace(val id: String, val name: CharSequence, val secondLine: CharSequence)

data class Place(val id: String, val name: CharSequence, val latLng: LatLng)

private class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

}

private class ListAdapter : RecyclerView.Adapter<ViewHolder>() {

    var onPlaceSelected: (AutocompletePlace) -> Unit = { _ -> }
    var autocompletePlaces: List<AutocompletePlace> by Delegates.observable(initialValue = emptyList()) { _, _, _ ->
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        return ViewHolder(parent.inflate(R.layout.item_place, false))
    }

    override fun getItemCount(): Int = autocompletePlaces.size

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.itemView.place_name.text = autocompletePlaces[position].name
        holder.itemView.place_description.text = autocompletePlaces[position].secondLine
        holder.itemView.setOnClickListener {
            onPlaceSelected(autocompletePlaces[position])
        }
    }

}

class PlaceSelectorView @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null, defStyleAttr: Int = 0
) : FrameLayout(context, attrs, defStyleAttr) {

    private val placesAdapter: ListAdapter by lazy { ListAdapter() }
    var onPlaceSelected: (AutocompletePlace) -> Unit by Delegates.observable(initialValue = { _ -> }) { _, _, new ->
        placesAdapter.onPlaceSelected = onPlaceSelected
    }

    init {
        LayoutInflater.from(context).inflate(R.layout.place_selector, this)
        place_selector_list.adapter = placesAdapter
        place_selector_list.layoutManager = LinearLayoutManager(context, LinearLayoutManager.VERTICAL, false)
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
        place_selector_loader.visibility = View.GONE
        place_selector_list.visibility = View.GONE
        place_selector_map.visibility = View.GONE
    }

    private fun showList(autocompletePlaces: List<AutocompletePlace>) {
        place_selector_loader.alphaOut()
        place_selector_map.alphaOut()
        placesAdapter.autocompletePlaces = autocompletePlaces
        place_selector_list.alphaIn(translate = true)
    }

    private fun displayMap(latLng: LatLng) {
        place_selector_loader.alphaOut()
        place_selector_list.alphaOut()
        place_selector_map.getMapAsync {
            it.clear()
            it.uiSettings.setAllGesturesEnabled(false)
            it.addMarker(MarkerOptions().position(latLng))
            it.moveCamera(CameraUpdateFactory.newLatLngZoom(latLng, 13f))
        }
        place_selector_map.alphaIn(translate = true)
    }

    private fun goLoading() {
        place_selector_list.alphaOut()
        place_selector_map.alphaOut()
        place_selector_loader.alphaIn()
    }

    fun create(savedInstanceState: Bundle?) = place_selector_map.onCreate(savedInstanceState)

    fun start() = place_selector_map.onStart()

    fun resume() = place_selector_map.onResume()

    fun pause() = place_selector_map.onPause()

    fun stop() = place_selector_map.onStop()

    fun destroy() = place_selector_map.onDestroy()

    fun saveInstanceState(bundle: Bundle) = place_selector_map.onSaveInstanceState(bundle)

    fun lowMemory() = place_selector_map.onLowMemory()

}

sealed class PlaceSelectorState {
    data class PlaceList(val autocompletePlaces: List<AutocompletePlace>) : PlaceSelectorState()
    data class SelectedPlace(val autocompletePlace: Place) : PlaceSelectorState()
    object Loading : PlaceSelectorState()
    object Initial : PlaceSelectorState()
}