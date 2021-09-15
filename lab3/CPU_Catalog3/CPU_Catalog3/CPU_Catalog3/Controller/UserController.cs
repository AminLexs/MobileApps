using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using CPU_Catalog3.Model;
using Xamarin.Forms.Maps;

namespace CPU_Catalog3.Controller
{
    class UserController
    {
        public static User CurrentUser { get;  set; }

        public UserController(User user)
        {
            if (user != null)
                CurrentUser = user;
        }

        public static async Task<bool> CreateNewUser(string email, string pass, string model, string bitsdepth, string manufacturer, string numcores, string frequency, string avatar, string video, string[] images, string desc)
        {
            var response = await DBaseController.IsLoginFree(email);

            if (response)
            {
                var id = await DBaseController.GetUsersCount();
                id++;

                var user = new User(id, email, pass, model, bitsdepth, manufacturer, numcores, frequency, avatar, video, images, desc, new Position(53.898578, 27.453100));

                var registered = await DBaseController.RegUser(user);
                if (registered)
                    return true;
                else
                    return false;
            }
            else
                throw new Exception("Sorry, but this login is already taken!");
        }
    }
}
