using MongoDB.Bson;

namespace MonitorToolSystem.Models
{
    public class TestModel
    {
        public ObjectId _id { get; set; }
        public string PackageId { get; set; }
        public string TestTime { get; set; }
    }
}