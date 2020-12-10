package pro.ramanovich.yaotp

import android.os.Bundle
import android.view.WindowManager.LayoutParams
import androidx.annotation.NonNull
import io.flutter.BuildConfig
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState);

        if (BuildConfig.RELEASE) {
            window.addFlags(LayoutParams.FLAG_SECURE)
        }
    }
}
