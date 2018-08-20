Instructions

* $TELLO_YOLO_HOME refers the root directory of this repository where this README file is located

1. Place input data

	(1) Create directory:

		$ cd $TELLO_YOLO_HOME/test_data; mkdir testX

	(2) Copy input file into the directory

		$ cp ~/testX.jpg testX OR $ cp ~/testX.png testX 

	(3) If the input file is .jpg, convert it to .png file

		$ cd testX; convert testX.jpg testX.png

	(4) Create .npy file from .png file

		$ cd ..; python testX/testX.png

2. Run TensorFlow-Yolo2-Tiny (dnn.tf) for the input

	(1) Run yolo2_tiny_tf.py

		$ cd $TELLO_YOLO_HOME/dnn.tf
		$ python yolo2_tiny_tf.py org ../test_data/testX ../weights/y2t-weight.pickle
		$ python yolo2_tiny_tf.py bswap ../test_data/testX ../weights/bswap-y2t-weights.pickle

		* bswap is the mode where bias and batch_normalization layers are swapped 
		  from the TensorFlow counterpart. As of now, this is required to use the 
		  DnnWeaver2 accelerator since Bias layer only works along with Conv layer 
		  on accelerator, while TensorFlow attches BatchNorm layer between Conv 
		  and Bias layers.

		$ ls ../test_data/testX/testX-tf-*

		* This pickle file contains all the intermediate outputs and final output 
	
3. Run Pure-Python-Yolo2-Tiny (dnn.python) in FP32 to get the intermediate .npy files

	(1) Run run.sh

		$ cd $TELLO_YOLO_HOME/dnn.python
		$ ./run.sh fp32 org \
					../test_data/testX/testX.npy \
		           	../weights/y2t-weights.pickle \
				   	None \
				   	../test_data/testX/testX-tf-org-outputs.pickle
		$ ./run.sh fp32 bswap \
					../test_data/testX/testX.npy \
					../weights/bswap-y2t-weights.pickle \
					None \
					../test_data/testX/testX-tf-bswap-outputs.pickle
		$ ls fp32_org_outputs/testX
		$ ls fp32_bswap_outputs/testX

		* Until now, every runs are on FP32, so there should not be any errors 
		  reported from the runs. 

4. Generate JSON files for fractional bits information using the intermediate outputs (frac_bits_json) 

	(1) Run gen_frac_bits.py
		
		$ cd $TELLO_YOLO_HOME/frac_bits_json
		$ python gen_frac_bits.py org \
					../dnn.python/fp32_org_outputs/testX \
					../weights/y2t-weights.pickle \
					testX_org_frac_bits.json
		$ python gen_frac_bits.py bswap \
					../dnn.python/fp32_bswap_outputs/testX \
					../weights/bswap-y2t-weights.pickle \
					testX_bswap_frac_bits.json
		$ ls

5. Quantize weight parameters based on the frac_bits.json file (fp32tofxp16)

	(1) Run run.sh

		$ cd $TELLO_YOLO_HOME/fp32tofxp16
		$ ./run.sh org org testX ../weights/y2t-weights.pickle
		$ ./run.sh org bswap testX ../weights/bswap-y2t-weights.pickle
		$ ls ../weights
		
		* These two runs produce four files.
			- fxp16-testX-y2t-weights.pickle
			- fxp16-testX-bswap-y2t-weights.pickle
			- fraqnn-testX-y2t-weights.pickle
			- fraqnn-testX-bswap-y2t-weights.pickle
		* Prefix fxp16 refers wegiht parameters that the pure python impl will use (dnn.python)
		* Prefix fraqnn refers weight parameters that DnnWeaver2 framework will use (dnn.fpga)

6. Run Pure-Python-Yolo2-Tiny (dnn.python) in FXP16, compare to the FP32 counterpart, 
   and calculate the error rate (NRMSE)

	(1) Run run.sh

		$ cd $TELLO_YOLO_HOME/dnn.python
		$ ./run.sh fxp16 org \
					../test_data/testX/testX.npy \
					../weights/fxp16-testX-y2t-weights.pickle \
					../frac_bits_json/testX_org_frac_bits.json \
					../test_data/testX/testX-tf-org-outputs.pickle
		$ ./run.sh fxp16 bswap \
					../test_data/testX/testX.npy \
					../weights/fxp16-testX-bswap-y2t-weights.pickle \
					../frac_bits_json/testX_bswap_frac_bits.json \
					../test_data/testX/testX-tf-bswap-outputs.pickle
		$ ls fxp16_org_outputs/testX
		$ ls fxp16_bswap_outputs/testX

	(2) Observe the error produced by these two runs (especially, bswap one).
		If the error is too high, gen_frac_bits.py should not be doing its work.
		Need to improve the quantization approach. 

