using MonitorToolSystem.Common;
using System;
using System.IO;
using System.Web;

namespace MonitorToolSystem
{
    /// <summary>
    /// ReceiveDataHandler 的摘要说明
    /// </summary>
    public class ReceiveDataHandler : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            var packageName = context.Request["PackageName"];
            var testTime = context.Request["TestTime"];
            if (string.IsNullOrEmpty(packageName) || string.IsNullOrEmpty(testTime))
            {
                Console.WriteLine("传入包名和测试时间");
                context.Response.Write("false");
                return;
            }
            //查看本地是否有对应的txt，如果没有则创建，如果有则新增时间
            if (string.IsNullOrEmpty(Config.RecordTextDir))
            {
                Config.RecordTextDir = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Texts/Records/");
                if (!Directory.Exists(Config.RecordTextDir))
                {
                    Directory.CreateDirectory(Config.RecordTextDir);
                }
            }
            var packageFile = Path.Combine(Config.RecordTextDir, $"{packageName}.txt");
            if (!File.Exists(packageFile))
            {
                FileManager.CreateText(packageFile, testTime);
            }
            else
            {
                FileManager.AppendLastLine(packageFile, testTime);
            }
            context.Response.Write("success");
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