using System;
using System.Collections.Generic;
using System.ComponentModel.Design;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.PlatformConfiguration.AndroidSpecific;
using Xamarin.Forms.Xaml;
using CPU_Catalog3.Controller;

namespace CPU_Catalog3.View
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class NoScrollTabbedPage2 : Xamarin.Forms.TabbedPage
    {
        public NoScrollTabbedPage2()
        {
            InitializeComponent();

            this.CurrentPage = this.Children[0];

            this.On<Xamarin.Forms.PlatformConfiguration.Android>().SetIsSwipePagingEnabled(false);
            this.On<Xamarin.Forms.PlatformConfiguration.Android>().SetToolbarPlacement(ToolbarPlacement.Bottom);

           // settingsPage.ParentPage = this;
        }

        public void ReColor()
        {
            this.BarBackgroundColor = ColorController.CurrentTheme.BackColor;
            this.SelectedTabColor = ColorController.CurrentTheme.AddColor;
            this.UnselectedTabColor = ColorController.CurrentTheme.FontColor;
        }

        protected override void OnAppearing()
        {
            ReColor();
        }
    }
}