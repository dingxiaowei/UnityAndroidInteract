<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="MonitorToolSystem.Index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>性能报告</title>
    <script src="Modules/echarts.min.js"></script>
    <script src="Modules/jquery-3.3.1.min.js"></script>
    <link href="StyleSheet.css" rel="stylesheet" />
    <%--<script src="https://cdn.staticfile.org/jquery/2.2.4/jquery.min.js"></script>
	<script src="https://cdn.staticfile.org/echarts/4.3.0/echarts.min.js"></script>--%>
</head>
<body>
    <h1>Unity性能监控报表工具</h1>
    <form id="form1" runat="server">
        <div>
            <div id="RecordListModule" runat="server">
                <h2>报告列表</h2>
                <h5>请选择应用(包名)</h5>
                <asp:DropDownList ID="ddlPackageNameList" runat="server" AutoPostBack="True" OnLoad="ddlPackageNameList_Load"></asp:DropDownList>
                <h5>请选择测试时间</h5>
                <asp:DropDownList ID="ddlReportTimeList" runat="server" AutoPostBack="True" OnLoad="ddlReportTimeList_Load"></asp:DropDownList>
            </div>
            <div id="TestInfoModule">
                <h2>测试信息</h2>
                <div id="TestInfoDiv"></div>
            </div>
            <div id="DeviceInfoModule">
                <h2>设备信息</h2>
                <div id="DeviceInfoDiv"></div>
            </div>
            <div id="MonitorInfoModule">
                <h2>性能报告</h2>
                <div id="MonitorFrameDiv" style="height: 500px"></div>
                <div id="MonitorBatteryLevelDiv" style="height: 500px"></div>
                <div id="MonitorMemoryDiv" style="height: 500px"></div>
                <div id="MonitorProfilerDiv" style="height: 500px"></div>
            </div>
            <div id="RenderModule">
                <h2>渲染报告</h2>
                <div id="RenderDiv" style="height: 500px"></div>
            </div>
            <div id="PowerConsumeModule">
                <h2>手机功耗报告</h2>
                <div id="TemptureDiv" style="height: 500px"></div>
                <div id="PowerDiv" style="height:500px"></div>
            </div>
            <div id="FunctionAnalysisModule">
                <h2>函数性能</h2>
                <div id="FunctionAnalysisDiv">
                    <table>
                        <tbody id="FuncTBody">
                        </tbody>
                    </table>
                    <br />
                    <label style="color: orangered">说明:关注高频调用，平均执行时间超过10ms的函数，要重点优化！</label>
                </div>
            </div>
            <div id="FunctionCodeAnalysisModule">
                <h2>不规范的代码列表</h2>
                <div id="FunctionCodeAnalysisDiv">
                    <table>
                        <tbody id="FuncCodeTBody">
                        </tbody>
                    </table>
                    <br />
                    <label style="color: orangered">说明:以上是不规范的代码列表，可能会造成性能问题，请按照表格中修改建议进行修改！</label>
                </div>
            </div>
            <div id="LogModule">
                <h2>Log信息</h2>
                <div id="LogDiv"></div>
            </div>
            <div id="AuthorDiv" style="position: relative">
                <label style="position: absolute; right: 0">Powerd By 阿拉丁 2022/5/1</label>
            </div>
        </div>
        <img id="TemptureImg" src="./Texts/placeholder.png" alt="" style="width: 150px; display: none" />
    </form>
    <script type="text/javascript">
        var img = document.querySelector('img');
        var funcCallback = null;
        var xOffset = 22;
        var frameIndex = -1;//ECharts的帧率图
        document.addEventListener('click', function (e) {
            //console.log("clientX:" + e.clientX + "   clentY:" + e.clientY); //屏幕坐标-TOP栏坐标(页面内的屏幕坐标)
            //console.log("pageX:" + e.pageX + "    pageY:" + e.pageY); //页面坐标
            //console.log("screenX:" + e.screenX + "   screenY:" + e.screenY); //屏幕坐标
            console.log("frameIndex:" + frameIndex);
            if (funcCallback) {
                $.ajax({
                    type: "POST",
                    url: "/CaptureFrameHandler.ashx?PackageName=" + packageNameValue + "&TestTime=" + timeValue + "&FrameIndex=" + frameIndex,
                    data: String,
                    success: function (data) {
                        if (data.includes('error')) {
                            funcCallback = null;
                            frameIndex = -1;
                        }
                        else {
                            img.src = data;
                            funcCallback(e.pageX, e.pageY, data);
                            funcCallback = null;
                            frameIndex = -1;
                        }
                    },
                    error: function (jqXHR) {
                        console.error(jqXHR);
                        funcCallback = null;
                        frameIndex = -1;
                    }
                });
            }
            else {
                img.style.display = "none";
            }
        })
        var scrollHight = 0;
        window.onscroll = function () {
            //获取滚动条到顶部的垂直高度
            scrollHight = document.documentElement.scrollTop || document.body.scrollTop;
        }

        function HideElement(divName) {
            var testInfoDiv = document.getElementById(divName);
            testInfoDiv.style.display = 'none';
        }

        var ddlPackageName = document.getElementById('ddlPackageNameList');
        var packageNameValue = ddlPackageName.options[ddlPackageName.selectedIndex].value;
        var ddlTime = document.getElementById('ddlReportTimeList');
        var timeValue = ddlTime.options[ddlTime.selectedIndex].value;

        $(function () {
            //测试信息
            $.ajax({
                type: "POST",
                url: "/TestInfoHandler.ashx?PackageName=" + packageNameValue + "&TestTime=" + timeValue,
                data: JSON,
                success: function (data) {
                    if (data.includes('error')) {
                        HideElement('TestInfoModule');
                    }
                    else {
                        var jsonObj = JSON.parse(data);
                        let testDiv = document.getElementById('TestInfoDiv');
                        testDiv.innerHTML = "产品名称:" + jsonObj["ProductName"] + "<br/>包名:" + jsonObj["PackageName"] + "<br/>平台:" + jsonObj["Platform"] + "<br/>版本(Version):" + jsonObj["Version"] + "<br/>测试时长:" + jsonObj["TestTime"] + "<br/>检测间隔帧数:" + jsonObj["IntervalFrame"];
                    }
                },
                error: function (jqXHR) {
                    console.error(jqXHR);
                    HideElement('TestInfoModule');
                }
            });
            //设备信息
            $.ajax({
                type: "POST",
                url: "/DeviceInfoHandler.ashx?PackageName=" + packageNameValue + "&TestTime=" + timeValue,
                data: JSON,
                success: function (data) {
                    if (data.includes('error')) {
                        HideElement('DeviceInfoModule');
                    }
                    else {
                        var jsonObj = JSON.parse(data);
                        let deviceDiv = document.getElementById('DeviceInfoDiv');
                        deviceDiv.innerHTML = "Unity版本:" + jsonObj["UnityVersion"] + "<br/>测试系统:" + jsonObj["OperatingSystem"] + "<br/>设备Model:" + jsonObj["DeviceModel"] + "<br/>设备名称:" + jsonObj["DeviceName"] + "<br/>设备ID:" + jsonObj["DeviceUniqueIdentifier"] + "<br/>设备内存:" + jsonObj["SystemMemorySize"] + "<br/>设备显存:" + jsonObj["GraphicsMemorySize"] + "<br/>处理器信息:" + jsonObj["ProcessorType"] + "<br/>处理器频率:" + jsonObj["ProcessorFrequency"] + "<br/>处理器核心数:" + jsonObj["ProcessorCount"] + "<br/>显卡名称:" + jsonObj["GraphicsDeviceName"] + "<br/>显卡供应商:" + jsonObj["GraphicsDeviceVendor"] + "<br/>显卡类型和版本:" + jsonObj["GraphicsDeviceVersion"] + "<br/>是否支持内置阴影:" + jsonObj["SupportsShadows"] + "<br/>电量占比(1.0为满电):" + jsonObj["BatteryLevel"] + "<br/>屏幕分辨率 宽:" + jsonObj["ScreenWidth"] + "  高:" + jsonObj["ScreenHeight"];
                    }
                },
                error: function (jqXHR) {
                    console.error(jqXHR);
                    HideElement('DeviceInfoModule');
                }
            });
            //Render信息
            $.ajax({
                type: "POST",
                url: "/RenderHandler.ashx?PackageName=" + packageNameValue + "&TestTime=" + timeValue,
                data: JSON,
                success: function (data) {
                    if (data.includes('error')) {
                        HideElement('RenderModule');
                    }
                    else {
                        var myJson = JSON.parse(data);
                        var frameIndexArrayData = [];
                        var drawCallData = [];
                        var setPassCallData = [];
                        var verticesData = [];
                        var trianglesData = [];
                        for (var i in myJson.RenderInfoList) {
                            frameIndexArrayData.push(myJson.RenderInfoList[i].FrameIndex);
                            setPassCallData.push(myJson.RenderInfoList[i].SetPassCall);
                            drawCallData.push(myJson.RenderInfoList[i].DrawCall);
                            verticesData.push(myJson.RenderInfoList[i].Vertices);
                            trianglesData.push(myJson.RenderInfoList[i].Triangles);
                        }
                        //渲染
                        var renderChart = echarts.init(document.getElementById("RenderDiv"));
                        var renderOption = {
                            title: {
                                text: '渲染报告',
                                textStyle: {
                                    fountSize: 12,
                                    fountWeight: 400,
                                    color: '#000000'
                                },
                                //left: 5,
                                //top: -5,
                            },
                            tooltip: {
                                trigger: 'axis',
                                //axisPointer: {
                                //    type: 'shadow'
                                //}
                            },
                            color: ['#FF0000', '#0E76E4', '#F18A31', '#00F063'],
                            legend: {
                                show: true,
                                right: '15%',
                                top: 12,
                                width: 300,
                                height: 100,
                                icon: 'rect',
                                itemWidth: 10,
                                itemHeight: 4,
                                textStyle: {
                                    color: '#1a1a1a',
                                    fontSize: 12,
                                },
                                data: ['SetPassCall', 'DrawCall', '顶点', '三角面']
                            },
                            ////grid: {
                            ////    left: '3%',
                            ////    right: '4%',
                            ////    bottom: '3%',
                            ////    containLabel: true
                            ////},
                            toolbox: {
                                feature: {
                                    saveAsImage: {}
                                }
                            },
                            xAxis: {
                                data: frameIndexArrayData
                            },
                            yAxis: {
                                type: 'value'
                            },
                            dataZoom: [
                                {   // 这个dataZoom组件，默认控制x轴。
                                    type: 'slider', // 这个 dataZoom 组件是 slider 型 dataZoom 组件
                                    start: 0,      // 左边在 0% 的位置。
                                    end: 100         // 右边在 100% 的位置。
                                }
                            ],
                            series: [
                                {
                                    name: 'SetPassCall',
                                    type: 'line',
                                    //stack: 'Total', //累加属性，这样线不会重叠
                                    data: setPassCallData
                                },
                                {
                                    name: 'DrawCall',
                                    type: 'line',
                                    //stack: 'Total',
                                    data: drawCallData
                                },
                                {
                                    name: '顶点',
                                    type: 'line',
                                    //stack: 'Total',
                                    data: verticesData
                                },
                                {
                                    name: '三角面',
                                    type: 'line',
                                    //stack: 'Total',
                                    data: trianglesData
                                }
                            ]
                        };
                        renderChart.setOption(renderOption);
                        renderChart.getZr().on('click', function (params) {
                            var yOffset = 145;
                            frameIndex = frameIndexArrayData[renderChart.getOption().xAxis[0].axisPointer.value];
                            console.log("x坐标:" + frameIndex);
                            funcCallback = function (x, y, src) {
                                if (src) {
                                    console.log("*******funcCallback*******")
                                    console.log(src);
                                    img.style.display = "block";
                                    img.src = src;
                                    img.style.position = "absolute";
                                    img.style.left = x + xOffset + 'px';
                                    img.style.top = y + yOffset + 'px';
                                }
                                else {
                                    img.style.display = "none";
                                }
                            };
                        });
                    }
                }
            });
            //PowerConsume信息
            $.ajax({
                type: "POST",
                url: "/PowerConsumeHandler.ashx?PackageName=" + packageNameValue + "&TestTime=" + timeValue,
                data: JSON,
                success: function (data) {
                    if (data.includes('error')) {
                        HideElement('PowerConsumeModule');
                    }
                    else {
                        var myJson = JSON.parse(data);
                        var frameIndexArrayData = []; //帧率
                        var batteryTemptureData = []; //电池温度
                        var cpuTemptureData = []; //cpu温度
                        var voltageData = [];//电压
                        var electricData = [];//电流
                        var powerData = []; //功率
                        var leftTime = [];//剩余时长
                        for (var i in myJson.devicePowerConsumeInfos) {
                            frameIndexArrayData.push(myJson.devicePowerConsumeInfos[i].FrameIndex);
                            batteryTemptureData.push(myJson.devicePowerConsumeInfos[i].Temperature);
                            cpuTemptureData.push(myJson.devicePowerConsumeInfos[i].CpuTemperate);
                            voltageData.push(myJson.devicePowerConsumeInfos[i].BatteryV.toFixed(1));
                            electricData.push(Math.abs(myJson.devicePowerConsumeInfos[i].BatteryCurrentNow));
                            powerData.push(Math.abs(myJson.devicePowerConsumeInfos[i].BatteryPower));
                            leftTime.push(myJson.devicePowerConsumeInfos[i].UseLeftHours.toFixed(1));
                        }
                        //温度
                        var temptureChart = echarts.init(document.getElementById("TemptureDiv"));
                        var temptureOption = {
                            title: {
                                text: '温度报告'
                            },
                            tooltip: {
                                trigger: 'axis'
                            },
                            color: ['#FA660A', '#0E76E4'],
                            legend: {
                                show: true,
                                right: '15%',
                                top: 0,
                                width: 300,
                                height: 100,
                                icon: 'rect',
                                itemWidth: 10,
                                itemHeight: 4,
                                textStyle: {
                                    color: '#1a1a1a',
                                    fontSize: 12,
                                },
                                data: ['电池温度℃', 'CPU温度℃']
                            },
                            ////grid: {
                            ////    left: '3%',
                            ////    right: '4%',
                            ////    bottom: '3%',
                            ////    containLabel: true
                            ////},
                            toolbox: {
                                feature: {
                                    saveAsImage: {}
                                }
                            },
                            xAxis: {
                                data: frameIndexArrayData
                            },
                            yAxis: {
                                type: 'value'
                            },
                            dataZoom: [
                                {   // 这个dataZoom组件，默认控制x轴。
                                    type: 'slider', // 这个 dataZoom 组件是 slider 型 dataZoom 组件
                                    start: 0,      // 左边在 0% 的位置。
                                    end: 100         // 右边在 100% 的位置。
                                }
                            ],
                            series: [
                                {
                                    name: '电池温度℃',
                                    type: 'line',
                                    //stack: 'Total', //累加属性，这样线不会重叠
                                    data: batteryTemptureData
                                },
                                {
                                    name: 'CPU温度℃',
                                    type: 'line',
                                    //stack: 'Total',
                                    data: cpuTemptureData
                                }]
                        };
                        temptureChart.setOption(temptureOption);
                        temptureChart.getZr().on('click', function (params) {
                            var yOffset = 99;
                            frameIndex = frameIndexArrayData[temptureChart.getOption().xAxis[0].axisPointer.value];
                            console.log("x坐标:" + frameIndex);
                            funcCallback = function (x, y, src) {
                                if (src) {
                                    console.log("*******funcCallback*******")
                                    console.log(src);
                                    img.style.display = "block";
                                    img.src = src;
                                    img.style.position = "absolute";
                                    img.style.left = x + xOffset + 'px';
                                    img.style.top = y + yOffset + 'px';
                                }
                                else {
                                    img.style.display = "none";
                                }
                            };
                        })
                        //功耗数据
                        var powerChart = echarts.init(document.getElementById("PowerDiv"));
                        var powerOption = {
                            title: {
                                text: '功耗报告'
                            },
                            tooltip: {
                                trigger: 'axis'
                            },
                            color: ['#FA660A', '#0E76E4', '#8923F1', '#FF00F0'],
                            legend: {
                                show: true,
                                right: '15%',
                                top: 0,
                                width: 500,
                                height: 100,
                                icon: 'rect',
                                itemWidth: 10,
                                itemHeight: 4,
                                textStyle: {
                                    color: '#1a1a1a',
                                    fontSize: 12,
                                },
                                data: ['电流(毫安)', '电压(伏)', '功耗', '剩余使用时长(小时)']
                            },
                            toolbox: {
                                feature: {
                                    saveAsImage: {}
                                }
                            },
                            xAxis: {
                                data: frameIndexArrayData
                            },
                            yAxis: {
                                type: 'value'
                            },
                            dataZoom: [
                                {   // 这个dataZoom组件，默认控制x轴。
                                    type: 'slider', // 这个 dataZoom 组件是 slider 型 dataZoom 组件
                                    start: 0,      // 左边在 0% 的位置。
                                    end: 100         // 右边在 100% 的位置。
                                }
                            ],
                            series: [
                                {
                                    name: '电流(毫安)',
                                    type: 'line',
                                    //stack: 'Total',
                                    data: electricData
                                },
                                {
                                    name: '电压(伏)',
                                    type: 'line',
                                    //stack: 'Total',
                                    data: voltageData
                                },
                                {
                                    name: '功耗',
                                    type: 'line',
                                    //stack: 'Total',
                                    data: powerData
                                },
                                {
                                    name: '剩余使用时长(小时)',
                                    type: 'line',
                                    //stack: 'Total',
                                    data: leftTime
                                }]
                        };
                        powerChart.setOption(powerOption);
                        powerChart.getZr().on('click', function (params) {
                            var yOffset = 143;
                            frameIndex = frameIndexArrayData[powerChart.getOption().xAxis[0].axisPointer.value];
                            console.log("x坐标:" + frameIndex);
                            funcCallback = function (x, y, src) {
                                if (src) {
                                    console.log("*******funcCallback*******")
                                    console.log(src);
                                    img.style.display = "block";
                                    img.src = src;
                                    img.style.position = "absolute";
                                    img.style.left = x + xOffset + 'px';
                                    img.style.top = y + yOffset + 'px';
                                }
                                else {
                                    img.style.display = "none";
                                }
                            };
                        });
                    }
                },
                error: function (jqXHR) {
                    console.error(jqXHR);
                    HideElement('PowerConsumeModule');
                }
            });

            //Monitor信息
            $.ajax({
                type: "POST",
                url: "/MonitorHandler.ashx?PackageName=" + packageNameValue + "&TestTime=" + timeValue,
                data: JSON,
                success: function (data) {
                    if (data.includes('error')) {
                        HideElement('MonitorInfoModule');
                    }
                    else {
                        var myJson = JSON.parse(data);
                        var frameIndexArrayData = [];
                        var frameArrayData = [];
                        var batteryArrayData = [];
                        var memoryArrayData = [];
                        var monoHeapSizeArrayData = [];
                        var monoUsedSizeArrayData = [];
                        var totalAllocatedMemoryArrayData = [];
                        var unityTotalReservedMemoryArrayData = [];
                        var totalUnusedReservedMemoryArrayData = [];
                        var mb = 1024 * 1024;
                        for (var i in myJson.MonitorInfoList) {
                            frameIndexArrayData.push(myJson.MonitorInfoList[i].FrameIndex);
                            frameArrayData.push(myJson.MonitorInfoList[i].Frame);
                            batteryArrayData.push(Math.floor(myJson.MonitorInfoList[i].BatteryLevel * 100) / 100 * 100);
                            memoryArrayData.push(myJson.MonitorInfoList[i].MemorySize);
                            monoHeapSizeArrayData.push(myJson.MonitorInfoList[i].MonoHeapSize / mb);
                            monoUsedSizeArrayData.push(myJson.MonitorInfoList[i].MonoUsedSize / mb);
                            totalAllocatedMemoryArrayData.push(myJson.MonitorInfoList[i].TotalAllocatedMemory / mb);
                            unityTotalReservedMemoryArrayData.push(myJson.MonitorInfoList[i].UnityTotalReservedMemory / mb);
                            totalUnusedReservedMemoryArrayData.push(myJson.MonitorInfoList[i].TotalUnusedReservedMemory / mb);
                        }
                        var monitorchart = echarts.init(document.getElementById("MonitorFrameDiv"));
                        //指定图表的配置项和数据
                        var option = {
                            tooltip: {
                                trigger: 'axis'
                            },
                            //标题
                            title: {
                                text: '帧率报表'
                            },
                            //工具箱
                            //保存图片
                            toolbox: {
                                show: true,
                                feature: {
                                    saveAsImage: {
                                        show: true
                                    }
                                }
                            },
                            //图例-每一条数据的名字叫帧率
                            legend: {
                                data: ['帧率']
                            },
                            //x轴
                            xAxis: {
                                data: frameIndexArrayData
                            },
                            //y轴没有显式设置，根据值自动生成y轴
                            yAxis: [{
                                type: 'value',
                                scale: true,
                                max: 75,
                                min: 0,
                                splitNumber: 5,
                                boundaryGap: [0.2, 0.2]
                            }],
                            dataZoom: [
                                {   // 这个dataZoom组件，默认控制x轴。
                                    type: 'slider', // 这个 dataZoom 组件是 slider 型 dataZoom 组件
                                    start: 0,      // 左边在 0% 的位置。
                                    end: 100         // 右边在 100% 的位置。
                                }
                            ],
                            //数据-data是最终要显示的数据
                            series: [{
                                name: '数值',
                                type: 'line',
                                data: frameArrayData
                            }]
                        };
                        //使用刚刚指定的配置项和数据项显示图表
                        monitorchart.setOption(option);
                        monitorchart.getZr().on('click', function (params) {
                            var yOffset = 75;
                            frameIndex = frameIndexArrayData[monitorchart.getOption().xAxis[0].axisPointer.value];
                            console.log("x坐标:" + frameIndex);
                            funcCallback = function (x, y, src) {
                                if (src) {
                                    console.log("*******funcCallback*******")
                                    console.log(src);
                                    img.style.display = "block";
                                    img.src = src;
                                    img.style.position = "absolute";
                                    img.style.left = x + xOffset + 'px';
                                    img.style.top = y + yOffset + 'px';
                                }
                                else {
                                    img.style.display = "none";
                                }
                            };
                        })

                        //电量报表
                        var monitorBatteryChart = echarts.init(document.getElementById("MonitorBatteryLevelDiv"));
                        //指定图表的配置项和数据
                        var batteryOption = {
                            tooltip: {
                                trigger: 'axis'
                            },
                            //标题
                            title: {
                                text: '电量报表'
                            },
                            //工具箱
                            //保存图片
                            toolbox: {
                                show: true,
                                feature: {
                                    saveAsImage: {
                                        show: true
                                    }
                                }
                            },
                            //图例-每一条数据的名字叫电量
                            legend: {
                                data: ['电量(百分比)']
                            },
                            //x轴
                            xAxis: {
                                data: frameIndexArrayData
                            },
                            //y轴没有显式设置，根据值自动生成y轴
                            yAxis: {
                            },
                            dataZoom: [
                                {   // 这个dataZoom组件，默认控制x轴。
                                    type: 'slider', // 这个 dataZoom 组件是 slider 型 dataZoom 组件
                                    start: 0,      // 左边在 0% 的位置。
                                    end: 100         // 右边在 100% 的位置。
                                }
                            ],
                            //数据-data是最终要显示的数据
                            series: [{
                                name: '数值',
                                type: 'line',
                                data: batteryArrayData
                            }]
                        };
                        //使用刚刚指定的配置项和数据项显示图表
                        monitorBatteryChart.setOption(batteryOption);
                        monitorBatteryChart.getZr().on('click', function (params) {
                            var yOffset = 80;
                            frameIndex = frameIndexArrayData[monitorBatteryChart.getOption().xAxis[0].axisPointer.value];
                            console.log("x坐标:" + frameIndex);
                            funcCallback = function (x, y) {
                                img.style.display = "block";
                                img.style.position = "absolute";
                                img.style.left = x + xOffset + 'px';
                                img.style.top = y + yOffset + 'px';
                            }
                        });

                        //内存使用报表
                        var monitorMemoryChart = echarts.init(document.getElementById("MonitorMemoryDiv"));
                        //指定图表的配置项和数据
                        var memoryOption = {
                            tooltip: {
                                trigger: 'axis'
                            },
                            //标题
                            title: {
                                text: '内存使用报表'
                            },
                            //工具箱
                            toolbox: {
                                show: true,
                                feature: {
                                    saveAsImage: {
                                        show: true
                                    }
                                }
                            },
                            legend: {
                                data: ['内存使用 MB']
                            },
                            //x轴
                            xAxis: {
                                data: frameIndexArrayData
                            },
                            //y轴没有显式设置，根据值自动生成y轴
                            yAxis: {
                            },
                            dataZoom: [
                                {   // 这个dataZoom组件，默认控制x轴。
                                    type: 'slider', // 这个 dataZoom 组件是 slider 型 dataZoom 组件
                                    start: 0,      // 左边在 0% 的位置。
                                    end: 100         // 右边在 100% 的位置。
                                }
                            ],
                            //数据-data是最终要显示的数据
                            series: [{
                                name: '数值',
                                type: 'line',
                                data: memoryArrayData
                            }]
                        };
                        //使用刚刚指定的配置项和数据项显示图表
                        monitorMemoryChart.setOption(memoryOption);                        monitorMemoryChart.getZr().on('click', function (params) {
                            var yOffset = 80;
                            frameIndex = frameIndexArrayData[monitorMemoryChart.getOption().xAxis[0].axisPointer.value];
                            console.log("x坐标:" + frameIndex);
                            funcCallback = function (x, y, src) {
                                if (src) {
                                    console.log("*******funcCallback*******")
                                    console.log(src);
                                    img.style.display = "block";
                                    img.src = src;
                                    img.style.position = "absolute";
                                    img.style.left = x + xOffset + 'px';
                                    img.style.top = y + yOffset + 'px';
                                }
                                else {
                                    img.style.display = "none";
                                }
                            };
                        });
                        //Profiler数据
                        var profilerChart = echarts.init(document.getElementById("MonitorProfilerDiv"));
                        var profilerOption = {
                            title: {
                                text: 'Profiler分析'
                            },
                            tooltip: {
                                trigger: 'axis'
                            },
                            color: ['#FA660A', '#0E76E4', '#8923F1', '#FF0000', "#339966"],
                            legend: {
                                show: true,
                                right: '15%',
                                top: 0,
                                width: 300,
                                height: 100,
                                icon: 'rect',
                                itemWidth: 10,
                                itemHeight: 4,
                                textStyle: {
                                    color: '#1a1a1a',
                                    fontSize: 12,
                                },
                                data: ['堆内存(MonoHeapSize)MB', '堆使用内存(MonoUsedSize)MB', 'Unity分配内存(TotalAllocatedMemory)MB', 'Unity总内存(TotalReservedMemory)MB', '未使用内存(TotalUnusedReservedMemory)MB']
                            },
                            //grid: {
                            //    left: '3%',
                            //    right: '4%',
                            //    bottom: '3%',
                            //    containLabel: true
                            //},
                            toolbox: {
                                feature: {
                                    saveAsImage: {}
                                }
                            },
                            xAxis: {
                                data: frameIndexArrayData
                            },
                            yAxis: {
                                type: 'value'
                            },
                            dataZoom: [
                                {   // 这个dataZoom组件，默认控制x轴。
                                    type: 'slider', // 这个 dataZoom 组件是 slider 型 dataZoom 组件
                                    start: 0,      // 左边在 0% 的位置。
                                    end: 100         // 右边在 100% 的位置。
                                }
                            ],
                            series: [
                                {
                                    name: '堆内存(MonoHeapSize)MB',
                                    type: 'line',
                                    //stack: 'Total',
                                    data: monoHeapSizeArrayData
                                },
                                {
                                    name: '堆使用内存(MonoUsedSize)MB',
                                    type: 'line',
                                    //stack: 'Total',
                                    data: monoUsedSizeArrayData
                                },
                                {
                                    name: 'Unity分配内存(TotalAllocatedMemory)MB',
                                    type: 'line',
                                    //stack: 'Total',
                                    data: totalAllocatedMemoryArrayData
                                },
                                {
                                    name: 'Unity总内存(TotalReservedMemory)MB',
                                    type: 'line',
                                    //stack: 'Total',
                                    data: unityTotalReservedMemoryArrayData
                                },
                                {
                                    name: '未使用内存(TotalUnusedReservedMemory)MB',
                                    type: 'line',
                                    //stack: 'Total',
                                    data: totalUnusedReservedMemoryArrayData
                                }]
                        };
                        profilerChart.setOption(profilerOption);
                        profilerChart.getZr().on('click', function (params) {
                            var yOffset = 160;
                            frameIndex = frameIndexArrayData[profilerChart.getOption().xAxis[0].axisPointer.value];
                            console.log("x坐标:" + frameIndex);
                            funcCallback = function (x, y, src) {
                                if (src) {
                                    console.log("*******funcCallback*******")
                                    console.log(src);
                                    img.style.display = "block";
                                    img.src = src;
                                    img.style.position = "absolute";
                                    img.style.left = x + xOffset + 'px';
                                    img.style.top = y + yOffset + 'px';
                                }
                                else {
                                    img.style.display = "none";
                                }
                            };
                        });
                    }
                },
                error: function (jqXHR) {
                    console.error(jqXHR);
                    HideElement('MonitorInfoModule');
                }
            });
            //函数性能信息
            $.ajax({
                type: "POST",
                url: "/FuncAnalysisHandler.ashx?PackageName=" + packageNameValue + "&TestTime=" + timeValue,
                data: JSON,
                success: function (data) {
                    if (data.includes('error')) {
                        HideElement('FunctionAnalysisModule');
                    }
                    else {
                        //let funcAnalysisDiv = document.getElementById('FunctionAnalysisDiv');
                        var jsonObj = JSON.parse(data);
                        var tableData = "<tr>";
                        tableData += "<td>函数名</td>";
                        tableData += "<td>函数消耗总内存(k)</td>";
                        tableData += "<td>函数平均消耗内存(k)</td>";
                        tableData += "<td>函数总执行时间(s)</td>";
                        tableData += "<td>函数平均执行时间(ms)</td>";
                        tableData += "<td>函数调用次数</td>";
                        tableData += "</tr>"
                        for (var p in jsonObj) {
                            tableData += "<tr>";
                            tableData += "<td>" + jsonObj[p]["Name"] + "</td>";
                            tableData += "<td>" + jsonObj[p]["Memory"] + "</td>";
                            tableData += "<td>" + jsonObj[p]["AverageMemory"] + "</td>";
                            tableData += "<td>" + jsonObj[p]["UseTime"] + "</td>";
                            tableData += "<td>" + jsonObj[p]["AverageTime"] + "</td>";
                            tableData += "<td>" + jsonObj[p]["Calls"] + "</td>";
                            tableData += "</tr>";
                        }
                        $("#FuncTBody").html(tableData);
                    }
                },
                error: function (jqXHR) {
                    console.error(jqXHR);
                    HideElement('FunctionAnalysisModule');
                }
            });
            //代码规范化检测
            $.ajax({
                type: "POST",
                url: "/FuncCodeAnalysisHandler.ashx?PackageName=" + packageNameValue + "&TestTime=" + timeValue,
                data: JSON,
                success: function (data) {
                    if (data.includes('error')) {
                        HideElement('FunctionCodeAnalysisModule');
                    }
                    else {
                        var jsonObj = JSON.parse(data);
                        var tableData = "<tr>";
                        tableData += "<td>ID</td>";
                        tableData += "<td>文件名</td>";
                        tableData += "<td>不规范代码以及修改建议</td>";
                        tableData += "<td>行号</td>";
                        tableData += "<td>列号</td>";
                        tableData += "</tr>"
                        for (var p in jsonObj) {
                            tableData += "<tr>";
                            tableData += "<td>" + jsonObj[p]["Id"] + "</td>";
                            tableData += "<td>" + jsonObj[p]["FileName"] + "</td>";
                            tableData += "<td>" + jsonObj[p]["Tip"] + "</td>";
                            tableData += "<td>" + jsonObj[p]["LineNumber"] + "</td>";
                            tableData += "<td>" + jsonObj[p]["CharaterPosition"] + "</td>";
                            tableData += "</tr>";
                        }
                        $("#FuncCodeTBody").html(tableData);
                    }
                },
                error: function (jqXHR) {
                    console.error(jqXHR);
                    HideElement('FunctionCodeAnalysisModule');
                }
            });
            //Log信息
            $.ajax({
                type: "POST",
                url: "/LogHandler.ashx?PackageName=" + packageNameValue + "&TestTime=" + timeValue,
                data: String,
                success: function (data) {
                    if (data.includes('error')) {
                        HideElement('LogModule');
                    }
                    else {
                        let deviceDiv = document.getElementById('LogDiv');
                        var logInnerText = data.replace(/\n|\r/g, '<br/>');
                        deviceDiv.innerHTML = logInnerText;
                    }
                },
                error: function (jqXHR) {
                    console.error(jqXHR);
                    HideElement('LogModule');
                }
            });
        });
    </script>
</body>
</html>
