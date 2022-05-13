namespace MonitorToolSystem.Common
{
    public class ConstString
    {
        public const string BinaryExt = ".data";
        public const string TextExt = ".txt";
        public const string CSVExt = ".csv";
        public const string ZIPExt = ".zip";

        //文件前缀
        public const string LogPrefix = "log_";
        public const string DevicePrefix = "device_";
        public const string TestPrefix = "test_";
        public const string MonitorPrefix = "monitor_";
        //函数性能分析
        public const string FuncAnalysisPrefix = "funcAnalysis_";
        //函数规划范分析
        public const string FuncCodeAnalysisPrefix = "funcCodeAnalysis_";
        public const string PowerConsumePrefix = "powerConsume_";
        public const string CapturePrefix = "captureFrame_";
        //渲染信息
        public const string RenderPrefix = "renderInfo_";
    }
    public class Config
    {
        public static string RecordTextDir;
    }
}