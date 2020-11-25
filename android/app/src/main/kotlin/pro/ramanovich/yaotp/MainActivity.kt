package pro.ramanovich.yaotp

import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity
import android.view.WindowManager.LayoutParams;

class MainActivity: FlutterFragmentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // window.addFlags(LayoutParams.FLAG_SECURE)
    }
}
