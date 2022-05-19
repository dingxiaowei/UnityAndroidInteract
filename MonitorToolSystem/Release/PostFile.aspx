<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PostFile.aspx.cs" Inherits="MonitorToolSystem.PostFile" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>test</title>
    <script src="Modules/jquery-3.3.1.min.js"></script>
    <script src="Modules/ajaxfileupload.js"></script>
    <script type="text/javascript">
        function ajaxFileUpload() {
            $("#imgLoading").ajaxStart(function () {
                $(this).show();
            }).ajaxComplete(function () {
                $(this).hide();
            });

            $.ajaxFileUpload({
                url: 'PostFileHandler.ashx',                    //后台处理页面路径
                secureuri: false,                    //是否对上传的文件加密
                fileElementId: 'fileToUpload',       //上传控件id
                dataType: 'json',                   //返回格式
                success: function (r, status) {	//成功回调函数	
                    if (r.Success) {
                        alert("导入成功!文件长度：" + r.OtherInfo);
                    } else {
                        alert("导入失败，原因：" + r.ErrMsg);
                    }
                },
                error: function (data, status, e) {  //失败回调函数
                    alert(e);
                }
            });
        }
    </script>
</head>
<body>
    <form id="dcForm" action="PostFileHandler.ashx" method="post" autocomplete="off" runat="server">
        <div class="content_panel">
            <div class="box_panel">
                <table class="field_panel" style="border: solid 1px black; border-collapse: collapse;">
                    <tr class="field_panel_header">
                        <td colspan="2" id="tdTitle">上传文件</td>
                    </tr>
                    <tr>
                        <td class="field_panel_field">选择上传文件：</td>
                        <td class="field_panel_value">
                            <input id="fileToUpload" type="file" size="45" name="fileToUpload" />
                            <img src="img/loading.gif" alt="" id="imgLoading" style="display: none; width: 20px; vertical-align: middle; padding-bottom: 2px;" />
                        </td>
                    </tr>
                    <tr class="field_panel_foot">
                        <td colspan="2" align="center">
                            <input type="button" onclick="ajaxFileUpload()" value="上传" class="btn" />
                            <input type="button" id="btn_Return" value="返回" class="btn" onclick="onReturn()" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>
