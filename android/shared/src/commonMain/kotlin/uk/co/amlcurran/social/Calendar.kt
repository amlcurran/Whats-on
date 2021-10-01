package uk.co.amlcurran.social

data class Calendar(val id: String, val name: String, val color: Int, val isSelected: Boolean)

fun <E> Collection<E>.inserting(element: E): Collection<E> = toMutableSet().apply {
    add(element)
}

fun <E> Collection<E>.removing(element: E): Collection<E> = toMutableSet().apply {
    remove(element)
}