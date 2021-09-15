using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Maps;
using Xamarin.Forms.Xaml;
using CPU_Catalog3.Controller;
using CPU_Catalog3.Model;

namespace CPU_Catalog3.View
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class MapPage : ContentPage
    {
        public static List<User> listCPU { get; private set; }
        public MapPage()
        {
            InitializeComponent();
        }

        protected override async void OnAppearing()
        {
            listCPU = await DBaseController.GetAllUsers();
            for (int i = 0; i < listCPU.Count; i++)
            {
                if (listCPU[i].UserPosition != null && listCPU[i].Model != null)
                {
                    Pin pin = new Pin()
                    {
                        Type = PinType.Place,
                        Label = listCPU[i].Model,
                        Position = listCPU[i].UserPosition,
                        Address = "Details"
                    };

                    pin.InfoWindowClicked +=  (sender, e) => {
                        if (DBaseController.GetUser((sender as Pin).Label) != null){

                            Navigation.PushModalAsync(new NoScrollTabbedPage2());
                        }
                    };
                    map.Pins.Add(pin);
                }
            }

        }
        private void Pin_OnMarkerClicked(object sender, PinClickedEventArgs e)
        {
            //var userController = new UserController( as User);
            Navigation.PushModalAsync(new NoScrollTabbedPage2());

            // var vm = (BindingContext as CharacterListViewModel)!;
            //var pin = (Pin)sender;
            //Navigation.PushAsync(new CharacterDetailsPage(vm.Characters.First(character => character.LastName == pin.Label)));
        }
    }
}