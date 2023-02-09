package com.bankofjordan.getcardidimages

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel

class IdViewModel : ViewModel() {
    val NumButton = MutableLiveData<Int>()
    val FrontFile = MutableLiveData<String>()
    val BackFile = MutableLiveData<String>()
    /*set frontPhoto file path*/
    fun frontFile(item: String) {
        FrontFile.value = item
    }
    /*set backPhoto file path*/
    fun backFile(item: String) {
        BackFile.value = item
    }

}