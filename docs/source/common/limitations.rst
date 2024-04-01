Limitations
-----------

Known Limitations, Bugs and Quirks
==================================

Some limitations and bugs are known to be present in the support for the ADCs relevant to the Precision Toolbox. They have been summarized below.

**Libiio backend**

Currently only ethernet/IP backends are supported for all the parts in the toolbox. For AD4030-24, AD4630-16 and AD4630-24 the usb backend can also be used. Serial backends are not supported.  

**AD7380**

Trigger setup needs to be done before running any of the toolbox scripts that interact with the AD7380. Refer to the `Trigger Management section on the AD738x Linux IIO driver wiki page <https://wiki.analog.com/resources/tools-software/linux-drivers/iio-adc/ad738x#trigger_management>`_

**AD7768**

The Linux IIO driver for the AD7768 returns data for all the channels whenever a data capture is requested. So, in order to get sensible outputs, ensure that the EnabledChannels array consists of indices for all the channels. 

**AD4030-24. AD4630-16, AD4630-24**

The Linux IIO driver for the three parts (there's a common Linux driver that addresses all three parts) returns data for all the channels whenever a data capture is requested. In order to have sensible outputs, ensure that the EnabledChannels array consists of indices for all the channels. 

Another known issue here has to do with the case where the ADC sends out common mode voltage data along with the differential voltage data. The EnabledChannel property values that consist of more than two indices (even when there are 4 IIO channels), are not 'valid'. Of the possible groupings with two channel indices, the ones that correspond to {differential0, common_voltage0} and {differential1, common_voltage1} are also not 'valid' 

It is possible to get data (common-mode and differential) for all the ADC channels, by using a 'valid' channel grouping, setting the BufferTypeConversionEnable property to 'false' in the Base class for the AD463x family, and adding custom parsing logic to extract the data for all IIO channels, from the 32-bit raw words you get from the data capture.