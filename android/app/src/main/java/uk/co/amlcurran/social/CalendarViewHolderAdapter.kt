package uk.co.amlcurran.social

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.appcompat.widget.AppCompatCheckBox
import androidx.recyclerview.widget.AsyncListDiffer
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.RecyclerView
import uk.co.amlcurran.social.databinding.RowCalendarBinding

class CalendarViewHolderAdapter(private val onCalendarEnable: (Calendar, Boolean) -> Unit) : RecyclerView.Adapter<CalendarViewHolder>() {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CalendarViewHolder {
        return CalendarViewHolder(RowCalendarBinding.inflate(LayoutInflater.from(parent.context), parent, false))
    }

    override fun getItemCount(): Int = differ.currentList.size

    override fun onBindViewHolder(holder: CalendarViewHolder, position: Int) {
        holder.bind(differ.currentList[position], onCalendarEnable)
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

class CalendarViewHolder(private val binding: RowCalendarBinding) : RecyclerView.ViewHolder(binding.root) {
    fun bind(calendar: Calendar, onChange: (Calendar, Boolean) -> Unit) {
        binding.calendar = calendar
        (binding.root as AppCompatCheckBox).setOnCheckedChangeListener { _, isChecked ->
            onChange(calendar, isChecked)
        }
        binding.executePendingBindings()
    }

}
