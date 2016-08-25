using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace JSONStudy
{
    class SerializationEventTestObject
    {
        public int Member1 {get;set;}
        public string Member2 {get;set;}
        public string Member3 {get;set;}
            
        [JsonIgnore]
        public string Member4 {get;set;}

        public SerializationEventTestObject()
        {
            Member1 = 11;
            Member2 = "Hello World!";
            Member3 = "This is a nonserialized value";
            Member4 = null;
        }

        [OnSerializing]
        internal void OnSerializingMethod(StreamingContext context)
        {
            Member2 = "This value went into the data file during serialization.";
        }

        [OnSerialized]
        internal void OnSerializedMethod(StreamingContext context)
        {
            Member2 = "This value was reset after serialization.";
        }

        [OnDeserializing]
        internal void OnDeserializingMethod(StreamingContext context)
        {
            Member3 = "This value was set during deserialization";
        }

        [OnDeserialized]
        internal void OnDeserializedMethod(StreamingContext context)
        {
            Member4 = "This value was set after deserialization.";
        }
    }
}
