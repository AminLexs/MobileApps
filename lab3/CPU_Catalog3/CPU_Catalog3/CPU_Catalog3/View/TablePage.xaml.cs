using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms.Xaml;
using Xamarin.Forms;
using CPU_Catalog3.Controller;
using CPU_Catalog3.Model;
using CPU_Catalog3.LangResource;

namespace CPU_Catalog3.View
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class TablePage : ContentPage
    {
        public static List<User> listCPU { get; private set; }
        private StackLayout frameStack = new StackLayout()
        {
            Padding = new Thickness(10,10,10,10)
        };

        public  TablePage()
        {
            InitPage();
            Resources = DependencyService.Resolve<ResourceDictionary>();
            InitializeComponent();
            ReColor();

        }

        private async void InitPage()
        {
            listCPU = await DBaseController.GetAllUsers();

        }
    
        protected override async void OnAppearing()
        {
            listCPU = await DBaseController.GetAllUsers();
            for (int i = 0; i < listCPU.Count; i++)
            {
                listCPU[i].Numcores += " "+ Resource.cores;
                listCPU[i].Frequency += " " + Resource.detGHZLabel;
            }
            Binding binding = new Binding { Source = ColorController.CurrentTheme, Path = "BackColor" };
            template.SetBinding(Label.BackgroundColorProperty, binding);

            ReColor();
            collectionview.ItemsSource = listCPU;
           // ShowCPUs();
        }   

        private void ReColor()
        {
            this.BackgroundColor = ColorController.CurrentTheme.BackColor;
            collectionview.BackgroundColor = ColorController.CurrentTheme.AddColor;
            frameStack.BackgroundColor = ColorController.CurrentTheme.BackColor;
            
        }



        void CollectionViewListSelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            var userController = new UserController(e.CurrentSelection[0] as User);
            Navigation.PushModalAsync(new NoScrollTabbedPage2());
        }

        private void ShowCPUs()
        {
            frameStack.Children.Clear();

            for (int i = 0; i < listCPU.Count; i++)
            {
                var frame = new Frame();

                frame.Padding = new Thickness(5,5,5,5);
                frame.BorderColor = ColorController.CurrentTheme.AddColor;
                frame.BackgroundColor = ColorController.CurrentTheme.BackColor;

                var grid = new Grid()
                {
                    RowDefinitions =
                    {
                        new RowDefinition { Height = new GridLength(0.4f, GridUnitType.Star)}
                    },
                    ColumnDefinitions =
                    {
                        new ColumnDefinition{ Width = new GridLength(0.25f, GridUnitType.Star ) },
                        new ColumnDefinition{ Width = new GridLength(0.75f, GridUnitType.Star ) },
                    }
                };

                var userInfo = new StackLayout();
                userInfo.Margin = new Thickness(5,0,0,0);
                userInfo.Spacing = 0.5f;

                var modelManufacturerLabel = new Label()
                {
                    Text = listCPU[i].Model+", " + listCPU[i].Manufacturer,
                    TextColor = ColorController.CurrentTheme.FontColor,
                    TextDecorations = TextDecorations.Underline,
                    FontSize = 22
                };
                userInfo.Children.Add(modelManufacturerLabel);

                var frequencyLabel = new Label()
                {
                    Text = "Frequency(GHz): "+ listCPU[i].Frequency,
                    TextColor = ColorController.CurrentTheme.FontColor,
                    FontSize = 16
                };
                userInfo.Children.Add(frequencyLabel);

                var numcoresLabel = new Label()
                {
                    Text = "Number of cores: "+ listCPU[i].Numcores,
                    TextColor = ColorController.CurrentTheme.FontColor,
                    FontSize = 16
                };
                userInfo.Children.Add(numcoresLabel);


                var hSize = 0.2f * frameStack.Width;
                var wSize = 0.3f * frameStack.Width;

                var userPhoto = new Image();
                userPhoto.Source = new UriImageSource
                {
                    CachingEnabled = false,
                    Uri = new Uri(listCPU[i].Avatar)
                };
                userPhoto.Aspect = Aspect.AspectFill;

                var userFrame = new Frame
                {
                    BorderColor = ColorController.CurrentTheme.AddColor,
                    Content = userPhoto,
                    BackgroundColor = ColorController.CurrentTheme.BackColor,
                    WidthRequest = wSize,
                    HeightRequest = hSize,
                    Padding = new Thickness(1,1,1,1)
                };

                grid.Children.Add(userFrame, 0, 0);
                grid.Children.Add(userInfo, 1, 0 );
                
                frame.Content = grid;
                TapGestureRecognizer tapGesture = new TapGestureRecognizer
                {
                    NumberOfTapsRequired = 1
                };
                var cpu = listCPU[i];
                tapGesture.Tapped += (s, e) =>
                {
                    var userController = new UserController(cpu);
                    Navigation.PushModalAsync(new NoScrollTabbedPage2());
                    //  Navigation.PushModalAsync(new DetailedPage());
                };
                frame.GestureRecognizers.Add(tapGesture);


                //frameStack.Children.Add(frame);
            }
            //(frameStack);//.Children.Add(frameStack);
        }

    }
}