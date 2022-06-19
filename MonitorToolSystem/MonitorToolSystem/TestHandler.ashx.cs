using System.IO;
using System.Web;

namespace MonitorToolSystem
{
    /// <summary>
    /// 测试上传文件(大文件目前有问题)
    /// </summary>
    public class TestHandler : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string testCaseName = context.Request.Form["testcaseName"];
            string fileName = context.Request.Form["fileName"];
            HttpPostedFile file = context.Request.Files["folder"];
            if (file == null) return;
            string uploadDir = HttpContext.Current.Server.MapPath("~\\Upload");
            if (!Directory.Exists(uploadDir))
            {
                Directory.CreateDirectory(uploadDir);
            }
            string path = Path.Combine(uploadDir, $"{testCaseName}\\");
            //判断路径是否存在
            if (!Directory.Exists(path))
            {
                //如果不存在就创建
                Directory.CreateDirectory(path);
            }
            file.SaveAs($"{path}\\{fileName}");
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