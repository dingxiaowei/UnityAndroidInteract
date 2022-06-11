using MonitorToolSystem.Common;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace MonitorToolSystem
{
    /// <summary>
    /// PowerConsumeHandler 的摘要说明
    /// </summary>
    public class PowerConsumeHandler : IHttpHandler
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
                var txt = Path.Combine(basePath, $"{ConstString.PowerConsumePrefix}{testTime}{ConstString.TextExt}");
                if (!File.Exists(txt))
                {
                    context.Response.Write($"error:PowerConsumeInfo:{txt}不存在");
                }
                else
                {
                    var jsonStr = FileManager.ReadAllByLine(txt);
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