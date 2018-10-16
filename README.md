Instructions

1. Clone DnnWeaver2 repository

2. Follow the instructions on the DnnWeaver2 and set up the accelerator on the FPGA board

3. Run the driver.py with the dnnweaver2 directory included on the PYTHONPATH

	* Drone+DnnWeaver: sudo ./driver.sh drone dnnweaver2 weights/yolo2_tiny_tf_weights.pickle weights/yolo2_tiny_dnnweaver2_weights.pickle
	* Videofile+TF-CPU: ./driver.sh videofile tf-cpu weights/yolo2_tiny_tf_weights.pickle weights/yolo2_tiny_dnnweaver2_weights.pickle videofiles/video.mp4 videofiles/video-out.mp4
