using MonitorToolSystem.Common;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace MonitorToolSystem
{
    /// <summary>
    /// RenderHandler 的摘要说明
    /// </summary>
    public class RenderHandler : IHttpHandler
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
                var renderInfo = Path.Combine(basePath, $"{ConstString.RenderPrefix}{testTime}{ConstString.TextExt}");
                if (!File.Exists(renderInfo))
                {
                    context.Response.Write($"error:RenderInfo:{renderInfo}不存在");
                }
                else
                {
                    var jsonStr = FileManager.ReadAllByLine(renderInfo);
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