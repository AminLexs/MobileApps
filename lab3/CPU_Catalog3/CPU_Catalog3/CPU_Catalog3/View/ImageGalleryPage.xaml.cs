using Xamarin.Forms;
using Xamarin.Forms.Xaml;
using CPU_Catalog3.Controller;
namespace CPU_Catalog3.View
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class ImageGalleryPage : ContentPage
    {
        private string[] _images;

        public string[] Images
        {
            get => _images;
            set
            {
                _images = value;
                OnPropertyChanged();
            }
        }

        public ImageGalleryPage()
        {
            _images = UserController.CurrentUser.Images;
            
            InitializeComponent();
            ReColor();
            //Carousel.CurrentItem = UserController.CurrentUser.Images[];
        }
        private void ReColor()
        {
            this.BackgroundColor = ColorController.CurrentTheme.BackColor;
        }
    }
}