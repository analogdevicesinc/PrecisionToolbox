set ad_hdl_dir    	[pwd]

#### Move files
file rename -force $ad_hdl_dir/hdl/vendor/AnalogDevices/vivado/scripts $ad_hdl_dir/scripts
file rename -force $ad_hdl_dir/hdl/vendor/AnalogDevices/vivado/projects $ad_hdl_dir/projects
file rename -force $ad_hdl_dir/hdl/vendor/AnalogDevices/vivado/library $ad_hdl_dir/library
