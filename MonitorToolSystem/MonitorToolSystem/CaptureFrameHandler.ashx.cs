using MonitorToolSystem.Common;
using MonitorToolSystem.Models;
using Newtonsoft.Json;
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
                    if (!File.Exists(zipPath))
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
                    try
                    {
                        int framIndex = Convert.ToInt32(frameIndex);
                        if (framIndex < 0)
                        {
                            context.Response.Write($"error:传入的FrameIndex小于0");
                        }
                        else
                        {
                            var txtInfo = Path.Combine(basePath, $"{ConstString.TestPrefix}{testTime}{ConstString.TextExt}");
                            if (!File.Exists(txtInfo))
                            {
                                context.Response.Write($"error:TestInfo:{txtInfo}不存在");
                            }
                            else
                            {
                                var jsonStr = FileManager.ReadAllByLine(txtInfo);
                                var testInfoObj = JsonConvert.DeserializeObject<TestInfo>(jsonStr);
                                var intervalFrame = testInfoObj.IntervalFrame;
                                //获取测试的间隔帧数，如果没有就默认100
                                framIndex = (framIndex / intervalFrame + 1) * intervalFrame;
                                var imgPath = $"{captureFilePath}/img_{testTime}_{framIndex}.png";
                                if (File.Exists(imgPath))
                                {
                                    imgPath = imgPath.Replace('\\', '/');
                                    var returnPath = imgPath.Substring(imgPath.IndexOf("/Texts/"));
                                    context.Response.Write($".{returnPath}");
                                }
                                else
                                {
                                    context.Response.Write($"error:帧图不存在{imgPath}");
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        context.Response.Write($"error:{ex}");
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