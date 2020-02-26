package flutter.curiosity.utils;import android.content.Context;import android.content.Intent;import android.content.pm.PackageInfo;import android.content.res.Resources;import android.net.Uri;import android.os.Build;import android.webkit.CookieManager;import androidx.core.content.FileProvider;import com.google.zxing.BarcodeFormat;import com.google.zxing.DecodeHintType;import com.google.zxing.Result;import com.google.zxing.ResultPoint;import java.io.File;import java.util.ArrayList;import java.util.Collection;import java.util.EnumMap;import java.util.HashMap;import java.util.List;import java.util.Map;import flutter.curiosity.CuriosityPlugin;public class NativeUtils {    public static float getBarHeight(String barName) {        Resources resources = CuriosityPlugin.context.getResources();        int resourceId = resources.getIdentifier(barName, "dimen", "android");        return resources.getDimensionPixelSize(resourceId);    }    public static Map<DecodeHintType, Object> getHints() {        Collection<BarcodeFormat> decodeFormats = new ArrayList<>();        // 这里设置可扫描的类型        //二维码        decodeFormats.add(BarcodeFormat.AZTEC);        decodeFormats.add(BarcodeFormat.DATA_MATRIX);        decodeFormats.add(BarcodeFormat.MAXICODE);        decodeFormats.add(BarcodeFormat.QR_CODE);        //一维码        decodeFormats.add(BarcodeFormat.CODABAR);        decodeFormats.add(BarcodeFormat.CODE_39);        decodeFormats.add(BarcodeFormat.CODE_93);        decodeFormats.add(BarcodeFormat.CODE_128);        decodeFormats.add(BarcodeFormat.EAN_8);        decodeFormats.add(BarcodeFormat.EAN_13);        decodeFormats.add(BarcodeFormat.ITF);        decodeFormats.add(BarcodeFormat.PDF_417);        decodeFormats.add(BarcodeFormat.RSS_14);        decodeFormats.add(BarcodeFormat.RSS_EXPANDED);        decodeFormats.add(BarcodeFormat.UPC_A);        decodeFormats.add(BarcodeFormat.UPC_E);        decodeFormats.add(BarcodeFormat.UPC_EAN_EXTENSION);        Map<DecodeHintType, Object> hints = new EnumMap<>(DecodeHintType.class);//        hints.put(DecodeHintType.CHARACTER_SET, "utf-8");        hints.put(DecodeHintType.TRY_HARDER, Boolean.FALSE);        hints.put(DecodeHintType.POSSIBLE_FORMATS, decodeFormats);        return hints;    }    public static Map<String, Object> scanDataToMap(Result result) {        if (result == null) return null;        Map<String, Object> data = new HashMap<>();        data.put("message", result.getText());        data.put("type", result.getBarcodeFormat().ordinal());        if (result.getResultPoints() != null) {            List<Map<String, Object>> resultPoints = new ArrayList<>();            for (ResultPoint point : result.getResultPoints()) {                Map<String, Object> pointMap = new HashMap<>();                pointMap.put("x", point.getX());                pointMap.put("y", point.getY());                resultPoints.add(pointMap);            }            data.put("points", resultPoints);        }        return data;    }    /**     * 安装apk     * @param apkPath     */    public static void installApp(String apkPath) {        Context context = CuriosityPlugin.context;        File file = new File(apkPath);        Intent intent = new Intent(Intent.ACTION_VIEW);        // 由于没有在Activity环境下启动Activity,设置下面的标签        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);        //版本在7.0以上是不能直接通过uri访问的        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {            //参数1 上下文, 参数2 Provider主机地址 和配置文件中保持一致   参数3  共享的文件            Uri apkUri = FileProvider.getUriForFile(context, context.getPackageName() + ".provider", file);            //添加这一句表示对目标应用临时授权该Uri所代表的文件            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);            intent.setDataAndType(apkUri, "application/vnd.android.package-archive");        } else {            intent.setDataAndType(Uri.fromFile(file),                    "application/vnd.android.package-archive");        }        context.startActivity(intent);    }    /**     * 获取路径文件和文件夹大小     *     * @param filePath     * @return     */    public static String getFilePathSize(final String filePath) {        if (FileUtils.isDirectoryExist(filePath)) {            File file = new File(filePath);            if (file.isDirectory()) {                return FileUtils.getDirectorySize(file);            } else {                return FileUtils.getFileSize(file);            }        } else {            return "NotFile";        }    }    /**     * 退出app     */    public static void exitApp() {        //杀死进程，否则就算退出App，App处于空进程并未销毁，再次打开也不会初始化Application        //从而也不会执行getJSBundleFile去更换bundle的加载路径 !!!        android.os.Process.killProcess(android.os.Process.myPid());        System.exit(0);    }    /**     * 获取cookie     *     * @param url     */    public static String getAllCookie(String url) {        return CookieManager.getInstance().getCookie(url);    }    /**     * 清除cookie     */    public static void clearAllCookie() {        CookieManager.getInstance().removeAllCookies(value -> {        });    }    /**     * 判断手机是否安装某个应用     *     * @return true：安装，false：未安装     */    public static boolean isInstallApp(String packageName) {        List<PackageInfo> packages = CuriosityPlugin.context.getPackageManager().getInstalledPackages(0);// 获取所有已安装程序的包信息        if (packages != null) {            for (int i = 0; i < packages.size(); i++) {                String pn = packages.get(i).packageName;                if (packageName.equals(pn)) {                    return true;                }            }        }        return false;    }    /**     * 跳转至应用商店     */    public static void goToMarket(String packageName, String marketPackageName) {        Uri uri = Uri.parse("market://details?id=" + packageName);        Intent intent = new Intent(Intent.ACTION_VIEW, uri);        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);        if (marketPackageName != null && !marketPackageName.equals("")) {// 如果没给市场的包名，则系统会弹出市场的列表让你进行选择。            intent.setPackage(marketPackageName);        }        CuriosityPlugin.context.startActivity(intent);    }    /**     * 判断应用是否存在的方法     *     * @param packageName     */    public static boolean isAndroidMarket(String packageName) {        List<PackageInfo> pInfo = CuriosityPlugin.context.getPackageManager().getInstalledPackages(0);// 获取所有已安装程序的包信息        List<String> pName = new ArrayList<>();// 用于存储所有已安装程序的包名        // 从pInfo中将包名字逐一取出，压入pName list中        if (pInfo != null) {            for (int i = 0; i < pInfo.size(); i++) {                String pn = pInfo.get(i).packageName;                pName.add(pn);            }        }        return pName.contains(packageName);// 判断pName中是否有目标程序的包名，有TRUE，没有FALSE    }}