package uk.co.amlcurran.social;

import android.app.Activity;
import android.content.pm.PackageManager;
import androidx.core.content.ContextCompat;
import androidx.collection.SparseArrayCompat;

public class Permissions {
    private final Activity activity;
    private final SparseArrayCompat<PermissionRequest> requestMap = new SparseArrayCompat<>();

    public Permissions(Activity activity) {
        this.activity = activity;
    }

    void requestPermission(int requestCode, OnPermissionRequestListener permissionRequestListener, String... requiredPermissions) {
        if (hasAllPermissions(requiredPermissions)) {
            permissionRequestListener.onPermissionGranted();
        } else {
            requestMap.put(requestCode, new PermissionRequest(permissionRequestListener, requiredPermissions));
            activity.requestPermissions(requiredPermissions, requestCode);
        }
    }

    private boolean hasAllPermissions(String[] requiredPermissions) {
        boolean passedAll = true;
        for (String permission : requiredPermissions) {
            passedAll = passedAll && ContextCompat.checkSelfPermission(activity, permission) == PackageManager.PERMISSION_GRANTED;
        }
        return passedAll;
    }

    public void onRequestPermissionResult(int requestCode, int[] grantResults) {
        PermissionRequest permissionRequest = requestMap.get(requestCode);
        if (permissionRequest != null) {
            boolean passedAll = true;
            for (int grantResult : grantResults) {
                passedAll = passedAll && grantResult == PackageManager.PERMISSION_GRANTED;
            }
            if (passedAll) {
                permissionRequest.requestCode.onPermissionGranted();
            } else {
                permissionRequest.requestCode.onPermissionDenied();
            }
        }
    }

    interface OnPermissionRequestListener {
        void onPermissionGranted();

        void onPermissionDenied();
    }

    private class PermissionRequest {

        final String[] permissionsRequested;
        final OnPermissionRequestListener requestCode;

        private PermissionRequest(OnPermissionRequestListener requestCode, String[] permissionsRequested) {
            this.requestCode = requestCode;
            this.permissionsRequested = permissionsRequested;
        }
    }

}