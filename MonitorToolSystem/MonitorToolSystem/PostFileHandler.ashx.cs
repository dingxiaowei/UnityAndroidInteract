using System;
using System.IO;
using System.Web;

namespace MonitorToolSystem
{
    public class Result
    {
        /// <summary>
        /// 无参构造函数. Success属性初始值默认为true, DefaultErrMsg初始默认为 '发生错误，请联系系统管理员！'
        /// </summary>
        public Result()
        {
            this.Success = true;
            this.DefaultErrMsg = "发生错误，请联系系统管理员！";
        }

        /// <summary>
        /// 返回结果是否为成功
        /// </summary>
        public bool Success { get; set; }

        /// <summary>
        /// 错误信息
        /// </summary>
        public string ErrMsg { get; set; }

        /// <summary>
        /// 缺省错误信息( "发生错误，请联系系统管理员！" )
        /// </summary>
        public string DefaultErrMsg { get; set; }

        /// <summary>
        /// 其它信息
        /// </summary>
        public string OtherInfo { get; set; }

        /// <summary>
        /// 插入或者更新时的主键
        /// </summary>
        public string PkId { get; set; }

        /// <summary>
        /// 对象，用于扩展（任意情况）
        /// </summary>
        public Object ExtInfo { get; set; }
    }
    /// <summary>
    /// PostFileHandler 的摘要说明
    /// </summary>
    public class PostFileHandler : IHttpHandler
    {
        #region [ 属性 ]
        public HttpRequest Request
        {
            get
            {
                return HttpContext.Current.Request;
            }
        }

        public HttpServerUtility Server
        {
            get
            {
                return HttpContext.Current.Server;
            }
        }
        #endregion

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string json = string.Empty;
            Result r = new Result();
            r.Success = false;
            r.ErrMsg = "没有上传文件";

            try
            {
                if (Request.Files.Count > 0)
                {
                    HttpPostedFile file = Request.Files[0];
                    if (file.ContentLength == 0)
                    {
                        r.Success = false;
                        r.ErrMsg = "文件长度为0";
                    }
                    else
                    {
                        r.OtherInfo = file.ContentLength.ToString();
                        string uploadDir = Server.MapPath("~\\Upload");
                        if (!Directory.Exists(uploadDir))
                        {
                            Directory.CreateDirectory(uploadDir);
                        }

                        string filePath = Path.Combine(uploadDir, Path.GetFileName(file.FileName));
                        if (File.Exists(filePath))
                        {
                            try
                            {
                                File.Delete(filePath);
                            }
                            catch (Exception ex)
                            {
                                System.Threading.Thread.Sleep(1000);
                                filePath = Path.Combine(uploadDir, DateTime.Now.ToString("yyyy-MM-dd_HHmmss_") + Path.GetFileName(file.FileName));
                            }
                        }

                        file.SaveAs(filePath);
                        r.Success = true;
                    }
                }
            }
            catch (Exception ex)
            {
                r.Success = false;
                r.ErrMsg = ex.Message;
            }

            //输出结果json
            json = Newtonsoft.Json.JsonConvert.SerializeObject(r);
            context.Response.Write(json);
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