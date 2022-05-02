using MonitorToolSystem.Common;
using System;
using System.IO;
using System.Web;

namespace MonitorToolSystem
{
    /// <summary>
    /// TestInfoHandler 的摘要说明
    /// </summary>
    public class TestInfoHandler : IHttpHandler
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
                var txt = Path.Combine(basePath, $"{ConstString.TestPrefix}{testTime}{ConstString.TextExt}");
                if (!File.Exists(txt))
                {
                    context.Response.Write($"error:TestInfo:{txt}不存在");
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