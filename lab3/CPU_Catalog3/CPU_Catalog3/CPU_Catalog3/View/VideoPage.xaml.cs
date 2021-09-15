using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Maps;
using Xamarin.Forms.Xaml;
using CPU_Catalog3.Controller;
using Xamarin.CommunityToolkit.Core;

namespace CPU_Catalog3.View
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class VideoPage : ContentPage
    {
        public VideoPage()
        {
            InitializeComponent();
        }

        protected override void OnAppearing()
        {
            if (UserController.CurrentUser.Video != null && UserController.CurrentUser.Video!= "")
            {
                Video.Source = MediaSource.FromUri(UserController.CurrentUser.Video);
                Video.IsVisible = true;
            }
        }
    }
}