using System;
using System.Collections.Generic;
using System.Text;
using CPU_Catalog3.LangResource;
using XamarinApp.Model;

namespace CPU_Catalog3.Controller
{
    class LanguageController
    {
        public static List<AppLanguage> AppLanguages { get; private set; }

        public LanguageController()
        {
            var eng = new AppLanguage("English", "en-us");
            var ru = new AppLanguage("Русский", "ru-ru");

            AppLanguages = new List<AppLanguage>()
            {
                eng,
                ru
            };

            Resource.Culture = new System.Globalization.CultureInfo(AppLanguages[0].CI);
        }

        public static void SetNewCulture(int indx)
        {
            Resource.Culture = new System.Globalization.CultureInfo(AppLanguages[indx].CI);
        }
    }
}
