using MonitorToolSystem.Common;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;

namespace MonitorToolSystem
{
    /// <summary>
    /// LogHandler 的摘要说明
    /// </summary>
    public class LogHandler : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            var packageName = context.Request["PackageName"];
            var testTime = context.Request["TestTime"];
            var pageNumStr = context.Request["PageNum"];
            var pageIndexStr = context.Request["PageIndex"];
            if (string.IsNullOrEmpty(packageName) || string.IsNullOrEmpty(testTime) || string.IsNullOrEmpty(pageIndexStr) || string.IsNullOrEmpty(pageNumStr))
            {
                context.Response.Write($"error:packageName:{packageName} error  or testTime:{testTime} error or pageNum:{pageNumStr} error or PageIndex:{pageIndexStr} error");
            }
            else
            {
                int pageNum = Convert.ToInt32(pageNumStr);
                int pageIndex = Convert.ToInt32(pageIndexStr);
                var basePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Texts/");
                var txt = Path.Combine(basePath, $"{ConstString.LogPrefix}{testTime}{ConstString.TextExt}");
                if (!File.Exists(txt))
                {
                    context.Response.Write($"error:TestInfo:{txt}不存在");
                }
                else
                {
                    var str = FileManager.ReadAllByLine(txt);
                    var strArrays = str.Replace("[20", "~[20").Split('~');
                    int beginIndex = pageNum * pageIndex;
                    if (beginIndex <= strArrays.Length)
                    {
                        int endIndex = (strArrays.Length <= (pageIndex + 1) * pageNum) ? strArrays.Length : ((pageIndex + 1) * pageNum);
                        StringBuilder sb = new StringBuilder();
                        for (int i = beginIndex; i <= endIndex; i++)
                            sb.AppendLine(strArrays[i]);
                        context.Response.Write($"{sb.ToString()}");
                    }
                    else
                    {
                        context.Response.Write("没有Log数据了");
                    }
                }
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}