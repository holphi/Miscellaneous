using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JSONStudy
{
    public class LINQ2JSON
    {
        public static void CreateJObject()
        {
            JObject staff = new JObject();

            staff.Add(new JProperty("Name", "Jack"));
            staff.Add(new JProperty("Age", 33));
            staff.Add(new JProperty("Department", "Personnel Department"));
            staff.Add(new JProperty("Leader", new JObject(new JProperty("Name", "Tom"), new JProperty("Age", 44), new JProperty("Department", "Personnel Department"))));

            Console.WriteLine(staff.ToString());
        }

        public static void QueryOperation()
        { 
            string json = "{'Name' : 'Jack', 'Age' : 34, \"Colleagues\" : [{\"Name\" : \"Tom\" , \"Age\":44},{\"Name\" : \"Abel\",\"Age\":29}] }";

            JObject jObj = JObject.Parse(json);

            JToken ageToken = jObj["Age"];

            Console.WriteLine(ageToken.ToString());

            var names = from staff in jObj["Colleagues"].Children()
                        select (string)staff["Name"];

            foreach (var name in names)
                Console.WriteLine(name);

            jObj["Age"] = 35;
            Console.WriteLine(jObj.ToString());

            JToken colleagues = jObj["Colleagues"];
            colleagues[0]["Age"] = 45;

            jObj["Colleagues"] = colleagues;
            Console.WriteLine(jObj.ToString());
        }

        public static void CreateJArray()
        {
            JArray arr = new JArray();
            arr.Add(new JValue(1));
            arr.Add(new JValue(2));
            arr.Add(new JValue(3));

            Console.WriteLine(arr.ToString());
        }
    }
}
