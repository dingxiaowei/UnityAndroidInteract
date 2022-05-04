using System.Collections.Generic;

namespace MonitorToolSystem
{
    public class VersionSpanModel
    {
        public int First { get; set; }
        public int Last { get; set; }
    }

    public class CodeInfoModel
    {
        public string Id { get; set; }
        public string Message { get; set; }
        public string FileName { get; set; }
        public int LineNumber { get; set; }
        public int CharacterPosition { get; set; }
        public int Severity { get; set; }
        public VersionSpanModel VersionSpan { get; set; }
    }

    public class FuncCodeInfoModel
    {
        public string File { get; set; }
        public string Date { get; set; }
        public List<CodeInfoModel> Diagnostics { get; set; }
        public object Exceptions { get; set; }
    }

    public struct FuncCodeAnalysisInfo
    {
        public string Id;
        public string FileName;
        public string Tip;
        public int LineNumber;
        public int CharaterPosition;
    }
}