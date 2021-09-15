using CPU_Catalog3.Controller;
using System;
using System.Collections.Generic;
using System.Threading;
using Xamarin.Forms.Maps;

namespace CPU_Catalog3.Model
{
    public class ListViewModel
    {
       public List<User> listCPU { get; set; }
        public ListViewModel()
        {
       //     listCPU = new List<User>();
         //   listCPU.Add(new User(1 , "111", "222", "INTEL BEST", "64", "INTEL", "3", "3000",
         //       "https://firebasestorage.googleapis.com/v0/b/cpu-catalog2.appspot.com/o/images%2F18.jpg?alt=media&token=1333d72f-630b-49be-b0bc-80e485677de5", "", new string[0]));
             GetInit();

        }
        private async void GetInit()
        {
            listCPU = await DBaseController.GetAllUsers();
        }
    }
}
