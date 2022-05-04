using MonitorToolSystem.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Web;

namespace MonitorToolSystem
{
    /// <summary>
    /// FuncCodeAnalysisHandler 的摘要说明
    /// </summary>
    public class FuncCodeAnalysisHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            //将Json读取出来重新返回一个json列表
            var packageName = context.Request["PackageName"];
            var testTime = context.Request["TestTime"];
            if (string.IsNullOrEmpty(packageName) || string.IsNullOrEmpty(testTime))
            {
                context.Response.Write($"error:packageName:{packageName} error  or testTime:{testTime} error");
            }
            else
            {
                var basePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Texts/");
                var txtPath = Path.Combine(basePath, $"{ConstString.FuncCodeAnalysisPrefix}{testTime}{ConstString.TextExt}");
                if (!File.Exists(txtPath))
                {
                    context.Response.Write($"error:txt:{txtPath}不存在");
                }
                else
                {
                    List<FuncCodeAnalysisInfo> infos = new List<FuncCodeAnalysisInfo>();
                    var jsonStr = FileManager.ReadAllByLine(txtPath);
                    var funcCodeInfoList = JsonConvert.DeserializeObject<FuncCodeInfoModel>(jsonStr);
                    foreach (var info in funcCodeInfoList.Diagnostics)
                    {
                        infos.Add(new FuncCodeAnalysisInfo()
                        {
                            Id = info.Id,
                            FileName = info.FileName,
                            Tip = info.Message,
                            CharaterPosition = info.CharacterPosition,
                            LineNumber = info.LineNumber
                        });
                    }
                    context.Response.Write($"{JsonConvert.SerializeObject(infos)}");
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