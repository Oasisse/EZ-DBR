# EZ-DBR: Automated Growth Control via In-Situ Spectral Reflectance

A CrystalXE script designed to automate the growth of Distributed Bragg Reflectors (DBRs) using real-time in-situ spectral reflectance feedback. This script is tailored for use with the CrystalXE Molecular Beam Epitaxy (MBE) reactor control software.

---

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Customization](#customization)
- [Contributing](#contributing)
- [License](#license)

---

## Introduction
EZ-DBR is a script that automates the growth of DBRs by monitoring and adjusting the growth process in real-time using spectral reflectance data. It is designed to work with CrystalXE MBE reactor control software, providing precise control over layer deposition and ensuring high-quality DBR structures.

<img width="1082" height="646" alt="A1630_FTIR" src="https://github.com/user-attachments/assets/d104d6ce-d3fc-4d92-8323-773f2a9c30d5" />

---

## Features
- **Real-Time Feedback Control**: Uses in-situ spectral reflectance to detect turning points and adjust growth parameters dynamically.
- **Automated Layer Switching**: Automatically switches between materials (e.g., AlAs and GaAs) based on real-time measurements.
- **Customizable Parameters**: Easily adjust the number of layers, detection points, and timing parameters.
- **Logging**: Logs intensity and wavelength data for post-growth analysis.

---

## Prerequisites
- **CrystalXE MBE Software**: This script is designed to run on CrystalXE MBE reactor control software. Ensure it is installed and configured for your reactor.
- **Reactor-Specific Configuration**: The script references specific cell names (e.g., `Growth.Ga6_ABN300DF.shutter.Control`). Update these names to match your reactor's configuration.

---

## Installation
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/Oasisse/EZ-DBR.git
   ```
2. **Update Cell Names**:
   - Open the script in a text editor.
   - Replace the cell names (e.g., `Growth.Ga6_ABN300DF.shutter.Control`) with the names used in your reactor setup.

3. **Load the Script**:
   - Open the CrystalXE software.
   - Load the script into the CrystalXE environment.
  
UNDER WRITING 

---

## Usage
1. **Prepare the Reactor**:
   - Ensure all necessary materials (e.g., AlAs, GaAs) are loaded and the reactor is ready for growth.

2. **Configure the Script**:
   - Set the desired number of layers (`numberLayers`), detection points (`n_points`), and minimum layer time (`time_min_layer`).
   - Ensure the `BraggRIBER.csv` file is correctly formatted and accessible.

3. **Run the Script**:
   - Start the script in the CrystalXE environment.
   - Monitor the real-time logs for intensity and wavelength data.

4. **Post-Growth Analysis**:
   - Review the logged data to verify the growth process and adjust parameters for future runs if necessary.

---

## Customization
- **Layer Parameters**: Adjust `numberLayers`, `n_points`, and `time_min_layer` to match your specific growth requirements.
- **Material Switching**: Modify the shutter control logic to match your reactor's configuration.
- **Logging**: Customize the logging format or add additional data points as needed.

---

## Contributing
Contributions are welcome! If you have suggestions for improvements or new features, please:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Submit a pull request with a clear description of your changes.

---

## License
This project is licensed under the [MIT License](LICENSE). Feel free to use, modify, and distribute the code as per the license terms.

---
