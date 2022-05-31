using MonitorToolSystem.Common;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace MonitorToolSystem.Texts
{
    /// <summary>
    /// FrameRateHandler 的摘要说明
    /// </summary>
    public class FrameRateHandler : IHttpHandler
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
                var text = Path.Combine(basePath, $"{ConstString.FrameRatePrefix}{testTime}{ConstString.TextExt}");
                if (!File.Exists(text))
                {
                    context.Response.Write($"error:FrameRateInfo:{text}不存在");
                }
                else
                {
                    var jsonStr = FileManager.ReadAllByLine(text);
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