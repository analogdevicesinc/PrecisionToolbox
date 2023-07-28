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
| AD7768    | Zedboard  | Yes   | No    | ADI (2021b) |
| AD7768-1  | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4030-24 | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4630-16 | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4630-24 | Zedboard  | Yes   | No    | ADI (2021b) |
| AD4858    | Zedboard  | Yes   | No    | ADI (2021b) |
