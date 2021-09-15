using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.Threading.Tasks;
using Firebase.Database;
using Firebase.Database.Query;
using CPU_Catalog3.Model;

namespace CPU_Catalog3.Controller
{
    public class DBaseController
    {
        public static FirebaseClient firebaseClient { get; private set; }

        public DBaseController(string key)
        {
            firebaseClient = new FirebaseClient(key);
        }

        public static async Task<User> LogInUser(string email, string pass)
        {
            if (firebaseClient != null)
            {
                var gotted = (await firebaseClient
                    .Child("Users")
                    .OnceAsync<User>()).Where(a => a.Object.Email == email).Where(b => b.Object.Password == pass).FirstOrDefault();

                if (gotted != null)
                {
                    User user = new User(gotted.Object.Id, gotted.Object.Email, gotted.Object.Password, gotted.Object.Model, gotted.Object.Bitsdepth, gotted.Object.Manufacturer, 
                         gotted.Object.Numcores, gotted.Object.Frequency, gotted.Object.Avatar, gotted.Object.Video, gotted.Object.Images, gotted.Object.Description, gotted.Object.UserPosition);
                    return user;
                }
            }
            return null;
        }

        public static async Task<User> GetUser(string model)
        {
            if (firebaseClient != null)
            {
                var gotted = (await firebaseClient
                    .Child("Users")
                    .OnceAsync<User>()).Where(a => a.Object.Model == model).FirstOrDefault();

                if (gotted != null)
                {
                    User user = new User(gotted.Object.Id, gotted.Object.Email, gotted.Object.Password, gotted.Object.Model, gotted.Object.Bitsdepth, gotted.Object.Manufacturer,
                         gotted.Object.Numcores, gotted.Object.Frequency, gotted.Object.Avatar, gotted.Object.Video, gotted.Object.Images, gotted.Object.Description, gotted.Object.UserPosition);
                    UserController.CurrentUser = user;
                    return user;
                }
            }
            return null;
        }

        public static async Task<int> GetUsersCount()
        {
            if (firebaseClient != null)
            {
                var gotted = (await firebaseClient
                    .Child("Users")
                    .OnceAsync<User>()).Count;
                return gotted;
            }
            return 0;
        }

        public static async Task<bool> RegUser(User user)
        {
            if ((user != null) && (firebaseClient != null))
            {
                await firebaseClient
                    .Child("Users")
                    .PostAsync(user);

                return true;
            }
            else
                return false;
        }

        public static async Task<List<User>> GetAllUsers()
        {
            if (firebaseClient != null)
            {
                var gotted = (await firebaseClient
                    .Child("Users")
                    .OnceAsync<User>()).Select(user => new User
                    {
                        Id = user.Object.Id,
                        Email = user.Object.Email,
                        Password = user.Object.Password,
                        Model = user.Object.Model,
                        Bitsdepth = user.Object.Bitsdepth,
                        Manufacturer = user.Object.Manufacturer,                      
                        Numcores = user.Object.Numcores,
                        Frequency = user.Object.Frequency,
                        Avatar = user.Object.Avatar,
                        Video = user.Object.Video,
                        Images = user.Object.Images,
                        Description = user.Object.Description,
                        UserPosition = user.Object.UserPosition
                    }).ToList();

                if (gotted != null)
                {
                    return new List<User>(gotted);
                }
            }
            return null;
        }

        public static async Task<bool> IsLoginFree(string email)
        {
            if (firebaseClient != null)
            {
                var gotted = (await firebaseClient
                    .Child("Users")
                    .OnceAsync<User>()).Where(a => a.Object.Email == email).FirstOrDefault();

                if (gotted != null)
                    return false;
            }
            return true;
        }

        public static async Task<bool> UpdateUser(User user)
        {
            if ((user != null) && (firebaseClient != null))
            {
                var deleted = (await firebaseClient
                    .Child("Users")
                    .OnceAsync<User>()).Where(a => a.Object.Id == user.Id).FirstOrDefault();
                await firebaseClient.Child("Users").Child(deleted.Key).DeleteAsync();

                if (deleted.Object != null)
                {
                    await firebaseClient.Child("Users").PostAsync(user);

                    return true;
                }
                else
                {
                    return false;

                }
            }
            else
                return false;
        }
    }
}
