<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="MonitorToolSystem.Index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>性能报告</title>
    <script src="Modules/echarts.min.js"></script>
    <script src="Modules/jquery-3.3.1.min.js"></script>
    <%--<script src="https://cdn.staticfile.org/jquery/2.2.4/jquery.min.js"></script>
	<script src="https://cdn.staticfile.org/echarts/4.3.0/echarts.min.js"></script>--%>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div id="RecordListModule" runat="server">
                <%--<asp:Label ID="lbl" Text=" 性别:" runat="server"></asp:Label>--%>
                <h2>报告列表</h2>
                <asp:DropDownList ID="ddlPackageNameList" runat="server" AutoPostBack="True" OnLoad="ddlPackageNameList_Load"></asp:DropDownList><br />
                <asp:DropDownList ID="ddlReportTimeList" runat="server" AutoPostBack="True" OnLoad="ddlReportTimeList_Load"></asp:DropDownList><br />
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
            <div id="FunctionAnalysisModule" runat="server">
                <h2>函数性能</h2>
                <div id="FunctionAnalysisDiv" runat="server"></div>
            </div>
            <div id="LogModule" runat="server">
                <h2>Log信息</h2>
                <div id="LogDiv" runat="server"></div>
            </div>
            <div id="AuthorDiv" style="position: relative" runat="server">
                <label style="position: absolute; right: 0">Powerd By Aladdin 2022/4/24</label>
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
                        deviceDiv.innerHTML = data;
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
