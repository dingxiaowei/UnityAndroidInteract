using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MonitorToolSystem
{
    /// <summary>
    /// TestNetHandler 的摘要说明
    /// </summary>
    public class TestNetHandler : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            var num = context.Request["num"];
            var str = context.Request["str"];
            if (string.IsNullOrEmpty(num) || string.IsNullOrEmpty(str))
            {
                context.Response.Write("没有传入num或者str");
            }
            else
            {
                context.Response.Write($"num:{num} str:{str}");
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