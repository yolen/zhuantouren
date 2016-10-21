package com.brickman.app.module.widget.view;

import android.content.Context;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.brickman.app.R;
import com.brickman.app.common.utils.DensityUtils;

/**
 * Created by mayu on 16/9/2,下午3:18.
 */
public class ToastManager {

    public static void showWithImg(Context ctx, int imgRes) {
        LayoutInflater inflater = LayoutInflater.from(ctx);
        View view = inflater.inflate(R.layout.layout_toast_with_img, null);
        ImageView image = (ImageView) view.findViewById(R.id.img);
        image.setImageResource(imgRes);
        Toast toast = new Toast(ctx);
        toast.setGravity(Gravity.CENTER_VERTICAL, 0, DensityUtils.dip2px(ctx, 70));
        toast.setDuration(Toast.LENGTH_SHORT);
        toast.setView(view);
        toast.show();
    }

    public static void showWithTxt(Context ctx, String txt) {
        LayoutInflater inflater = LayoutInflater.from(ctx);
        View view = inflater.inflate(R.layout.layout_toast_with_txt, null);
        TextView text = (TextView) view.findViewById(R.id.txt);
        text.setText(txt);
        Toast toast = new Toast(ctx);
        toast.setGravity(Gravity.BOTTOM, 0, DensityUtils.dip2px(ctx, 70));
        toast.setDuration(Toast.LENGTH_SHORT);
        toast.setView(view);
        toast.show();
    }

    public static void showWithTxt(Context ctx, int txtRes) {
        LayoutInflater inflater = LayoutInflater.from(ctx);
        View view = inflater.inflate(R.layout.layout_toast_with_txt, null);
        TextView text = (TextView) view.findViewById(R.id.txt);
        text.setText(ctx.getResources().getString(txtRes));
        Toast toast = new Toast(ctx);
        toast.setGravity(Gravity.BOTTOM, 0, DensityUtils.dip2px(ctx, 70));
        toast.setDuration(Toast.LENGTH_SHORT);
        toast.setView(view);
        toast.show();
    }
}
