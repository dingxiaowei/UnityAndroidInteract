package com.sc.testextendlibrary;

import java.util.ArrayList;
import java.util.List;

import com.unity3d.player.UnityPlayer;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.ProgressDialog;
import android.app.Service;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProviderInfo;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.BatteryManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Vibrator;
import android.telephony.TelephonyManager;
import android.text.format.Formatter;
import android.util.Log;
import android.widget.Toast;

public class MainActivity extends UnityPlayerActivity {

    private Vibrator mVibrator01;//声明一个振动器对象
    private static Context instance;
    private String TAG = "log";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        instance = getApplicationContext();
        CreateToast("默认的初始化");

        onCoderReturn("pid:"+android.os.Process.myPid() +" "+getBaseContext().getPackageName());//显示进程id和包名
    }

    public static Context getContext()
    {
        return instance;
    }

    /*
     * 求和
     */
    public int Sum(int a,int b)
    {
        int sum = a+b;
        onCoderReturn(String.format("%s + %s = %s", a,b,sum));
        return sum;
    }

    public int Add(int a,int b){
        Log.i("Android", "Unity Call Android Function Add");
        UnityPlayer.UnitySendMessage("MainCamera","ChangeColor","");
        return a+b;
    }

    /*
     * 震动
     */
    public void ClickShake()
    {
        mVibrator01 = (Vibrator)getApplication().getSystemService(Service.VIBRATOR_SERVICE);
        /*
         * 震动的方式
         */
        // vibrator.vibrate(2000);//振动两秒
        // 下边是可以使震动有规律的震动  -1：表示不重复 0：循环的震动
        long[] pattern = {200, 200 };
        mVibrator01.vibrate(pattern, -1);
    }

    /*
     * 状态返回Unity
     */
    public void onCoderReturn(String state )
    {
        String gameObjectName = "Main Camera";
        String methodName = "OnCoderReturn";
        String arg0 = state;
        UnityPlayer.UnitySendMessage(gameObjectName, methodName, arg0);
    }

    /***********************调用Android Toast***************************/

    /*
     * Unity调用安卓的Toast
     */
    public void UnityCallAndroidToast(final String toast )
    {
        runOnUiThread(new Runnable(){
            @Override
            public void run() {
                //onCoderReturn("Android:UnityCallAndroidToast()");
                /*
                 * 第一个参数：当前上下午的环境。可用getApplicationContext()或this
                 * 第二个参数：要显示的字符串
                 * 第三个参数：显示时间的长短。Toast有默认的两个LENGTH_SHORT（短）和LENGTH_LONG（长），也可以使用毫秒2000ms
                 * */
                Toast.makeText(MainActivity.this,toast,Toast.LENGTH_SHORT).show();
            }
        });
    }

    /*
     * 创建Toast
     */
    public void CreateToast(final String toast)
    {
        runOnUiThread(new Runnable(){
            @Override
            public void run() {
                //onCoderReturn("CreateToast()");
                Toast.makeText(
                        MainActivity.this,
                        toast,Toast.LENGTH_LONG).show();
            }
        });
    }


    /*************************************重启应用*************************************/

    /*
     * 重新启动应用
     */
    public void RestartApplication(){
        CreateToast("应用重启中...");

        Intent launch=getBaseContext().getPackageManager().getLaunchIntentForPackage(getBaseContext().getPackageName());
        launch.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        startActivity(launch);
    }

    /*
     * UI 线程重启应用
     */
    public void RestartApplicationOnUIThread(){
        CreateToast("3s后应用重启...");
        new Thread(){
            public void run(){
                Intent launch=getBaseContext().getPackageManager().getLaunchIntentForPackage(getBaseContext().getPackageName());
                launch.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                startActivity(launch);
                android.os.Process.killProcess(android.os.Process.myPid());
                onCoderReturn("pid:"+android.os.Process.myPid());
            }
        }.start();
        finish();
    }

    /*
     * 立即重启应用 ok
     */
    public void RestartApplication1(){
        new Thread(){
            public void run(){
                Intent launch=getBaseContext().getPackageManager().getLaunchIntentForPackage(getBaseContext().getPackageName());
                launch.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                startActivity(launch);
                android.os.Process.killProcess(android.os.Process.myPid());
            }
        }.start();
        finish();
    }

    /*
     * 延迟5s重启应用 ok
     */
    public void RestartApplication2(){
        ProgressDialog progressDialog = new ProgressDialog(MainActivity.this);
        progressDialog.setMessage("5s后自动重启…");
        progressDialog.show();

        new Handler().postDelayed(new Runnable(){
            public void run() {
                Intent launch=getBaseContext().getPackageManager().getLaunchIntentForPackage(getBaseContext().getPackageName());
                launch.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                startActivity(launch);
                android.os.Process.killProcess(android.os.Process.myPid());
            }
        }, 5000);
    }

    /************************调用第三方app *****************************/

    public void CallThirdApp(String packageName)//packageName
    {
        Intent intent = getPackageManager().getLaunchIntentForPackage(packageName);
        startActivity(intent);
        onCoderReturn(packageName);
    }

    /*
     * 获取所有安装包名和apk名字
     */
    public void GetAllPackageName()
    {
        PackageManager packageManager = null;
        packageManager = getPackageManager();
        List<PackageInfo> mAllPackages=new ArrayList<PackageInfo>();
        mAllPackages = packageManager.getInstalledPackages(0);
        for(int i = 0; i < mAllPackages.size(); i ++)
        {
            PackageInfo packageInfo = mAllPackages.get(i);
            Log.i("package path", packageInfo.applicationInfo.sourceDir);
            Log.i("apk name", (String) packageInfo.applicationInfo.loadLabel(packageManager) );
            onCoderReturn("sourceDir:"+packageInfo.applicationInfo.sourceDir+" apkName:"+packageInfo.applicationInfo.loadLabel(packageManager));
        }

    }

    /*
     * 个人安卓的额第三方App ok
     */
    public void GetInstalledPackageName()
    {
        PackageManager packageManager = null;
        packageManager = getPackageManager();
        List<PackageInfo> mAllPackages=new ArrayList<PackageInfo>();
        mAllPackages = packageManager.getInstalledPackages(0);
        for(int i = 0; i < mAllPackages.size(); i ++)
        {
            PackageInfo packageInfo = mAllPackages.get(i);
            if((packageInfo.applicationInfo.flags & ApplicationInfo.FLAG_SYSTEM)<= 0)
            {
                onCoderReturn("apkName:"+packageInfo.applicationInfo.loadLabel(packageManager)+"package path:"+packageInfo.applicationInfo.packageName);
            }
            else
            {
                onCoderReturn("sys apkName:"+packageInfo.applicationInfo.loadLabel(packageManager));
            }
        }
    }

    /*
     * 获取安装包
     */
    public void GetAllWidget()
    {
        List<AppWidgetProviderInfo> widgetProviderInfos = AppWidgetManager.getInstance(this).getInstalledProviders();
        Log.d("widget", "allWidgetSize = " + widgetProviderInfos.size());
        for (int i = 0; i < widgetProviderInfos.size(); i++) {
            AppWidgetProviderInfo info = widgetProviderInfos.get(i);
            String packageName = info.provider.getPackageName();    //获取包名
            String className = info.provider.getClassName();        //获取类名
            Log.d("widget", "packageName: " + packageName);
            Log.d("widget", "className: " + className);
            onCoderReturn("packageName："+packageName);
        }
    }

    /**************************安卓本地推送通知***********************************/
    /*
     * 安卓本地推送
     */

    /*
    @SuppressWarnings("deprecation")
    public void SendNotification(String title,String content)
    {
        NotificationManager nm=(NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        //1.实例化一个通知，指定图标、概要、时间
        Notification n=new Notification(R.drawable.ic_launcher,content,3000);
        //2.指定通知的标题、内容和intent
        Intent intent = new Intent(this, MainActivity.class);
        //设置跳转到的页面 ，时间等内容
        PendingIntent pi= PendingIntent.getActivity(this, 0, intent, 1000);
        n.setLatestEventInfo(this, title, content, pi);
        n.flags |= Notification.FLAG_AUTO_CANCEL; // FLAG_AUTO_CANCEL表明当通知被用户点击时，通知将被清除。
        //3.指定声音
        n.defaults = Notification.DEFAULT_SOUND;
        n.when = System.currentTimeMillis(); // 立即发生此通知
        //4.发送通知
        nm.notify(1, n);
    }
    */

    /**************************************************************/
    /**
     * 1.获取手机电池电量 2.检查手机是否充电
     * */
    public String MonitorBatteryState() {
        UnityCallAndroidToast("获取电池信息中...");
        IntentFilter ifilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
        Intent intent = instance.registerReceiver(null,ifilter);
        int rawlevel = intent.getIntExtra("level", 0);//获得当前电量
        int scale = intent.getIntExtra("scale", 0);//获得总电量
        int status = intent.getIntExtra("status", 0);//电池充电状态
        int health = intent.getIntExtra("health", 0);//电池健康状况
        int batteryV = intent.getIntExtra("voltage", 0);  //电池电压(mv)
        int temperature = intent.getIntExtra("temperature", 0);  //电池温度(数值)
        double T = temperature/10.0; //电池摄氏温度，默认获取的非摄氏温度值，需做一下运算转换
        String targetStr="";
        int level = -1;
        if (rawlevel > 0 && scale > 0)
        {
            level = (rawlevel * 100) / scale;
            CreateToast("剩余电量:"+level+"%");
            Log.v(TAG,"现在的电量是:"+level+"%" );
            targetStr = level+"|"+scale+"|"+status;
            onCoderReturn("当前电量："+level+"|总容量："+scale+"|充电状态："+status+"|电压:"+batteryV+"电池健康状态："+health+"温度:"+T+" 现在的电量是:"+level+"%");
            UnityPlayer.UnitySendMessage("Main Canera", "OnBatteryDataReturn", targetStr);
        }
        else
        {
            onCoderReturn("获取不到电池信息!");
        }

        if(health == BatteryManager.BATTERY_HEALTH_GOOD )
        {
            Log.v(TAG, "电池状态很好");
        }
        if(status==BatteryManager.BATTERY_STATUS_CHARGING)//充电标记2
        {
            UnityCallAndroidToast("电池充电中...");
        }
        else
        {
            UnityCallAndroidToast("电池放电中...");
        }
        //notifyBattery(level,scale,status);

        return targetStr ;
    }

    /*
    获取电池信息
     */
    public String GetBatteryInfos() {
        BatteryManager batteryManager = (BatteryManager) MainActivity.this.getSystemService(android.content.Context.BATTERY_SERVICE);

        // 剩余电量百分比 BATTERY_PROPERTY_CAPACITY: 51
        int batteryCapacity = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        // 当前电池容量(mAH) BATTERY_PROPERTY_CHARGE_COUNTER: 2192080
        int batteryChargeCounter = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CHARGE_COUNTER) / 1000;
        // 剩余能量(nWH) BATTERY_PROPERTY_ENERGY_COUNTER: -2147483648
        long batteryEnergyCounter = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_ENERGY_COUNTER);
        // 瞬时电流(mA)  BATTERY_PROPERTY_CURRENT_NOW: 632324（负表示放电 正表示充电）
        int batteryCurrentNow = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW);
        // 平均电流(mA)  BATTERY_PROPERTY_CURRENT_AVERAGE: -2147483648 （负表示放电 正表示充电）
        int batteryCurrentAverage = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_AVERAGE);
        // 状态
        int status = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_STATUS);

        IntentFilter ifilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
        Intent intent = instance.registerReceiver(null,ifilter);
        int temperature = intent.getIntExtra("temperature", 0) / 10;  //电池温度(数值) ℃
        float batteryV = intent.getIntExtra("voltage", 0) / 1000f;  //电池电压(伏)

        //电池总容量  毫安
        int capacity = (int)(ToMA((float)batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CHARGE_COUNTER)) / ((float)batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)/100f));

