package flutter.curiosity.utilsimport android.content.Contextimport android.content.Intentimport android.content.pm.PackageInfoimport android.content.res.Resourcesimport android.net.Uriimport android.os.Buildimport android.os.Processimport android.util.Logimport android.webkit.CookieManagerimport androidx.core.content.FileProviderimport com.google.zxing.BarcodeFormatimport com.google.zxing.DecodeHintTypeimport com.google.zxing.Resultimport flutter.curiosity.CuriosityPlugin.Companion.contextimport io.flutter.plugin.common.MethodCallimport io.flutter.plugin.common.MethodChannelimport java.io.Fileimport java.util.*object NativeUtils {    fun getBarHeight(barName: String?): Float {        val resources: Resources = context.resources        val resourceId = resources.getIdentifier(barName, "dimen", "android")        return resources.getDimensionPixelSize(resourceId).toFloat()    }    // 这里设置可扫描的类型    val hints: Map<DecodeHintType, Any>        get() {            val decodeFormats: MutableCollection<BarcodeFormat> = ArrayList<BarcodeFormat>()            //一维码            decodeFormats.add(BarcodeFormat.UPC_A)            decodeFormats.add(BarcodeFormat.UPC_E)            decodeFormats.add(BarcodeFormat.EAN_13)            decodeFormats.add(BarcodeFormat.EAN_8)            decodeFormats.add(BarcodeFormat.CODABAR)            decodeFormats.add(BarcodeFormat.CODE_39)            decodeFormats.add(BarcodeFormat.CODE_93)            decodeFormats.add(BarcodeFormat.CODE_128)            decodeFormats.add(BarcodeFormat.ITF)            decodeFormats.add(BarcodeFormat.RSS_14)            decodeFormats.add(BarcodeFormat.RSS_EXPANDED)            //二维码            decodeFormats.add(BarcodeFormat.QR_CODE)            decodeFormats.add(BarcodeFormat.AZTEC)            decodeFormats.add(BarcodeFormat.DATA_MATRIX)//            decodeFormats.add(BarcodeFormat.MAXICODE)//            decodeFormats.add(BarcodeFormat.PDF_417)            val hints: MutableMap<DecodeHintType, Any> = mutableMapOf()          hints[DecodeHintType.CHARACTER_SET] = "UTF-8"//          hints[DecodeHintType.CHARACTER_SET] = "utf-8"            hints[DecodeHintType.POSSIBLE_FORMATS] = decodeFormats            hints[DecodeHintType.TRY_HARDER] = true            return hints        }    fun scanDataToMap(result: Result?): Map<String, Any>? {        if (result == null) return null        val data: MutableMap<String, Any> = HashMap()        data["code"] = result.text        data["type"] = result.barcodeFormat.ordinal        if (result.resultPoints != null) {            val resultPoints: MutableList<Map<String, Any>> = ArrayList()            for (point in result.resultPoints) {                val pointMap: MutableMap<String, Any> = HashMap()                pointMap["x"] = point.x                pointMap["y"] = point.y                resultPoints.add(pointMap)            }            data["points"] = resultPoints        }        return data    }    /**     * 安装apk     * @param apkPath     */    fun installApp(apkPath: String?) {        val context: Context = context        val file = File(apkPath)        val intent = Intent(Intent.ACTION_VIEW)        // 由于没有在Activity环境下启动Activity,设置下面的标签        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK        //版本在7.0以上是不能直接通过uri访问的        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) { //参数1 上下文, 参数2 Provider主机地址 和配置文件中保持一致   参数3  共享的文件            val apkUri = FileProvider.getUriForFile(context, context.packageName + ".provider", file)            //添加这一句表示对目标应用临时授权该Uri所代表的文件            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)            intent.setDataAndType(apkUri, "application/vnd.android.package-archive")        } else {            intent.setDataAndType(Uri.fromFile(file),                    "application/vnd.android.package-archive")        }        context.startActivity(intent)    }    /**     * 获取路径文件和文件夹大小     *     * @param filePath     * @return     */    fun getFilePathSize(filePath: String?): String? {        if (filePath == null) return null        return if (FileUtils.isDirectoryExist(filePath)) {            val file = File(filePath)            if (file.isDirectory) {                FileUtils.getDirectorySize(file)            } else {                FileUtils.getFileSize(file)            }        } else {            "NotFile"        }    }    /**     * 退出app     */    fun exitApp() {        //杀死进程，否则就算退出App，App处于空进程并未销毁，再次打开也不会初始化Application        //从而也不会执行getJSBundleFile去更换bundle的加载路径 !!!        Process.killProcess(Process.myPid())        System.exit(0)    }    /**     * 获取cookie     *     * @param url     */    fun getAllCookie(url: String?): String {        return CookieManager.getInstance().getCookie(url)    }    /**     * 清除cookie     */    fun clearAllCookie() {        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {            CookieManager.getInstance().removeAllCookies {}        }    }    /**     * 判断手机是否安装某个应用     *     * @return true：安装，false：未安装     */    fun isInstallApp(packageName: String?): Boolean {        val packages: MutableList<PackageInfo> = context.packageManager.getInstalledPackages(0) // 获取所有已安装程序的包信息        for (i in packages.indices) {            val pn = packages[i].packageName            if (packageName == pn) {                return true            }        }        return false    }    /**     * 跳转至应用商店     */    fun goToMarket(packageName: String?, marketPackageName: String?) {        val uri = Uri.parse("market://details?id=$packageName")        val intent = Intent(Intent.ACTION_VIEW, uri)        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)        if (marketPackageName != null && marketPackageName != "") { // 如果没给市场的包名，则系统会弹出市场的列表让你进行选择。            intent.setPackage(marketPackageName)        }        context.startActivity(intent)    }    /**     * 判断应用是否存在的方法     *     * @param packageName     */    fun isAndroidMarket(packageName: String?): Boolean {        val pInfo: List<PackageInfo> = context.packageManager.getInstalledPackages(0) // 获取所有已安装程序的包信息        val pName: MutableList<String> = ArrayList() // 用于存储所有已安装程序的包名        // 从pInfo中将包名字逐一取出，压入pName list中        for (i in pInfo.indices) {            val pn = pInfo[i].packageName            pName.add(pn)        }        return pName.contains(packageName) // 判断pName中是否有目标程序的包名，有TRUE，没有FALSE    }    fun isArgumentNull(key: String, call: MethodCall, result: MethodChannel.Result, function: () -> Unit) {        if (call.argument<Any>(key) == null) {            result.error("null", "$key is not null", null);            return        } else {            function()        }    }    fun logInfo(content: String) {        Log.i("Curiosity--- ", content)    }}