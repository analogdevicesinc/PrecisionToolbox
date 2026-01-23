.. pctlbx-docs documentation master file, created by
   sphinx-quickstart on Mon Apr  1 11:50:10 2024.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Precision Toolbox for MATLAB
============================

  .. image:: /pctlbxLogo.png
      :width: 600

ADI maintains a set of tools to interface with ADI precision converters within MATLAB and Simulink. These are combined into a single toolbox. Currently, the toolbox supports only converter configuration and data streaming.

.. toctree::
   :maxdepth: 1
   :caption: Index:

   /common/installation.rst
   /common/data_streaming.rst
   /common/examples.rst
   /common/limitations.rst
   /common/support.rst
   /reference_api/index.rst

The following have device-specific implementations in MATLAB and Simulink. In general, if a device has an IIO driver, MATLAB support is possible, but a device-specific MATLAB or Simulink interface may not exist yet.

.. csv-table:: Supported Parts
   :header: "Evaluation Card", "Controller Board", "Streaming Support", "Targeting", "Variants and Minimum Supported Release"
   :widths: 30, 30, 30, 30, 30

   "AD7380", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD7381", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD7383", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD7384", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD7386", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD7387", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD7388", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD7380-4", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD7381-4", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD7383-4", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD7386-4", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD7387-4", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD7388-4", "Zedboard", "Yes", "No", "ADI (2021b)"
   "ADAQ4370-4", "Zedboard", "Yes", "No", "ADI (2021b)"
   "ADAQ4380-4", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD7768", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD7768-1", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD4030-24", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD4630-16", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD4630-24", "Zedboard", "Yes", "No", "ADI (2021b)"
   "ADAQ4224", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD4858", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD2S1210", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD4000", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD4001", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD4002", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD4003", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD4004", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD4005", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD4006", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD4007", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD4008", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD4010", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD4011", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD4020", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD4021", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD4022", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD5760", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD5780", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD5781", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD5790", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD5791", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD7124-4", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD7124-8", "Zedboard", "Yes", "No", "ADI (2021b)"
   "AD3530r", "SDP-K1", "Yes", "No", "ADI (2021b)"
   "AD4050", "SDP-K1", "Yes", "No", "ADI (2021b)"
   "AD4052", "SDP-K1", "Yes", "No", "ADI (2021b)"
   "AD4060", "SDP-K1", "Yes", "No", "ADI (2021b)"
   "AD4062", "SDP-K1", "Yes", "No", "ADI (2021b)"
   "AD4170", "SDP-K1", "Yes", "No", "ADI (2021b)"
   "AD7190", "SDP-K1", "Yes", "No", "ADI (2021b)"
   "AD7192", "SDP-K1", "Yes", "No", "ADI (2021b)"
   "AD7193", "SDP-K1", "Yes", "No", "ADI (2021b)"
   "AD7194", "SDP-K1", "Yes", "No", "ADI (2021b)"
   "AD7195", "SDP-K1", "Yes", "No", "ADI (2021b)"
   "AD4170", "SDP-K1", "Yes", "No", "ADI (2021b)"
   "AD4190", "SDP-K1", "Yes", "No", "ADI (2021b)"
   "AD5592r", "SDP-K1", "Yes", "No", "ADI (2021b)"
   "AD5593r", "SDP-K1", "Yes", "No", "ADI (2021b)"
   "AD5710r", "SDP-K1", "Yes", "No", "ADI (2021b)"
   "AD5706r", "SDP-K1", "Yes", "No", "ADI (2021b)"