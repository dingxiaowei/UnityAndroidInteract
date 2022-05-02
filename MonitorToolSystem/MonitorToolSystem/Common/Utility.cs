using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace MonitorToolSystem.Common
{
    public class Utility
    {
        private static readonly MD5 md5 = MD5.Create();
        public static string GetMD5Hash(string input)
        {
            var data = md5.ComputeHash(Encoding.UTF8.GetBytes(input));
            return ToHash(data);
        }

        public static string GetMD5ByFile(string filePath)
        {
            FileStream stream = new FileStream(filePath, FileMode.Open, FileAccess.Read, FileShare.Read);
            return GetMD5Hash(stream);
        }

        public static string GetMD5Hash(Stream input)
        {
            var data = md5.ComputeHash(input);
            input.Close();
            input.Dispose();
            return ToHash(data);
        }

        public static bool VerifyMd5Hash(string input, string hash)
        {
            var comparer = StringComparer.OrdinalIgnoreCase;
            return 0 == comparer.Compare(input, hash);
        }

        private static string ToHash(byte[] data)
        {
            var sb = new StringBuilder();
            foreach (var t in data)
                sb.Append(t.ToString("x2"));
            return sb.ToString();
        }
    }
}