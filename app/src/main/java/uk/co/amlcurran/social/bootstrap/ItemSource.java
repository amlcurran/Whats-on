package uk.co.amlcurran.social.bootstrap;

public interface ItemSource<T> {

    int count();

    T itemAt(int position);

}
