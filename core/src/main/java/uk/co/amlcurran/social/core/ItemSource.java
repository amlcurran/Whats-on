package uk.co.amlcurran.social.core;

public interface ItemSource<T> {

    int count();

    T itemAt(int position);

}
