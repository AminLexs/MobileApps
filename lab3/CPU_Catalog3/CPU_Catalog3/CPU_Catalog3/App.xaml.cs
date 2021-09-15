using System;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;
using CPU_Catalog3.Model;
using CPU_Catalog3.Controller;
using CPU_Catalog3.View;
[assembly: ExportFont("Stick-Regular.ttf", Alias = "Stick")]
[assembly: ExportFont("OpenSans-Regular.ttf", Alias = "Open Sans")]
namespace CPU_Catalog3
{

    public partial class App : Application
    {
        public static App currentApp { get; private set; }
        public App()
        {
            currentApp = this;
            var dbase = new DBaseController("https://cpu-catalog2-default-rtdb.europe-west1.firebasedatabase.app");
            var bitsandmanuf = new BitsAndManufController();
            InitializeComponent();
            var resources = new ResourceDictionary
            {
                ["FontFamily"] = "Droid Sans",
                ["FontSize"] = 14,
            };
            DependencyService.RegisterSingleton(resources);
            MainPage = new MainPage();
        }
        public void GotLogged(User user)
        {
            var colorController = new ColorController();
            var langController = new LanguageController();
            var userController = new UserController(user);
            MainPage = new NoScrollTabbedPage();
        }

        protected override void OnStart()
        {
        }

        protected override void OnSleep()
        {
        }

        protected override void OnResume()
        {
        }
    }
}
