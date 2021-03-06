package flutter.curiosity.scanner

import android.annotation.SuppressLint
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Handler
import com.google.zxing.*
import com.google.zxing.common.HybridBinarizer
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.net.HttpURLConnection
import java.net.URL
import java.security.SecureRandom
import java.security.cert.X509Certificate
import java.util.*
import java.util.concurrent.Executor
import java.util.concurrent.Executors
import javax.net.ssl.HttpsURLConnection
import javax.net.ssl.SSLContext
import javax.net.ssl.TrustManager
import javax.net.ssl.X509TrustManager

object ScannerTools {
    private val executor: Executor = Executors.newSingleThreadExecutor()
    private val multiFormatReader: MultiFormatReader = MultiFormatReader()

    fun scanImagePath(call: MethodCall, result: MethodChannel.Result) {
        val path = call.argument<String>("path")
        assert(path != null)
        val file = File(path.toString())
        if (file.isFile) {
            executor.execute {
                val bitmap = BitmapFactory.decodeFile(path)
                Handler().post { result.success(identifyBitmap(bitmap)) }
            }
        } else {
            result.success(null)
        }
    }


    fun scanImageUrl(call: MethodCall, result: MethodChannel.Result) {
        val url = call.argument<String>("url")
        executor.execute {
            val myUrl = URL(url)
            val bitmap: Bitmap
            assert(url != null)
            if (url!!.startsWith("https")) {
                val connection = myUrl.openConnection() as HttpsURLConnection
                connection.readTimeout = 6 * 60 * 1000
                connection.connectTimeout = 6 * 60 * 1000
                val tm = arrayOf<TrustManager>(X509Trust())
                val sslContext = SSLContext.getInstance("TLS")
                sslContext.init(null, tm, SecureRandom())
                // 从上述SSLContext对象中得到SSLSocketFactory对象
                val ssf = sslContext.socketFactory
                connection.sslSocketFactory = ssf
                connection.connect()
                bitmap = BitmapFactory.decodeStream(connection.inputStream)
            } else {
                val connection = myUrl.openConnection() as HttpURLConnection
                connection.readTimeout = 6 * 60 * 1000
                connection.connectTimeout = 6 * 60 * 1000
                connection.connect()
                bitmap = BitmapFactory.decodeStream(connection.inputStream)
            }
            Handler().post { result.success(identifyBitmap(bitmap)) }
        }
    }

    fun scanImageMemory(call: MethodCall, result: MethodChannel.Result) {
        val unit8List = call.argument<ByteArray>("unit8List")
        assert(unit8List != null)
        executor.execute {
            val bitmap: Bitmap = BitmapFactory.decodeByteArray(unit8List, 0, unit8List!!.size)
            Handler().post { result.success(identifyBitmap(bitmap)) }
        }
    }

    private fun identifyBitmap(bitmap: Bitmap): Map<String, Any>? {
        multiFormatReader.setHints(hints)
        val height = bitmap.height
        val width = bitmap.width
        val pixels = IntArray(width * height)
        bitmap.getPixels(pixels, 0, width, 0, 0, width, height)
        var result: Result? = null
        val source = RGBLuminanceSource(
                width,
                height, pixels)
        try {
            result = multiFormatReader.decodeWithState(BinaryBitmap(HybridBinarizer(source)))
        } catch (e: NotFoundException) {
            try {
                result = multiFormatReader.decodeWithState(BinaryBitmap(HybridBinarizer(source.invert())))
            } catch (e: NotFoundException) {
            }
        }
        return scanDataToMap(result)
    }

    private class X509Trust : X509TrustManager {
        // 检查客户端证书
        @SuppressLint("TrustAllX509TrustManager")
        override fun checkClientTrusted(chain: Array<X509Certificate>, authType: String) {
        }

        // 检查服务器端证书
        @SuppressLint("TrustAllX509TrustManager")
        override fun checkServerTrusted(chain: Array<X509Certificate>, authType: String) {
        }

        // 返回受信任的X509证书数组
        override fun getAcceptedIssuers(): Array<X509Certificate>? {
            return null
        }
    }

    // 这里设置可扫描的类型
    val hints: Map<DecodeHintType, Any>
        get() {
            val decodeFormats: MutableCollection<BarcodeFormat> = ArrayList<BarcodeFormat>()
            //一维码
            decodeFormats.add(BarcodeFormat.UPC_A)
            decodeFormats.add(BarcodeFormat.UPC_E)
            decodeFormats.add(BarcodeFormat.EAN_13)
            decodeFormats.add(BarcodeFormat.EAN_8)
            decodeFormats.add(BarcodeFormat.CODABAR)
            decodeFormats.add(BarcodeFormat.CODE_39)
            decodeFormats.add(BarcodeFormat.CODE_93)
            decodeFormats.add(BarcodeFormat.CODE_128)
            decodeFormats.add(BarcodeFormat.ITF)
            decodeFormats.add(BarcodeFormat.RSS_14)
            decodeFormats.add(BarcodeFormat.RSS_EXPANDED)
            //二维码
            decodeFormats.add(BarcodeFormat.QR_CODE)
            decodeFormats.add(BarcodeFormat.AZTEC)
            decodeFormats.add(BarcodeFormat.DATA_MATRIX)
//            decodeFormats.add(BarcodeFormat.MAXICODE)
//            decodeFormats.add(BarcodeFormat.PDF_417)
            val hints: MutableMap<DecodeHintType, Any> = mutableMapOf()
            hints[DecodeHintType.CHARACTER_SET] = "UTF-8"
            hints[DecodeHintType.POSSIBLE_FORMATS] = decodeFormats
            hints[DecodeHintType.TRY_HARDER] = true
            return hints
        }

    fun scanDataToMap(result: Result?): Map<String, Any>? {
        val data: MutableMap<String, Any> = HashMap()
        if (result == null) {
            data["code"] = ""
            data["type"] = ""
        } else {
            data["code"] = result.text
            data["type"] = result.barcodeFormat.name
        }
        return data
    }
}