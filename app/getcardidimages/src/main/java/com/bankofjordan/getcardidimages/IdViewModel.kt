package com.bankofjordan.getcardidimages

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel

class IdViewModel : ViewModel() {
    val NumButton = MutableLiveData<Int>()
    val FrontFile = MutableLiveData<String>()
    val BackFile = MutableLiveData<String>()
    fun frontFile(item: String) {
        FrontFile.value = item
    }

    fun backFile(item: String) {
        BackFile.value = item
    }

}