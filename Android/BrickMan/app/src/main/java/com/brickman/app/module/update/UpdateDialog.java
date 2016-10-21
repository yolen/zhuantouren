package com.brickman.app.module.update;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;

import com.brickman.app.MApplication;
import com.brickman.app.R;
import com.brickman.app.common.data.DataKeeper;

public class UpdateDialog extends DialogFragment {
    public static final String IGNORE_VERSION_NAME = "ignore_version_name";
    private DataKeeper mDataKeeper;
    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        mDataKeeper = MApplication.mDataKeeper;
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity(), AlertDialog.THEME_DEVICE_DEFAULT_LIGHT);
        builder.setTitle(getString(R.string.newUpdateAvailable)+"("+getArguments().getString(KeyConstants.APK_VERSION_NAME)+")");
        builder.setMessage(getArguments().getString(KeyConstants.APK_UPDATE_CONTENT))
                .setPositiveButton(R.string.dialogPositiveButton, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        // FIRE ZE MISSILES!
                        goToDownload();
                        dismiss();
                    }
                })
                .setNegativeButton(R.string.dialogNegativeButton, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        // User cancelled the dialog
                        mDataKeeper.put(IGNORE_VERSION_NAME, getArguments().getString(KeyConstants.APK_VERSION_NAME));
                        dismiss();
                    }
                });
        setCancelable(false);
        return builder.create();
    }


    private void goToDownload() {
    	Intent intent=new Intent(getActivity().getApplicationContext(),DownloadService.class);
    	intent.putExtra(KeyConstants.APK_DOWNLOAD_URL, getArguments().getString(KeyConstants.APK_DOWNLOAD_URL));
    	getActivity().startService(intent);
    }
}
