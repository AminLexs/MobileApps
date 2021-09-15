using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;
using CPU_Catalog3.Controller;
using CPU_Catalog3.Model;
using CPU_Catalog3.LangResource;

namespace CPU_Catalog3.View
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class DetailedPage : ContentPage
    {
        public DetailedPage()
        {
            Resources = DependencyService.Resolve<ResourceDictionary>();
            InitializeComponent();
            
        }
        protected override void OnAppearing()
        {
            AddUserInfo();
            ReColor();
        }

        private void ReColor()
        {
            this.BackgroundColor = ColorController.CurrentTheme.BackColor;

            userFrame.BorderColor = ColorController.CurrentTheme.AddColor;
            userFrame.BackgroundColor = ColorController.CurrentTheme.BackColor;

        }

        private void AddUserInfo()
        {
            StackLayout frameStack = new StackLayout();

            var photoFrame = new Frame()
            {
                BorderColor = ColorController.CurrentTheme.AddColor,
                BackgroundColor = ColorController.CurrentTheme.BackColor,
                WidthRequest = 128,// 0.45f * userFrame.Width,
                HeightRequest = 128,// 0.55f * userFrame.Height,
                Padding = new Thickness(5, 5, 5, 5)
            };



            var userPhoto = new Image();
            userPhoto.Source = new UriImageSource
            {
                CachingEnabled = false,
                Uri = new Uri(UserController.CurrentUser.Avatar)
            };
            userPhoto.Aspect = Aspect.AspectFit;
            photoFrame.Content = userPhoto;

            var infoFrame = new Frame()
            {
                BorderColor = ColorController.CurrentTheme.AddColor,
                BackgroundColor = ColorController.CurrentTheme.BackColor,
                Padding = new Thickness(10, 10, 10, 10)
            };

            StackLayout infoStack = new StackLayout();

            Label infoLabel = new Label()
            {
                TextColor = ColorController.CurrentTheme.FontColor,
                Text = Resource.detailedInformationLabel,
                FontFamily = Resources["FontFamily"].ToString(),
                FontSize = Device.GetNamedSize(NamedSize.Large, typeof(Label)),
                HorizontalTextAlignment = TextAlignment.Center
            };
            infoStack.Children.Add(infoLabel);

            Label modelLabel = new Label()
            {
                TextColor = ColorController.CurrentTheme.FontColor,
                Text = Resource.detModelLabel + " " + UserController.CurrentUser.Model,
                FontFamily = Resources["FontFamily"].ToString(),
                FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label))
            };
            infoStack.Children.Add(modelLabel);

            Label manufacturerLabel = new Label()
            {
                TextColor = ColorController.CurrentTheme.FontColor,
                Text = Resource.detManufacturerLabel+ " " + UserController.CurrentUser.Manufacturer,
                FontFamily = Resources["FontFamily"].ToString(),
                FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label))
            };
            infoStack.Children.Add(manufacturerLabel);

            Label bitsdepthLabel = new Label()
            {
                TextColor = ColorController.CurrentTheme.FontColor,
                Text = Resource.detBitdepthLabel + " " + UserController.CurrentUser.Bitsdepth,
                FontFamily = Resources["FontFamily"].ToString(),
                FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label))
            };
            infoStack.Children.Add(bitsdepthLabel);

            Label numcoresLabel = new Label()
            {
                TextColor = ColorController.CurrentTheme.FontColor,
                Text = Resource.detNumcoresLabel + " " + UserController.CurrentUser.Numcores,
                FontFamily = Resources["FontFamily"].ToString(),
                FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label))
            };
            infoStack.Children.Add(numcoresLabel);


            Label frequencyLabel = new Label()
            {
                TextColor = ColorController.CurrentTheme.FontColor,
                Text = Resource.detFrequencyLabel + " " + UserController.CurrentUser.Frequency,
                FontFamily = Resources["FontFamily"].ToString(),
                FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label))
            };
            infoStack.Children.Add(frequencyLabel);

            infoFrame.Content = infoStack;

            var descrFrame = new Frame()
            {
                BorderColor = ColorController.CurrentTheme.AddColor,
                BackgroundColor = ColorController.CurrentTheme.BackColor,
                Padding = new Thickness(10, 10, 10, 10)
            };
            StackLayout descrStack = new StackLayout();

            Label staticDescrLabel = new Label()
            {
                TextColor = ColorController.CurrentTheme.FontColor,
                Text = Resource.detDescriptionLabel,
                FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label)),
                FontFamily = Resources["FontFamily"].ToString(),
                HorizontalTextAlignment = TextAlignment.Center
            };
            descrStack.Children.Add(staticDescrLabel);
            Label descriptionLabel = new Label()
            {
                TextColor = ColorController.CurrentTheme.FontColor,
                Text = UserController.CurrentUser.Description,
                FontFamily = Resources["FontFamily"].ToString(),
                FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label))
            };
            descrStack.Children.Add(descriptionLabel);
            descrFrame.Content = descrStack;


            frameStack.Children.Add(photoFrame);
            frameStack.Children.Add(infoFrame);
            frameStack.Children.Add(descrFrame);
            userFrame.Content = frameStack;
        }
    }
}