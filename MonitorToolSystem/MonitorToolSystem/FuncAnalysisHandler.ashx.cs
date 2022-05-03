using MonitorToolSystem.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace MonitorToolSystem
{
    /// <summary>
    /// FuncAnalysisHandler 的摘要说明
    /// </summary>
    public class FuncAnalysisHandler : IHttpHandler
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
                var txtPath = Path.Combine(basePath, $"{ConstString.FuncAnalysisPrefix}{testTime}{ConstString.TextExt}");
                if (!File.Exists(txtPath))
                {
                    context.Response.Write($"error:txt:{txtPath}不存在");
                }
                else
                {
                    var jsonStr = FileManager.ReadAllByLine(txtPath);
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