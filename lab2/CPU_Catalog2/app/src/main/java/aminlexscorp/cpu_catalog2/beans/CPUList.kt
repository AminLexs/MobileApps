package aminlexscorp.cpu_catalog2.beans

import aminlexscorp.cpu_catalog2.beans.CPU
import java.io.Serializable

class CPUList: Serializable {

    public var cpus: ArrayList<CPU>

    constructor(_cpus: ArrayList<CPU>){
        cpus=_cpus
    }
}