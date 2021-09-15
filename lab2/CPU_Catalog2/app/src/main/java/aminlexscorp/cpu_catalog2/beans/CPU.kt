package aminlexscorp.cpu_catalog2.beans

import android.os.Parcelable
import java.io.Serializable

class CPU: Serializable{
    public var  model: String? =null
    public var manufacturer: String? =null
    public var  bitdepth: String?=null
    public var frequency: String?=null
    public var numcores: String?=null
    public var avatar: String?=null
    public var description: String?=null
    public var images: ArrayList<String>?=null
    public var video: String?=null
    public var latitude: String? =null
    public var longitude: String? =null

    constructor(_model: String?,_manufacturer: String?, _bitdepth: String?,
                _frequency: String?, _numcores: String?, _avatar: String?,_description: String?, _photo: ArrayList<String>?,
                _video: String?, _latitude: String?, _longitude: String?){
        model=_model
        manufacturer=_manufacturer
        bitdepth=_bitdepth
        frequency=_frequency
        numcores=_numcores
        avatar=_avatar
        description=_description
        images=_photo
        video=_video
        latitude=_latitude
        longitude=_longitude
    }

}
