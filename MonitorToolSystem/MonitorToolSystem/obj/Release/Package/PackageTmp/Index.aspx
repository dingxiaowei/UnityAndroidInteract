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
                        <tbody id ="FuncTBody">
                        </tbody>
                    </table>
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
