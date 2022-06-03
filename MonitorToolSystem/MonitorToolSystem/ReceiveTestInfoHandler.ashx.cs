using MonitorToolSystem.Common;
using MonitorToolSystem.Models;
using System;
using System.Web;

namespace MonitorToolSystem
{
    /// <summary>
    /// ReceiveTestInfoHandler 的摘要说明
    /// </summary>
    public class ReceiveTestInfoHandler : IHttpHandler
    {
        //接受测试的信息用MongoDB存储
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
            MongoHelper<TestModel> testInfoMongoHeaper = new MongoHelper<TestModel>("mongodb://127.0.0.1:27017", "TestModel", "TestInfos");
            //增加
            var info = testInfoMongoHeaper.Insert(new TestModel() { PackageId = packageName, TestTime = testTime });
            if (info.iFlg > 0)
                context.Response.Write("success");
            else
                context.Response.Write($"error:{info.Ex}");
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