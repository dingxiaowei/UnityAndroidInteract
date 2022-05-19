using System;
using System.IO;
using System.Web;

namespace MonitorToolSystem
{
    /// <summary>
    /// FileUpload 的摘要说明
    /// </summary>
    public class FileUpload : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            var testcase_name = context.Request["testcase_name"];
            int vals = context.Request.TotalBytes;
            var bytes = context.Request.BinaryRead(vals);
            string uploadDir = HttpContext.Current.Server.MapPath("~\\Upload");
            if (!Directory.Exists(uploadDir))
            {
                Directory.CreateDirectory(uploadDir);
            }

            FileStream fs = new FileStream(Path.Combine(uploadDir, testcase_name), FileMode.Create, FileAccess.Write);

            BinaryWriter bw = new BinaryWriter(fs);
            bw.Write(bytes);
            bw.Close();
            fs.Close();
            bw.Dispose();
            fs.Dispose();
            context.Response.Write("ok");
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