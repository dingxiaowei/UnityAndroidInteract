namespace MonitorToolSystem
{
    public struct FuncAnalysisInfo
    {
        public string Name;
        //k
        public double Memory;
        //k
        public double AverageMemory;
        //s
        public float UseTime;
        /// <summary>
        /// 平均调用时间ms
        /// </summary>
        public float AverageTime;
        /// <summary>
        /// 调用次数
        /// </summary>
        public int Calls;
    }
}