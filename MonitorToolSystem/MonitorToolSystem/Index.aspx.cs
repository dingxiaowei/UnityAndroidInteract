using MonitorToolSystem.Common;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MonitorToolSystem
{
    public partial class Index : System.Web.UI.Page
    {
        string txtDir = "";
        string recordsDir = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            //string packageMd5 = "";
            string baseDir = AppDomain.CurrentDomain.BaseDirectory;
            txtDir = Path.Combine(baseDir, "Texts/");
            recordsDir = Path.Combine(txtDir, "Records/");
            DirectoryInfo dirInfo = new DirectoryInfo(recordsDir);
            //首次加载
            if (!IsPostBack)
            {
                //this.AuthorDiv.Style["display"] = "none";//不可见
                //this.div2.Style["display"] = "none";
                //this.RecordListModule.Style["display"] = "none";

                //获取当前目录下Texts/Records下所有的文件
                var txtFileInfos = dirInfo.GetFiles();
                this.ddlPackageNameList.Items.Clear();
                foreach (var info in txtFileInfos)
                {
                    var fileName = info.Name.Remove(info.Name.Length - 4, 4);
                    this.ddlPackageNameList.Items.Add(new ListItem(fileName)); //包名
                    //this.ddlPackageNameList.SelectedValue = (string)Session["selectedpackage"];
                    ViewState[fileName] = Utility.GetMD5ByFile(info.FullName); //记录md5
                }
            }
            else
            {
                //要显示新增的，读取对应项目txt看看是否有新增，如果有的话则追加
                //this.reportList.Items.Add(new ListItem("2022_4_25_12_43_50"));
                //this.AuthorDiv.Style["display"] = "block";//可见
                //this.div1.Style["display"] = "none";
                //this.div2.Style["display"] = "block";
            }
            this.ddlPackageNameList.SelectedIndexChanged += OnPackageNameListValueChanged;
            this.ddlReportTimeList.SelectedIndexChanged += OnReportTimeListValueChanged;
        }

        void OnReportTimeListValueChanged(object sender, EventArgs e)
        {
            //Response.Write("<script>alert('" + this.ddlReportTimeList.SelectedValue + "')</script>");
        }

        void OnPackageNameListValueChanged(object sender, EventArgs e)
        {
            //Response.Write("<script>alert('" + this.ddlPackageNameList.SelectedValue + "')</script>");
            OnPackageNameListSelected(this.ddlPackageNameList.SelectedValue);
            Session["selectedpackage"] = this.ddlPackageNameList.SelectedValue;
        }

        void OnPackageNameListSelected(string selectValue)
        {
            var records = FileManager.ReadAllLines(Path.Combine(recordsDir, $"{selectValue}.txt"));
            this.ddlReportTimeList.Items.Clear();
            foreach (var record in records)
            {
                this.ddlReportTimeList.Items.Add(new ListItem(record));
            }
        }

        protected void ddlPackageNameList_Load(object sender, EventArgs e)
        {
            //Response.Write("<script>alert('" + this.ddlPackageNameList.SelectedValue + "')</script>");
            var fileMd5 = Utility.GetMD5ByFile(Path.Combine(recordsDir, $"{ddlPackageNameList.SelectedValue}.txt"));
            if (ddlReportTimeList.Items.Count == 0 || !ViewState[ddlPackageNameList.SelectedValue].Equals(fileMd5))
            {
                OnPackageNameListSelected(ddlPackageNameList.SelectedValue);
            }
        }

        protected void ddlReportTimeList_Load(object sender, EventArgs e)
        {
            Session["selectedtime"] = this.ddlReportTimeList.SelectedValue;
        }
    }
}