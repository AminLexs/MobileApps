using System;
using System.Collections.Generic;
using Xamarin.Forms.Maps;

namespace CPU_Catalog3.Model
{
    public class User
    {
        public int Id { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }

        public string Model { get; set; }
        public string Bitsdepth { get; set; }
        public string Manufacturer { get; set; }
        public string Numcores { get; set; }
        public string Frequency { get; set; }
        public string Avatar { get; set; }
        public string Video { get; set; }
        public string[] Images { get; set; }
        public string Description { get; set; }
        public Position UserPosition { get; set; }


        public User(int id,
                    string email,
                    string pass,
                    string model,
                    string bitsdepth,
                    string manufacturer, string numcores, string frequency, string avatar, string video, string[] images, string desc, Position pos)
        {
            if (id > 0)
                this.Id = id;
            else
                throw new Exception("Wrong user's ID");

            if (!string.IsNullOrEmpty(email) && !string.IsNullOrWhiteSpace(email))
                this.Email = email;
            else
                Email = "";
            // throw new Exception("Please, enter your login!");

            if (!string.IsNullOrWhiteSpace(pass) && !string.IsNullOrWhiteSpace(pass))
                this.Password = pass;
            else
                Password = "";
              //  throw new Exception("Please, enter your password!");

            if (!string.IsNullOrWhiteSpace(model) && !string.IsNullOrWhiteSpace(model))
                this.Model = model;
            else
                throw new Exception("Please, enter model!");

            if (!string.IsNullOrWhiteSpace(numcores) && !string.IsNullOrWhiteSpace(numcores))
                this.Numcores = numcores;
            else
                throw new Exception("Please, enter number of cores!");

            if (!string.IsNullOrWhiteSpace(frequency) && !string.IsNullOrWhiteSpace(frequency))
                this.Frequency = frequency;
            else
                throw new Exception("Please, enter frequency!");

            if (!string.IsNullOrWhiteSpace(bitsdepth) && !string.IsNullOrWhiteSpace(bitsdepth))
                this.Bitsdepth = bitsdepth;
            else
                throw new Exception("Please, enter bits depth!");

            if (!string.IsNullOrWhiteSpace(numcores) && !string.IsNullOrWhiteSpace(numcores))
                this.Manufacturer = manufacturer;
            else
                throw new Exception("Please, enter manufacturer!");

            if (!string.IsNullOrWhiteSpace(avatar) && !string.IsNullOrWhiteSpace(avatar))
                this.Avatar = avatar;
            else
                this.Avatar = "";
            //throw new Exception("Empty avatar url!");
            if (!string.IsNullOrWhiteSpace(video) && !string.IsNullOrWhiteSpace(video))
                this.Video = video;
            else
                this.Video = "";

            this.Images = images;
            this.Description = desc;
            this.UserPosition = pos;//new Position(53.898578, 27.453100);

        }

        public User()
        {

        }
    }
}
