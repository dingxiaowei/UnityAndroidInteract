using MonitorToolSystem.Common;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace MonitorToolSystem
{
    /// <summary>
    /// MonitorHandler 的摘要说明
    /// </summary>
    public class MonitorHandler : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            var packageName = context.Request["PackageName"];
            var testTime = context.Request["TestTime"];
            if (string.IsNullOrEmpty(packageName) || string.IsNullOrEmpty(testTime))
            {
                context.Response.Write($"error:packageName:{packageName} error  or testTime:{testTime} error");
            }
            else
            {
                var basePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Texts/");
                var monitorInfo = Path.Combine(basePath, $"{ConstString.MonitorPrefix}{testTime}{ConstString.TextExt}");
                if (!File.Exists(monitorInfo))
                {
                    context.Response.Write($"error:MonitorInfo:{monitorInfo}不存在");
                }
                else
                {
                    var jsonStr = FileManager.ReadAllByLine(monitorInfo);
                    context.Response.Write($"{jsonStr}");
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