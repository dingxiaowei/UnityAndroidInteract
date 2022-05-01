using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MonitorToolSystem
{
    public partial class Index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //首次加载
            if (!IsPostBack)
            {
                //TODO:这里添加时间
                this.ddlPackageNameList.Items.Add(new ListItem("com.aladdin.test"));
                this.ddlReportTimeList.Items.Add(new ListItem("2022_4_13_12_43_50"));
                this.ddlReportTimeList.Items.Add(new ListItem("2022_4_26_12_43_50"));
                //this.AuthorDiv.Style["display"] = "none";//不可见
                //this.div2.Style["display"] = "none";
                this.RecordListModule.Style["display"] = "none";
            }
            else
            {
                //要显示新增的，读取对应项目txt看看是否有新增，如果有的话则追加
                //this.reportList.Items.Add(new ListItem("2022_4_25_12_43_50"));
                //this.AuthorDiv.Style["display"] = "block";//可见
                //this.div1.Style["display"] = "none";
                //this.div2.Style["display"] = "block";
            }
            this.ddlReportTimeList.SelectedIndexChanged += OnReportListValueChanged;
        }

        void OnReportListValueChanged(object sender, EventArgs e)
        {
            //Response.Write("<script>alert('" + this.reportList.SelectedValue + "')</script>");
        }
    }
}