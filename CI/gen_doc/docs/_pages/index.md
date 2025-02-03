{% include 'header.tmpl' %}

<!-- Hide header and click button -->
<style>
  .md-typeset h1,
  .md-content__button {
    display: none;
  }
</style>

<center>
<div class="dark-logo">
<!--<img src="https://raw.githubusercontent.com/analogdevicesinc/HighSpeedConverterToolbox/master/CI/doc/hsx_300.png" alt="PCX Toolbox" width="80%">-->
<!--<img src="assets/PCXTlbx_Image.png" alt="PCX Toolbox" width="80%">-->
<img src="assets/PcxToolboxLogo.png" alt="PCX Toolbox" width="80%">
</div>
<div class="light-logo">
<!--<img src="https://raw.githubusercontent.com/analogdevicesinc/HighSpeedConverterToolbox/master/CI/doc/hsx_w_300.png" alt="PCX Toolbox" width="80%">-->
<img src="assets/PcxToolboxLogo.png" alt="PCX Toolbox" width="80%">
</div>
</center>


ADI maintains a set of tools to interface with ADI precision converters within MATLAB and Simulink. These are combined into a single toolbox. The list of supported parts is provided below.

The following have device-specific implementations in MATLAB and Simulink. If a device has an IIO driver, MATLAB support is possible, but a device-specific MATLAB or Simulink interface may not exist yet.

| Evaluation Card | FPGA Board | Streaming Support | Targeting | Variants and Minimum Supported Release |
| --------- | --------- | --------- | --------- | --------- |
| AD7380	| Zedboard	| Yes	| No	| ADI (2021b) |
| AD7625    | Zedboard  | Yes   | No    | ADI (2021b) |
| AD7626    | Zedboard  | Yes   | No    | ADI (2021b) |
| AD7960    | Zedboard  | Yes   | No    | ADI (2021b) |
| AD7961    | Zedboard  | Yes   | No    | ADI (2021b) |
| AD7768    | Zedboard  | Yes   | No    | ADI (2021b) |
| AD7768-1  | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4030-24 | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4630-16 | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4630-24 | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4858    | Zedboard  | Yes   | No    | ADI (2021b) |
| AD2S1210  | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4000    | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4001    | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4002    | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4003    | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4004    | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4005    | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4006    | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4007    | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4008    | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4010    | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4011    | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4020    | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4021    | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4022    | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4170    | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4190    | Zedboard  | Yes   | No    | ADI (2021b) |
| AD7124-4  | Zedboard  | Yes   | No    | ADI (2021b) |
| AD7124-8  | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4080    | Zedboard  | Yes   | No    | ADI (2021b) |
=======
