using MonitorToolSystem.Common;
using System;
using System.IO;
using System.Web;

namespace MonitorToolSystem
{
    /// <summary>
    /// 资源内存分类数据请求
    /// </summary>
    public class ResMemoryHandler : IHttpHandler
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
                var resMemoryInfo = Path.Combine(basePath, $"{ConstString.ResMemoryDistributionPrefix}{testTime}{ConstString.TextExt}");
                if (!File.Exists(resMemoryInfo))
                {
                    context.Response.Write($"error:resMemoryInfo:{resMemoryInfo}不存在");
                }
                else
                {
                    var jsonStr = FileManager.ReadAllByLine(resMemoryInfo);
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