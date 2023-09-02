package com.bankofjordan.getcardidimages

import android.content.res.ColorStateList
import android.graphics.BitmapFactory
import android.graphics.Color
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.Navigation
import com.bankofjordan.getcardidimages.databinding.FragmentIdBinding
import java.io.File

class IdFragment : Fragment() {

    private lateinit var viewModel: IdViewModel
    private lateinit var binding: FragmentIdBinding

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View? {
        //show back app and status bar
        val decorView = (activity as AppCompatActivity?)!!.window.decorView
        val uiOptions = View.SYSTEM_UI_FLAG_VISIBLE
        decorView.setSystemUiVisibility(uiOptions)
        this.retainInstance = true
        (activity as AppCompatActivity?)!!.supportActionBar!!.show()
        return inflater.inflate(R.layout.fragment_id, container, false)

    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {

        binding = FragmentIdBinding.bind(view)

        viewModel = activity?.run {
            ViewModelProvider(this)[IdViewModel::class.java]
        } ?: throw Exception("Invalid Activity")

        /*observe data*/
        viewModel.FrontFile.observe(this.viewLifecycleOwner, Observer {
            binding.frontTextView.text = viewModel.FrontFile.value
        })
        viewModel.BackFile.observe(this.viewLifecycleOwner, Observer {
            binding.backTextView.text = viewModel.BackFile.value
        })
        viewModel.NumButton.observe(this.viewLifecycleOwner, Observer {
            viewModel.NumButton.value
        })


        /*take front ID photo*/
        binding.frontImageButton.setOnClickListener {
            /*Delete picture if there is already one*/
            if (!viewModel.FrontFile.value.isNullOrEmpty()) {
                File(viewModel.FrontFile.value!!).delete()
                viewModel.FrontFile.value = ""
            }
            viewModel.NumButton.value = 1
            Navigation.findNavController(view)
                .navigate(R.id.action_idFragment_to_photoFragment)
        }
        /*take back ID photo*/
        binding.backImageButton.setOnClickListener {
            /*Delete picture if there is already one*/
            if (!viewModel.BackFile.value.isNullOrEmpty()) {
                File(viewModel.BackFile.value!!).delete()
                viewModel.BackFile.value = ""
            }
            viewModel.NumButton.value = 2
            Navigation.findNavController(view)
                .navigate(R.id.action_idFragment_to_photoFragment)
        }

        /*show FRONT photo*/
        if (!viewModel.FrontFile.value.isNullOrEmpty()) {
            val bitmap = BitmapFactory.decodeFile(viewModel.FrontFile.value)
            binding.frontImageButton.setImageBitmap(bitmap)
            binding.frontImageButton.backgroundTintList = ColorStateList.valueOf(Color.TRANSPARENT)

        }
        /*show BACK photo*/
        if (!viewModel.BackFile.value.isNullOrEmpty()) {
            val bitmap = BitmapFactory.decodeFile(viewModel.BackFile.value)
            binding.backImageButton.setImageBitmap(bitmap)
            binding.backImageButton.backgroundTintList = ColorStateList.valueOf(Color.TRANSPARENT)
        }
    }
    override fun onDestroy() {
        super.onDestroy()
        if(!viewModel.FrontFile.value.isNullOrEmpty()){
            File(viewModel.FrontFile.value!!).delete()
        }
        if(!viewModel.BackFile.value.isNullOrEmpty()){
            File(viewModel.BackFile.value!!).delete()
        }
    }
}