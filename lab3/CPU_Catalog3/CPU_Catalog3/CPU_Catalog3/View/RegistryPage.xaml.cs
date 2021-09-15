using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;
using CPU_Catalog3.Controller;

namespace CPU_Catalog3.View
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class RegistryPage : ContentPage
    {
        private DateTime selectedDate;

        public RegistryPage()
        {
            InitializeComponent();
            bitsdepthPicker.SelectedIndex = 0;
            manufacturerPicker.SelectedIndex = 0;
        }

        private async void registryButton_ClickedAsync(object sender, EventArgs e)
        {
            var email = emailEntry.Text;
            var pass = passEntry.Text;
            var model = modelEntry.Text;
            var bitsdepth = BitsAndManufController.AppBitsdepth[bitsdepthPicker.SelectedIndex];
            var manufacturer = BitsAndManufController.AppManufacturer[manufacturerPicker.SelectedIndex];
            var numcores = numcoresEntry.Text;
            var frequency = frequencyEntry.Text;

            try
            {
                var response =  await UserController.CreateNewUser(email, pass, model, bitsdepth, manufacturer, numcores, frequency,"","", new string[1],"");
                if (response)
                {
                    await DisplayAlert("Congratulation!", "Successful registry!", "OK!");
                    await Navigation.PopModalAsync();
                }
                else
                    throw new Exception("Something went wrong!");
            }
            catch (Exception ex)
            {
                await DisplayAlert("Alert!", ex.Message, "OK!");
            }
        }

        private void datePicker_DateSelected(object sender, DateChangedEventArgs e)
        {
            selectedDate = e.NewDate;
        }
    }
}