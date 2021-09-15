using Firebase.Database;
using Firebase.Storage;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace CPU_Catalog3.Controller
{
    class StorageController
    {
       public FirebaseStorageTask UploadPhoto(Stream stream, string name)
        {
            var task = new FirebaseStorage("cpu-catalog2.appspot.com")
             .Child("images")
             .Child(name)
             .PutAsync(stream);

            return task;
        }
    }
}
