using System.IO;
using System.Web;

namespace MonitorToolSystem
{
    /// <summary>
    /// TestHandler 的摘要说明
    /// </summary>
    public class TestHandler : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string name = context.Request.Form["testcase_name"];
            HttpPostedFile file = context.Request.Files["folder"];
            if (file == null) return;
            string uploadDir = HttpContext.Current.Server.MapPath("~\\Upload");
            if (!Directory.Exists(uploadDir))
            {
                Directory.CreateDirectory(uploadDir);
            }
            string path = Path.Combine(uploadDir, $"{name}\\");
            //判断路径是否存在
            if (!Directory.Exists(path))
            {
                //如果不存在就创建
                Directory.CreateDirectory(path);
            }
            file.SaveAs(path + name + $"{file.FileName}");
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