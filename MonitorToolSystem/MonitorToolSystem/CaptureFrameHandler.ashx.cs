using MonitorToolSystem.Common;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace MonitorToolSystem
{
    /// <summary>
    /// CaptureFrameHandler 的摘要说明
    /// </summary>
    public class CaptureFrameHandler : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            var packageName = context.Request["PackageName"];
            var testTime = context.Request["TestTime"];
            var frameIndex = context.Request["FrameIndex"];
            if (string.IsNullOrEmpty(packageName) || string.IsNullOrEmpty(testTime))
            {
                context.Response.Write($"error:packageName:{packageName} error  or testTime:{testTime} error");
            }
            else
            {
                var basePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Texts/");
                var captureFilePath = Path.Combine(basePath, $"{ConstString.CapturePrefix}{testTime}");
                if (!Directory.Exists(captureFilePath))
                {
                    var zipPath = Path.Combine(basePath, $"{ConstString.CapturePrefix}{testTime}{ConstString.ZIPExt}");
                    if(!File.Exists(zipPath))
                    {
                        context.Response.Write($"error:zipPath:{zipPath}不存在");
                        return;
                    }
                    ZipUtils.UnZip(zipPath, basePath);
                }
                if (!Directory.Exists(captureFilePath))
                {
                    context.Response.Write($"error:CaptureFilePath:{captureFilePath}不存在");
                }
                else
                {
                    var imgPath = $"{captureFilePath}/img_{testTime}_{frameIndex}.png";
                    context.Response.Write($"{imgPath}");
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