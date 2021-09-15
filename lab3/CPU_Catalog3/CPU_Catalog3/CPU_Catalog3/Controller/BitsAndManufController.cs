using System;
using System.Collections.Generic;
using System.Text;
using XamarinApp.Model;

namespace CPU_Catalog3.Controller
{
    class BitsAndManufController
    {
        public static List<string> AppBitsdepth { get; private set; }
        public static List<string> AppManufacturer { get; private set; }

        public BitsAndManufController()
        {

            AppBitsdepth = new List<string>()
            {
                "x32",
                "x64"
            };

            AppManufacturer = new List<string>()
            {
                "Intel",
                "Amd"
            };

        }
    }
}