//        Log.d(TAG, "电池总容量 capacity: " + capacity);
//        Log.d(TAG, "剩余电量百分比 batteryCapacity: " + batteryCapacity);
//        Log.d(TAG, "当前剩余容量(mAH) batteryChargeCounter: " + batteryChargeCounter);
//        Log.d(TAG, "当前剩余能量(nWH) batteryEnergyCounter: " + batteryEnergyCounter);
//        Log.d(TAG, "瞬时电流(mA)  batteryCurrentNow: " + batteryCurrentNow);
//        Log.d(TAG, "平均电流(mA)  batteryCurrentAverage: " + batteryCurrentAverage);

        String batteryStatus = "";
        switch (status){
            // 正充电
            case BatteryManager.BATTERY_STATUS_CHARGING:
                batteryStatus = "正在充电";
                break;
            // 已经充满
            case BatteryManager.BATTERY_STATUS_FULL:
                batteryStatus = "已经充满";
                break;
            // 正断开充电
            case BatteryManager.BATTERY_STATUS_DISCHARGING:
                batteryStatus = "正断开充电";
                break;
            // 没有充电
            case BatteryManager.BATTERY_STATUS_NOT_CHARGING:
                batteryStatus = "没有充电";
                break;
            // 未知状态
            case BatteryManager.BATTERY_STATUS_UNKNOWN:
                break;
        }

        // (当前电池容量 mAH)/(瞬时电流 mA)
        long remainHours = batteryChargeCounter / Math.abs(batteryCurrentNow);

        float useLeftHouser = capacity * batteryCapacity / 100f / Math.abs(batteryCurrentNow);
        //瞬时功率
        float p = (int)(batteryCurrentNow * batteryV);

        return "电池总容量(毫安):" + capacity + " \n 电池温度(℃):"+ temperature+ " 电池电压(伏):" + batteryV + " 剩余电量百分比:" + batteryCapacity + " 当前剩余容量(mAH):"+ batteryChargeCounter + " 瞬时电流(mA):"+ batteryCurrentNow + " 瞬时功率:" + p + " 剩余使用时长:" + String.format("%.2f", useLeftHouser) + "小时" + " 当前电池状态:" + batteryStatus;
    }

    static float ToMA(float maOrua)
    {
        return maOrua < 10000 ? maOrua : maOrua / 1000f;
    }

    //获取详细电量信息 返回电量|是否充电中
    public String notifyBattery(int level,int scale,int status)
    {
        String batteryStatue = "";
        int per = scale/5;
        if(level<=per)
        {
            Log.v(TAG, "手机电量低于1/5");
            batteryStatue+= "0.2|";
        }
        else if(level>per && level<=per*2)
        {
            Log.v(TAG, "手机电量低于2/5");
            batteryStatue+= "0.4|";
        }
        else if(level>2*per && level<=per*3)
        {
            Log.v(TAG, "手机电量低于3/5");
            batteryStatue+= "0.6|";
        }
        else if(level>3*per && level<=per*4)
        {
            Log.v(TAG, "手机电量低于4/5");
            batteryStatue+= "0.8|";
        }
        else
        {
            Log.v(TAG, "手机电量充足");
            batteryStatue+= "1|";
        }
        if(status==BatteryManager.BATTERY_STATUS_CHARGING)//充电标记2
        {
            Log.v(TAG,"充电中，电量背景为animation");
            batteryStatue+="2";
            UnityCallAndroidToast("电池充电中...");
        }
        else
        {
            if(status == BatteryManager.BATTERY_STATUS_FULL)//5
            {
                Log.v(TAG, "满电量");
                CreateToast("电池电量充足");
            }
            else if(status == BatteryManager.BATTERY_STATUS_NOT_CHARGING)//4
            {
                Log.v(TAG,"未充电");
            }
            else if(status == BatteryManager.BATTERY_STATUS_DISCHARGING)//3
            {
                Log.v(TAG,"放电中");
                CreateToast("电池放电中");
            }
            if(status == BatteryManager.BATTERY_STATUS_UNKNOWN)//1
            {
                Log.v(TAG,"状态未知");
            }
            batteryStatue+="0";
        }
        CreateToast(batteryStatue);
        //电量信息格式:剩余百分比|是否充电中
        return batteryStatue;
    }

    //获取wifi信号强度
    //wifiinfo.getRssi()；获取RSSI，RSSI就是接受信号强度指示。
    //这里得到信号强度就靠wifiinfo.getRssi()这个方法。
    //得到的值是一个0到-100的区间值，是一个int型数据，其中0到-50表示信号最好，
    //-50到-70表示信号偏差，小于-70表示最差，
    //有可能连接不上或者掉线，一般Wifi已断则值为-200。
    @SuppressWarnings("deprecation")
    private String ObtainWifiInfo() {
        // Wifi的连接速度及信号强度：
        String result="";
        WifiManager wifiManager = (WifiManager) getSystemService(WIFI_SERVICE);
        WifiInfo info = wifiManager.getConnectionInfo();
        if (info.getBSSID() != null) {
            // 链接信号强度
            int strength = WifiManager.calculateSignalLevel(info.getRssi(), 5);
            // 链接速度
            int speed = info.getLinkSpeed();
            // 链接速度单位
            String units = WifiInfo.LINK_SPEED_UNITS;
            // Wifi源名称
            String ssid = info.getSSID();
            int ip = info.getIpAddress();
            String mac = info.getMacAddress();
            result = strength+"|"+intToIp(ip)+"|"+mac+"|"+ssid;
        }
        UnityPlayer.UnitySendMessage("Main Canera", "OnWifiDataReturn", result);
        UnityCallAndroidToast(result);
        return result;
    }
    //转换IP地址
    private String intToIp(int paramInt) {
        return (paramInt & 0xFF) + "." + (0xFF & paramInt >> 8) + "." + (0xFF & paramInt >> 16) + "."
                + (0xFF & paramInt >> 24);
    }
    /************************检测运营商*******************************/
    /*
     * 检测SIM卡类型
     */
    public String CheckSIM(){
        String SIMTypeString = "";
        TelephonyManager telManager = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);
        String operator = telManager.getSimOperator();
        if (operator != null){
            if (operator.equals("46000") || operator.equals("46002")){
                CreateToast("此卡属于(中国移动)");
                SIMTypeString = "中国移动";
            } else if (operator.equals("46001")){
                CreateToast("此卡属于(中国联通)");
                SIMTypeString = "中国联通";

            } else if (operator.equals("46003")){
                CreateToast("此卡属于(中国电信)");
                SIMTypeString = "中国电信";
            }
        }
        return SIMTypeString;
    }
}