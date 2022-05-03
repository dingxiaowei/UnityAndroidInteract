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
                <div id="MonitorFrameDiv" style="height: 500px" runat="server"></div>
                <div id="MonitorBatteryLevelDiv" style="height: 500px" runat="server"></div>
                <div id="MonitorMemoryDiv" style="height: 500px" runat="server"></div>
                <div id="MonitorProfilerDiv" style="height: 500px" runat="server"></div>
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
            <div id="LogModule">
                <h2>Log信息</h2>
                <div id="LogDiv"></div>
            </div>
            <div id="AuthorDiv" style="position: relative">
                <label style="position: absolute; right: 0">Powerd By 阿拉丁 2022/5/1</label>
            </div>
        </div>
    </form>
    <script type="text/javascript">
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
                        testDiv.innerHTML = "产品名称:" + jsonObj["ProductName"] + "<br/>包名:" + jsonObj["PackageName"] + "<br/>平台:" + jsonObj["Platform"] + "<br/>版本(Version):" + jsonObj["Version"] + "<br/>测试时长:" + jsonObj["TestTime"];
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
                            //保存图片
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
                        monitorMemoryChart.setOption(memoryOption);
                        //Profiler数据
                        var profilerChart = echarts.init(document.getElementById("MonitorProfilerDiv"));
                        var profilerOption = {
                            title: {
                                text: 'Profiler分析'
                            },
                            tooltip: {
                                trigger: 'axis'
                            },
                            legend: {
                                data: ['堆内存(MonoHeapSize)MB', '堆使用内存(MonoUsedSize)MB', 'Unity分配内存(TotalAllocatedMemory)MB', 'Unity总内存(TotalReservedMemory)MB', '未使用内存(TotalUnusedReservedMemory)MB']
                            },
                            grid: {
                                left: '3%',
                                right: '4%',
                                bottom: '3%',
                                containLabel: true
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
                                    name: '堆内存(MonoHeapSize)MB',
                                    type: 'line',
                                    stack: 'Total',
                                    data: monoHeapSizeArrayData
                                },
                                {
                                    name: '堆使用内存(MonoUsedSize)MB',
                                    type: 'line',
                                    stack: 'Total',
                                    data: monoUsedSizeArrayData
                                },
                                {
                                    name: 'Unity分配内存(TotalAllocatedMemory)MB',
                                    type: 'line',
                                    stack: 'Total',
                                    data: totalAllocatedMemoryArrayData
                                },
                                {
                                    name: 'Unity总内存(TotalReservedMemory)MB',
                                    type: 'line',
                                    stack: 'Total',
                                    data: unityTotalReservedMemoryArrayData
                                },
                                {
                                    name: '未使用内存(TotalUnusedReservedMemory)MB',
                                    type: 'line',
                                    stack: 'Total',
                                    data: totalUnusedReservedMemoryArrayData
                                }]
                        };
                        profilerChart.setOption(profilerOption);
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
