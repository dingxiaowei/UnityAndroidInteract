using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
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
            string id = context.Request.Form["id"];
            HttpPostedFile hfc = context.Request.Files["Photo"];
            if (hfc == null) return;

            Stream sm = hfc.InputStream;
            byte[] buffer = new byte[sm.Length];
            sm.Read(buffer, 0, buffer.Length);
            sm.Close();
            sm.Dispose();
            string uploadDir = HttpContext.Current.Server.MapPath("~\\Upload");
            if (!Directory.Exists(uploadDir))
            {
                Directory.CreateDirectory(uploadDir);
            }
            string path = Path.Combine(uploadDir, $"{id}\\");
            //判断路径是否存在
            if (!Directory.Exists(path))
            {
                //如果不存在就创建
                Directory.CreateDirectory(path);
            }
            //产生文件名
            string fileName = path + id + "_" + DateTime.Now.ToString("yyyy-MM-dd_hh-mm-ss") + "_" + DateTime.Now.Millisecond.ToString() + ".png";
            Stream flstr = new FileStream(fileName, FileMode.Create);
            BinaryWriter sw = new BinaryWriter(flstr, Encoding.Unicode);
            sw.Write(buffer);
            flstr.Close();
            sw.Close();
            sw.Dispose();
            flstr.Dispose();
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