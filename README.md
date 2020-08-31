### CFRP

This is the code of our IEEE CSVT paper: "Adaptive Region Proposal with Channel Regularization for Robust Object Tracking".
We expliot region proposal from object detection to address object re-detection and scale estimation issue in object tracking.

##

![](../master/framework1_1.png)

## Startup
1.Setup matconvet (recompile it if it is not comptiable with your machine) http://www.vlfeat.org/matconvnet/

2.Download the VGG-19 model "imagenet-vgg-verydeep-19.mat" http://www.vlfeat.org/matconvnet/pretrained/
Create a new folder called model, put the VGG-19 model into the folder.

3.Download Egdebox toolkit:https://github.com/pdollar/toolbox
rename it as edgebox

4.Run "run_tracker1.m"

## Results
The tracking results on OTB-2015 dataset can be downloaded from [googledrive](https://drive.google.com/file/d/1nx04NKp3kwALYmNhYAlJhw2Lupdzs9iK/view?usp=sharing)

### Citation
If you find the code and dataset useful in your research, please consider citing:

@article{lu2019adaptive,  
  title={Adaptive Region Proposal with Channel Regularization for Robust Object Tracking},  
  author={Lu, Xiankai and Ma, Chao and Ni, Bingbing and Yang, Xiaokang},  
  journal={IEEE Transactions on Circuits and Systems for Video Technology},  
  year={2019},  
  publisher={IEEE}  
}
