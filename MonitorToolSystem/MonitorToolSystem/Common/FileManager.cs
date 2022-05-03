using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Text;

namespace MonitorToolSystem.Common
{
    /// <summary>
    /// 文件操作类
    /// </summary>
    public class FileManager
    {
        public static bool CreateDir(string dirPath)
        {
            if (string.IsNullOrEmpty(dirPath))
                return false;
            if (Directory.Exists(dirPath))
            {
                Directory.Delete(dirPath, true);
            }
            Directory.CreateDirectory(dirPath);
            return true;
        }

        public static bool WriteBytesToFile(string filePath, byte[] data)
        {
            if (string.IsNullOrEmpty(filePath))
                return false;
            if (File.Exists(filePath))
            {
                File.Delete(filePath);
            }
            var file = new FileInfo(filePath);
            using (Stream sw = file.Create())
            {
                sw.Write(data, 0, data.Length);
                sw.Flush();
                sw.Close();
            }
            return true;
        }

        /// <summary>
        /// 将字符串写入文件
        /// </summary>
        /// <param name="filePath"></param>
        /// <param name="context"></param>
        /// <returns></returns>
        public static bool WriteToFile(string filePath, string context)
        {
            return WriteToFile(filePath, context, Encoding.Default);
        }

        public static bool WriteToFile(string filePath, string context, Encoding encoding)
        {
            if (string.IsNullOrEmpty(filePath))
                return false;
            if (File.Exists(filePath))
            {
                File.Delete(filePath);
            }
            using (FileStream fs = new FileStream(filePath, FileMode.Create))
            {
                var data = encoding.GetBytes(context);
                fs.Write(data, 0, data.Length);
                fs.Flush();
                fs.Close();
            }
            return true;
        }

        /// <summary>
        /// 按行读取
        /// </summary>
        /// <param name="path"></param>
        /// <returns></returns>
        public static string ReadAllByLine(string path)
        {
            StringBuilder sb = new StringBuilder();
            using (StreamReader sr = new StreamReader(path, Encoding.UTF8))
            {
                string line;
                while ((line = sr.ReadLine()) != null)
                {
                    sb.AppendLine(line);
                }
                sr.Close();
            }
            return sb.ToString();
        }

        public static List<string> ReadAllLines(string path)
        {
            List<string> datas = new List<string>();
            using (StreamReader sr = new StreamReader(path, Encoding.Default))
            {
                string line;
                while ((line = sr.ReadLine()) != null)
                {
                    datas.Add(line);
                }
                sr.Close();
            }
            return datas;
        }

        /// <summary>
        /// 修改文件内容
        /// </summary>
        /// <param name="path"></param>
        /// <param name="normalStr"></param>
        /// <param name="newStr"></param>
        public static void ReplaceContent(string path, string normalStr, string newStr)
        {
            if (string.IsNullOrEmpty(path) || !File.Exists(path))
            {
                return;
            }
            string strContent = File.ReadAllText(path);
            strContent = strContent.Replace(normalStr, newStr);
            File.WriteAllText(path, strContent);
        }

        /// <summary>
        /// 批量修改文件内容
        /// </summary>
        /// <param name="path"></param>
        /// <param name="newStr"></param>
        /// <param name="normalStrs"></param>
        public static void ReplaceContent(string path, string newStr, params string[] normalStrs)
        {
            if (string.IsNullOrEmpty(path) || !File.Exists(path))
            {
                return;
            }
            string strContent = File.ReadAllText(path);
            for (int i = 0; i < normalStrs.Length; i++)
            {
                strContent = strContent.Replace(normalStrs[i], newStr);
            }
            File.WriteAllText(path, strContent);
        }

        public static void ReadLastLine(string fileName)
        {
            using (FileStream fs = new FileStream(fileName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
            using (StreamReader sr = new StreamReader(fs))
            {
                // 读取首行
                string line = sr.ReadLine();

                // 读取末行
                line = GetLastLine(fs);
                sr.Close();
                fs.Close();
            }
        }

        /// <summary>
        /// 提取文本最后一行数据
        /// </summary>
        /// <param name="fs">文件流</param>
        /// <returns>最后一行数据</returns>
        private static string GetLastLine(FileStream fs)
        {
            int seekLength = (int)(fs.Length < 1024 ? fs.Length : 1024);  // 这里需要根据自己的数据长度进行调整，也可写成动态获取，可自己实现
            byte[] buffer = new byte[seekLength];
            fs.Seek(-buffer.Length, SeekOrigin.End);
            fs.Read(buffer, 0, buffer.Length);
            string multLine = System.Text.Encoding.UTF8.GetString(buffer);
            string[] lines = multLine.Split(new string[] { "\\n" }, StringSplitOptions.RemoveEmptyEntries);
            string line = lines[lines.Length - 1];

            return line;
        }

        public static bool AppendLastLine(string fileName, string content)
        {
            if (string.IsNullOrEmpty(fileName) || string.IsNullOrEmpty(content))
            {
                return false;
            }
            if (!File.Exists(fileName))
            {
                CreateText(fileName, content);
            }
            else
            {
                using (StreamWriter sw = File.AppendText(fileName))
                {
                    sw.WriteLine(content);
                    sw.Flush();
                    sw.Close();
                }
            }
            return true;
        }

        public static void CreateText(string filePath, string content = null)
        {
            if (File.Exists(filePath))
            {
                File.Delete(filePath);
            }
            if (string.IsNullOrEmpty(content))
                File.CreateText(filePath);
            else
            {
                using (var fs = new FileStream(filePath, FileMode.Create, FileAccess.Write))
                {
                    using (var sw = new StreamWriter(fs))
                    {
                        sw.WriteLine(content);
                        sw.Flush();
                        sw.Close();
                        fs.Close();
                    }
                }
            }
        }

        public static bool ReadCSV(string filePath, out DataTable dt)
        {
            dt = new DataTable();
            if (!File.Exists(filePath))
            {
                return false;
            }
            try
            {
                Encoding encoding = Encoding.Default;
                FileStream fs = new FileStream(filePath, System.IO.FileMode.Open, System.IO.FileAccess.Read);
                StreamReader sr = new StreamReader(fs, encoding);
                //记录每次读取的一行记录
                string strLine = "";
                //记录每行记录中的各字段内容
                string[] aryLine = null;
                string[] tableHead = null;
                //标示列数
                int columnCount = 0;
                //标示是否是读取的第一行
                bool IsFirst = true;
                //逐行读取CSV中的数据
                while ((strLine = sr.ReadLine()) != null)
                {
                    if (IsFirst == true)
                    {
                        tableHead = strLine.Split(',');
                        IsFirst = false;
                        columnCount = tableHead.Length;
                        //创建列
                        for (int i = 0; i < columnCount; i++)
                        {
                            DataColumn dc = new DataColumn(tableHead[i]);
                            dt.Columns.Add(dc);
                        }
                    }
                    else
                    {
                        aryLine = strLine.Split(',');
                        DataRow dr = dt.NewRow();
                        for (int j = 0; j < columnCount; j++)
                        {
                            dr[j] = aryLine[j];
                        }
                        dt.Rows.Add(dr);
                    }
                }

                if (aryLine != null && aryLine.Length > 0)
                {
                    dt.DefaultView.Sort = tableHead[0] + " " + "asc";
                }
                sr.Close();
                fs.Close();
                sr.Dispose();
                fs.Dispose();
                return true;
            }

            catch (Exception)
            {
                return false;
            }
        }
    }
}