using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace JSONStudy
{
    class Program
    {
        public static void Main(string[] args)
        {
            LINQ2JSON.QueryOperation();

            Console.ReadLine();
        }

        public static void TestJsonConvert()
        {
            Product product = new Product();
            
            product.Name = "Apple";
            product.ExpireDate = new DateTime(2016, 8, 24);
            product.Price = 3.99;
            product.Sizes = new string[] { "Small", "Medium", "Large" };

            string output = JsonConvert.SerializeObject(product, Newtonsoft.Json.Formatting.Indented);

            Console.WriteLine(output);

            Product p = JsonConvert.DeserializeObject<Product>(output);
        }

        
        public static void TestSerializationCallback()
        {
            SerializationEventTestObject obj = new SerializationEventTestObject();

            Console.WriteLine(obj.Member1);
            // 11
            Console.WriteLine(obj.Member2);
            // Hello World!
            Console.WriteLine(obj.Member3);
            // This is a nonserialized value
            Console.WriteLine(obj.Member4);
            // null

            string json = JsonConvert.SerializeObject(obj, Newtonsoft.Json.Formatting.Indented);
            // {
            //   "Member1": 11,
            //   "Member2": "This value went into the data file during serialization.",
            //   "Member4": null
            // }

            Console.WriteLine(obj.Member1);
            // 11
            Console.WriteLine(obj.Member2);
            // This value was reset after serialization.
            Console.WriteLine(obj.Member3);
            // This is a nonserialized value
            Console.WriteLine(obj.Member4);
            // null

            obj = JsonConvert.DeserializeObject<SerializationEventTestObject>(json);

            Console.WriteLine(obj.Member1);
            // 11
            Console.WriteLine(obj.Member2);
            // This value went into the data file during serialization.
            Console.WriteLine(obj.Member3);
            // This value was set during deserialization
            Console.WriteLine(obj.Member4);
            // This value was set after deserialization.
        }

        public static void SerializeCollection()
        {
            List<string> videogames = new List<string>
            {
                "Starcraft", "Halo", "Legend of Zelda"
            };
            string json = JsonConvert.SerializeObject(videogames);

            Console.WriteLine(json);
        }

        public static void TestSerializeCollection()
        {
            Product p1 = new Product("Product 1", 99.95, new DateTime(2000, 12, 29, 0, 0, 0, DateTimeKind.Utc));
            Product p2 = new Product("Product 2", 12.50, new DateTime(2009, 7, 31, 0, 0, 0, DateTimeKind.Utc));

            List<Product> products = new List<Product>();
            products.Add(p1);
            products.Add(p2);

            string json = JsonConvert.SerializeObject(products, Newtonsoft.Json.Formatting.Indented);

            Console.WriteLine(json);
        }

        public static void TestDesrializeCollection()
        {
            string json = @"[
             {
                'Name': 'Product 1',
                'ExpireDate': '2000-12-29T00:00:00Z',
                'Price': 99.95,
                'Sizes': null
             },
             {
                'Name': 'Product 2',
                'ExpireDate': '2009-07-31T00:00:00Z',
                'Price': 12.5,
                'Sizes': null
             }]";

            List<Product> product = JsonConvert.DeserializeObject<List<Product>>(json);

            Console.WriteLine(String.Format("Count of product list:{0}", product.Count));

            Product p1 = product[1];

            Console.WriteLine(p1.Name);
        }

        public static void TestJsonSerializer()
        {
            Product product = new Product();
            product.ExpireDate = new DateTime(2016, 8, 24);

            JsonSerializer serializer = new JsonSerializer();
            serializer.NullValueHandling = NullValueHandling.Ignore;

            using(StreamWriter sw = new StreamWriter(@"E:\json.txt"))
            using (JsonWriter writer = new JsonTextWriter(sw))
            {
                serializer.Serialize(writer, product);
            }

            Console.WriteLine("Done.");
        }

        public static void TestDeserializeList()
        {
            string json = @"['Starcraft','Halo','Legend of Zelda']";

            List<string> video_games = JsonConvert.DeserializeObject<List<string>>(json);

            Console.WriteLine(string.Join(",", video_games.ToArray()));
        }

        public static void TestDeserilizeDictionary()
        {
            string json = @"{""key1"":""value1"",""key2"":""value2""}";

            Dictionary<string, string> dict = JsonConvert.DeserializeObject<Dictionary<string,string>>(json);

            foreach (KeyValuePair<string, string> kv in dict)
            {
                Console.WriteLine(String.Format("{0}={1}", kv.Key, kv.Value));
            }
        }

        public static void TestConvertXml2Json()
        {
            string xml = @"<?xml version='1.0' standalone='no'?>
                        <root>
                        <person id='1'>
                            <name>Alan</name>
                            <url>http://www.google.com</url>
                        </person>
                        <person id='2'>
                            <name>Louis</name>
                            <url>http://www.yahoo.com</url>
                        </person>
                        </root>";

            XmlDocument doc = new XmlDocument();
            doc.LoadXml(xml);

            string jsonTxt = JsonConvert.SerializeXmlNode(doc, Newtonsoft.Json.Formatting.Indented);

            Console.WriteLine(jsonTxt);
        }

        public static void TestLINQ2JSON_ParseJsonText()
        {
            string json = @"{
            CPU: 'Intel',
            Drives: [
                'DVD read/writer',
                ' gigabyte hard drive'
                ]
            }";

            JObject o = JObject.Parse(json);
        }

        public static void TestLINQ2JSON_CreateJsonFromObj()
        {
            JObject o = JObject.FromObject(new Product("Product 1", 99.95, new DateTime(2000, 12, 29, 0, 0, 0, DateTimeKind.Utc)));

            Console.WriteLine(o.ToString());
        }

        public static void TestLINQ2JSON_ParseJson()
        {
            JObject o = JObject.Parse(@"{
                'CPU': 'Intel',
                'Drives': [
                    'DVD read/writer',
                    '500 gigabyte hard drive'
            ]}");

            string cpu = (string)o["CPU"];
            // Intel

            string firstDrive = (string)o["Drives"][0];
            // DVD read/writer

            IList<string> allDrives = o["Drives"].Select(t => (string)t).ToList();
            // DVD read/writer
            // 500 gigabyte hard drive
        }

        public static void TestLINQ2JSON_CreateJson()
        {
            JArray array = new JArray();
            JValue text = new JValue("Manual text");
            JValue date = new JValue(new DateTime(2000, 5, 23));

            array.Add(text);
            array.Add(date);

            string json = array.ToString();

            Console.WriteLine(json);
        }
    }
}
