using MonitorToolSystem.Common;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;

namespace MonitorToolSystem
{
    /// <summary>
    /// LogHandler 的摘要说明
    /// </summary>
    public class LogHandler : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            var packageName = context.Request["PackageName"];
            var testTime = context.Request["TestTime"];
            var pageNumStr = context.Request["PageNum"];
            var pageIndexStr = context.Request["PageIndex"];
            var msgType = context.Request["MsgType"];
            if (string.IsNullOrEmpty(packageName) || string.IsNullOrEmpty(testTime) || string.IsNullOrEmpty(pageIndexStr) || string.IsNullOrEmpty(pageNumStr) || string.IsNullOrEmpty(msgType))
            {
                context.Response.Write($"error:packageName:{packageName} error  or testTime:{testTime} error or pageNum:{pageNumStr} error or PageIndex:{pageIndexStr} error");
            }
            else
            {
                int pageNum = Convert.ToInt32(pageNumStr);
                int pageIndex = Convert.ToInt32(pageIndexStr);
                var basePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Texts/");
                var txt = Path.Combine(basePath, $"{ConstString.LogPrefix}{testTime}{ConstString.TextExt}");
                if (!File.Exists(txt))
                {
                    context.Response.Write($"error:TestInfo:{txt}不存在");
                }
                else
                {
                    var str = FileManager.ReadAllByLine(txt);
                    var strArrays = str.Replace("[20", "~[20").Split('~');
                    int beginIndex = pageNum * pageIndex;
                    StringBuilder sb = new StringBuilder();
                    if (msgType.Equals("allMsg"))
                    {
                        int endIndex = (strArrays.Length <= (pageIndex + 1) * pageNum) ? strArrays.Length : ((pageIndex + 1) * pageNum);
                        if (beginIndex <= strArrays.Length)
                        {
                            for (int i = beginIndex; i <= endIndex; i++)
                                sb.AppendLine(strArrays[i]);
                            context.Response.Write($"{sb.ToString()}");
                        }
                        else
                        {
                            context.Response.Write("没有Log数据了");
                        }
                    }
                    else //errorMsg
                    {
                        //从头开始遍历，直到满足个数或者说到最后一个记录
                        int count = 0;
                        int collectCount = 0;
                        for (int i = 0; i < strArrays.Length; i++)
                        {
                            if (strArrays[i].Contains("[Error]"))
                            {
                                count++;
                                if (collectCount > pageNum)
                                    break;
                                if (count >= beginIndex + 1)
                                {
                                    sb.Append(strArrays[i]);
                                    collectCount++;
                                }
                            }
                        }
                        if(collectCount > 0)
                        {
                            context.Response.Write($"{sb.ToString()}");
                        }
                        else
                        {
                            context.Response.Write("没有Error数据了");
                        }
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