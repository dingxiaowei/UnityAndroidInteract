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
                <a>最近访问报告列表</a>
                <br />
                <asp:DropDownList ID="ddlPackageNameList" runat="server" AutoPostBack="true"></asp:DropDownList><br />
                <asp:DropDownList ID="ddlReportTimeList" runat="server" AutoPostBack="true"></asp:DropDownList><br />
            </div>
            <div id="TestInfoModule">
                <h2>测试信息</h2>
                <br />
                <div id="TestInfoDiv"></div>
            </div>
            <div id="DeviceInfoModule">
                <h2>设备信息</h2>
                <br />
                <div id="DeviceInfoDiv"></div>
            </div>
            <div id="MonitorInfoModule">
                <h2>性能报告</h2>
                <br />
                <div id="MonitorFrameDiv" style="height:500px" runat="server"></div>
                <div id="MonitorBatteryLevelDiv" style="height:500px" runat="server"></div>
                <div id="MonitorMemoryDiv" style="height:500px" runat="server"></div>
                <div id="MonitorProfilerDiv" style="height:500px" runat="server"></div>
            </div>
            <div id="FunctionAnalysisModule" runat="server">
                <h2>函数性能</h2>
                <div id="FunctionAnalysisDiv" runat="server"></div>
            </div>
            <div id="LogModule" runat="server">
                <h2>Log信息</h2>
                <div id="LogDiv" runat="server"></div>
            </div>
           <%-- <div id="div1" style="background: #ff0000; height: 300px" runat="server">
            </div>
            <div id="main" style="width: auto; height: 400px;" runat="server">
            </div>
            <div id="div2" style="background: #ffd800; height: 200px" runat="server">
            </div>--%>
            <div id="AuthorDiv" style="position: relative" runat="server">
                <label style="position: absolute; right: 0">Powerd By Aladdin 2022/4/24</label>
            </div>
        </div>
    </form>
    <script type="text/javascript">
        // 基于准备好的dom，初始化echarts实例
        var myChart = echarts.init(document.getElementById('main'));

        // 指定图表的配置项和数据
        var option = {
            title: {
                text: '第一个 ECharts 实例'
            },
            tooltip: {},
            legend: {
                data: ['销量']
            },
            xAxis: {
                data: ["衬衫", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子"]
            },
            yAxis: {},
            series: [{
                name: '销量',
                type: 'bar',
                data: [5, 20, 36, 10, 10, 20]
            }]
        };

        // 使用刚指定的配置项和数据显示图表。
        myChart.setOption(option);
    </script>
</body>
</html>
