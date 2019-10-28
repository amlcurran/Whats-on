package uk.co.amlcurran.social

import android.view.ViewGroup
import androidx.recyclerview.widget.AsyncListDiffer
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.RecyclerView

class CalendarViewHolderAdapter : RecyclerView.Adapter<CalendarViewHolder>() {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CalendarViewHolder {
        return CalendarViewHolder(parent.inflate(android.R.layout.simple_list_item_checked))
    }

    override fun getItemCount(): Int = differ.currentList.size

    override fun onBindViewHolder(holder: CalendarViewHolder, position: Int) {
        holder.bind(differ.currentList[position])
    }

    fun update(list: List<Calendar>) {
        differ.submitList(list)
    }

    private val differ = AsyncListDiffer<Calendar>(this, object : DiffUtil.ItemCallback<Calendar>() {
        override fun areContentsTheSame(oldItem: Calendar, newItem: Calendar): Boolean =
                newItem.isSelected == oldItem.isSelected && newItem.name == oldItem.name

        override fun areItemsTheSame(oldItem: Calendar, newItem: Calendar): Boolean =
                newItem.id == oldItem.id

    })

}