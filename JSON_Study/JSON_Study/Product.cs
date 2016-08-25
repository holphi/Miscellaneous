using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JSONStudy
{
    class Product
    {
        private string name;
        public string Name
        {
            get { return name; }
            set { name = value; }
        }

        private DateTime expireDate;
        public DateTime ExpireDate
        {
            get { return expireDate; }
            set { expireDate = value; }
        }

        private double price;
        public double Price
        {
            get { return price; }
            set { price = value; }
        }

        private string[] sizes;

        public string[] Sizes
        {
            get { return sizes; }
            set { sizes = value; }
        }

        public Product(string name, double price, DateTime expireDate)
        {
            this.name = name;
            this.price = price;
            this.expireDate = expireDate;
        }

        public Product()
        { 
        
        }
    }
}
