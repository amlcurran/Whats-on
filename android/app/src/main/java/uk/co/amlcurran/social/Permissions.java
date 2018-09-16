package uk.co.amlcurran.social;

import android.app.Activity;
import android.content.pm.PackageManager;
import android.support.v4.content.ContextCompat;
import android.support.v4.util.SparseArrayCompat;

public class Permissions {
    private final Activity activity;
    private final SparseArrayCompat<PermissionRequest> requestMap = new SparseArrayCompat<>();

    public Permissions(Activity activity) {
        this.activity = activity;
    }

    void requestPermission(int requestCode, String requiredPermission, OnPermissionRequestListener permissionRequestListener) {
        if (ContextCompat.checkSelfPermission(activity, requiredPermission) == PackageManager.PERMISSION_GRANTED) {
            permissionRequestListener.onPermissionGranted();
        } else {
            requestMap.put(requestCode, new PermissionRequest(permissionRequestListener, new String[] {requiredPermission}));
            activity.requestPermissions(new String[]{requiredPermission}, requestCode);
        }
    }

    public void onRequestPermissionResult(int requestCode, String[] permissions, int[] grantResults) {
        PermissionRequest permissionRequest = requestMap.get(requestCode);
        if (permissionRequest != null) {
            boolean passedAll = true;
            for (int i = 0, length = grantResults.length; i < length; i++) {
                passedAll = passedAll && grantResults[i] == PackageManager.PERMISSION_GRANTED;
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