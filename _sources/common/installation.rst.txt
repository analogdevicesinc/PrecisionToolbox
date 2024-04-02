Installation
------------

============
Dependencies
============

The toolbox has different dependencies based on the features required. The base dependencies for streaming data are listed below. 

The base dependencies for the toolbox requires libiio and the libiio MATLAB bindings. There are three options for this install with different required MathWorks Toolboxes:

- `Communications Toolbox Support Package for Xilinx Zynq-Based Radio <https://www.mathworks.com/help/supportpkg/xilinxzynqbasedradio/index.html>`_
    - Communications Toolbox
    - Signal Processing Toolbox :sup:`TM`
    - DSP System Toolbox :sup:`TM`
- `Communications Toolbox Support Package for Analog Devices ADALM-Pluto Radio <https://www.mathworks.com/help/supportpkg/plutoradio/index.html>`_
    - Communications Toolbox
    - Signal Processing Toolbox :sup:`TM`
    - DSP System Toolbox :sup:`TM`
- `libiio MATLAB Binding Standalone Installer (R2021b+) <https://github.com/mathworks/buildroot/releases/download/mathworks_zynq_R21.2.0/libiio.mlpkginstall>`_
    - Signal Processing Toolbox :sup:`TM`


=========================
Precision Toolbox Install
=========================

The Precision Toolbox itself can be installed either from:

- `MATLAB's Add-On Explorer <https://www.mathworks.com/products/matlab/add-on-explorer.html>`_
- `GitHub Releases page <https://github.com/analogdevicesinc/PrecisionToolbox/releases>`_

.. warning::
    Before installing Precision Toolbox check the `Release Page <https://github.com/analogdevicesinc/PrecisionToolbox/releases>`_ to check for the latest supported version of MATLAB. The latest version is the one which is available in `Add-on Explorer <https://www.mathworks.com/products/matlab/add-on-explorer.html>`_ , since Add-On Explorer does not currently support hosting multiple versions. If you have an older release of MATLAB, download the MLTBX installer from matching release on the `Release Page <https://github.com/analogdevicesinc/PrecisionToolbox/releases>`_ .

===========================
Add-On Explorer Walkthrough
===========================

To install the toolbox from within MATLAB using the Add-On Explorer:

 - Launch the Add-Ons Explorer from MATLAB's Home tab
 - Search for 'Precision Toolbox'
 - Select Precision Toolbox from Analog Devices, Inc. from the results:
 - Install the toolbox