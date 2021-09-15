using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Essentials;
using Xamarin.Forms.Maps;
using Xamarin.Forms.Xaml;
using CPU_Catalog3.Controller;
using CPU_Catalog3.Model;
using CPU_Catalog3.LangResource;


namespace CPU_Catalog3.View
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class EditPage : ContentPage
    {
        string url="";
        public EditPage()
        {
            InitializeComponent();
            ReColor();
        }

        protected override void OnAppearing()
        {
            Model.Placeholder = Resource.entryModel;
            Manufacturer.Placeholder = Resource.entryManufacturer;
            Bitsdepth.Placeholder = Resource.entryBitsdepth;
            Frequency.Placeholder = Resource.entryFrequency;
            Numcores.Placeholder = Resource.entryNumcores;
            videoUrl.Placeholder = Resource.entryvideoUrl;
            Latitude.Placeholder = Resource.entryLatitude;
            Longitude.Placeholder = Resource.entryLongitude;
            if (UserController.CurrentUser.Model != null)
            {
                Model.Text = UserController.CurrentUser.Model;
            }
            if (UserController.CurrentUser.Manufacturer != null)
            {
                Manufacturer.Text = UserController.CurrentUser.Manufacturer;
            }
            if (UserController.CurrentUser.Bitsdepth != null)
            {
                Bitsdepth.Text = UserController.CurrentUser.Bitsdepth;
            }
            if (UserController.CurrentUser.Frequency != null)
            {
                Frequency.Text = UserController.CurrentUser.Frequency;
            }
            if (UserController.CurrentUser.Numcores != null)
            {
                Numcores.Text = UserController.CurrentUser.Numcores;
            }
            if (UserController.CurrentUser.Video != null)
            {
                videoUrl.Text = UserController.CurrentUser.Video;
            }
            if (UserController.CurrentUser.UserPosition != null)
            {
                Latitude.Text = UserController.CurrentUser.UserPosition.Latitude.ToString();
                Longitude.Text = UserController.CurrentUser.UserPosition.Longitude.ToString();
            }
            ReColor();
        }
        async void GetImage_OnClicked(object sender, EventArgs e)
        {
            var result = await MediaPicker.PickPhotoAsync(new MediaPickerOptions
            {
                Title = "Please pick a photo"
            });
            var stream = await result.OpenReadAsync();
            var storage = new StorageController();
            url = await storage.UploadPhoto(stream, "image/"+ UserController.CurrentUser.Id+ UserController.CurrentUser.Model);
            
            
        }
        async void  SaveButton_OnClicked(object sender, EventArgs e)
        {
            User user = new User(UserController.CurrentUser.Id, UserController.CurrentUser.Email,
                UserController.CurrentUser.Password, Model.Text, Bitsdepth.Text, Manufacturer.Text, Numcores.Text, Frequency.Text,
              (url=="")?UserController.CurrentUser.Avatar:url, videoUrl.Text, UserController.CurrentUser.Images, UserController.CurrentUser.Description, UserController.CurrentUser.UserPosition);
          await  DBaseController.UpdateUser(user);
        }
        private void ReColor()
        {
            this.BackgroundColor = ColorController.CurrentTheme.BackColor;
            stack.BackgroundColor = ColorController.CurrentTheme.BackColor;
            Model.TextColor = ColorController.CurrentTheme.FontColor;
            Manufacturer.TextColor = ColorController.CurrentTheme.FontColor;
            Bitsdepth.TextColor = ColorController.CurrentTheme.FontColor;
            Frequency.TextColor = ColorController.CurrentTheme.FontColor;
            Numcores.TextColor = ColorController.CurrentTheme.FontColor;
            videoUrl.TextColor = ColorController.CurrentTheme.FontColor;
            Latitude.TextColor = ColorController.CurrentTheme.FontColor;
            Longitude.TextColor = ColorController.CurrentTheme.FontColor;
        }
    }
}