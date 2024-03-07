= -\> \# Code Review \<-
#label("code-review--")
#emph[ ████████╗███████╗ █████╗ ███╗ ███╗ ██████╗
╚══██╔══╝██╔════╝██╔══██╗████╗ ████║ ██╔════╝ ██║ █████╗
███████║██╔████╔██║ ███████╗ ██║ ██╔══╝ ██╔══██║██║╚██╔╝██║ ██╔═══██╗
██║ ███████╗██║ ██║██║ ╚═╝ ██║ ╚██████╔╝ ╚═╝ ╚══════╝╚═╝ ╚═╝╚═╝ ╚═╝
╚═════╝ ] ██╗ ██████╗ █████╗ ████████╗ █████╗ ██╗ ██████╗ ██████╗
██████╗ ███████╗██████╗ ██╗ ██╔╝ ██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗ ██║
██╔═══██╗██╔════╝ ██╔════╝ ██╔════╝██╔══██╗ ╚██╗ ██╔╝█████╗█████╗██║
██║███████║ ██║ ███████║ ██║ ██║ ██║██║ ███╗██║ ███╗█████╗
██████╔╝█████╗█████╗╚██╗ ╚██╗╚════╝╚════╝██║ ██║██╔══██║ ██║ ██╔══██║
██║ ██║ ██║██║ ██║██║ ██║██╔══╝ ██╔══██╗╚════╝╚════╝██╔╝ ╚██╗
██████╔╝██║ ██║ ██║ ██║ ██║
███████╗╚██████╔╝╚██████╔╝╚██████╔╝███████╗██║ ██║ ██╔╝ ╚═╝ ╚═════╝ ╚═╝
╚═╝ ╚═╝ ╚═╝ ╚═╝ ╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝ ╚═╝ ╚═╝


= -\> Project Overview \<-
#label("project-overview--")
Data logger: #emph[system that logs data(sensor information) over time.]

#strong[Example:]

-  Logging data from a car for tuning.
-  Logging data from UAVs for diagnostics & deep learning.
-  Learning modes of failure of motors for preventative maintenance.

#strong[Projects goals:]

-  Create an affordable dataloger.
-  Build it using the Rust language.
-  Use CAN(controller area network) for communication of data.


= -\> \# Project Roles \<-
#label("project-roles--")
#strong[Front End:] \* Aidan: GPS data presentation & other UI
components. \* Blake: UI & web server development. #strong[Back End:] \*
Jake(ME): Electronic Schematic Designs, PCB & firmware development. \*
Patrick: Firmware development, SBC CAN controller designer.


= -\> \# Some Terms \<-
#label("some-terms--")
#strong[CAN] (Controller Area Network)

-  Communication protocol
-  Used in Automotive & Industrial settings.
-  Highly resistant to EMI(electromagnetic interference).

#strong[uC] AKA Micro-Controllers

-  A minimal SOC(system on chip) computer.
-  Usually designed for low power.
-  Often with very little memory and processing power.
-  Requires cross-compiling and flashing of programs(in many cases.)
-  Traditionally programmed using C and assembly language(cpp has become
  common as well).



= -\> \# High level Hardware Overview \<-
#label("high-level-hardware-overview--")
\_ ┌───────────────────────┐ │ Single Board Computer │ │ (Raspberry Pi4)
│ │ │ │ │ │ │ │ │ └┬─────────────────────┬┘ ├─────────────────────┤ │
2CH CAN Interface │ │ │ └─┬─────┬─────┬─────┬─┘ │ │ │ │ │CAN0 │ │CAN1 │
│ │ │ │ └──┬──┘ └──┬──┘ │ │ │ │ │ │ │ │ │ │
────▲──┬──────────────────────▲──┬─────────┘
└▲──┬─────────────────────▲──┬────────────── │ │ │ │ │ │ │ │ │ │ │ │ │ │
│ │ ┌─┴──▼───┬┬───────┐ ┌──┴──▼──┬┬───────┐ ┌──┴──▼──┬┬───────┐
┌──┴──▼──┬┬───────┐ │ CAN ││DC-\>DC │◄─┐ │ CAN ││DC-\>DC │◄──┐ │ CAN
││DC-\>DC │◄──┐ │ CAN ││DC-\>DC │◄──┐ │ Module ││ PSU │ │ │ Module ││
PSU │ │ │ Module ││ PSU │ │ │ Module ││ PSU │ │ ┌┴────────┴┴───────┴┐ │
┌┴────────┴┴───────┴┐ │ ┌┴────────┴┴───────┴┐ │ ┌┴────────┴┴───────┴┐ │
│ STM32F103C8 │ │ │ STM32F103C8 │ │ │ STM32F103C8 │ │ │ STM32F103C8 │ │
│ Micro-Controller │ │ │ Micro-Controller │ │ │ Micro-Controller │ │ │
Micro-Controller │ │ │ │ │ │ │ │ │ │ │ │ │ │ └┬─────────────────┬┘ │
└┬─────────────────┬┘ │ └┬─────────────────┬┘ │ └┬─────────────────┬┘ │
│ SENSOR │ │ │ SENSOR │ │ │ SENSOR │ │ │ SENSOR │ │ │ (SPI/I2C/UART) │ │
│ (SPI/I2C/UART) │ │ │ (SPI/I2C/UART) │ │ │ (SPI/I2C/UART) │ │
└─────────────────┘ │ └─────────────────┘ │ └─────────────────┘ │
└─────────────────┘ │ │ │ │ │ │ │ │ │ ┌────────────────┐ │ │ │ │ │ │ │ │
│ │ │ DC POWER
├───────────────────────┴─────────────────────────┴─────────────────────────┴────────────────────────┘
│ RAIL │ └────────────────┘



= -\> \# Sensor Modules Overview \<-
#label("sensor-modules-overview--")
\_ SN65HVD230 Mini360 CAN Transceiver, Able to A DC to DC Boost/Buck
converter. Send and receive data at 1Mbps The module can accept 12v DC
power Over a pair of wires while │into the 3.3v DC that is required by
offering protection from │ │the micro controller, can module and
electrical faults & noise │ ┌────────┬┬───────┐ │the sensors attached to
it. for reliable data transfer└────────────► │ CAN ││DC-\>DC │
◄─────────┘ │ Module ││ PSU │ ┌┴────────┴┴───────┴┐ Sensor Interface │
STM32F103C8 │ │ Micro-Controller │ ◄────────┐ STM32F103C8 Sensors have a
variety of ways │ │ │ to connect physically to a micro-
└┬─────────────────┬┘ │ A micro-controller based on the controller. The
most common ones │ SENSOR │ │ARM cpu architecture built to be are I2C,
SPI(Serial Peripheral │ (SPI/I2C/UART) │ │used in embedded systems where
Interface) and UART(Universal └─────────────────┘ size and power
consumption are Asynchronous Receive and Transmit) ▲ often concerns.
─────────────────────────────┘



= -\> \# Sensor data flow \<-
#label("sensor-data-flow--")
\_ ┌───────────────┐ ┌────────────────┐ │ SBC(RPi4) │ │ Senor Module │
└───────┬───────┘ Sends Request for └────────┬───────┘ │ Sensor Module
Status │ ├──────────────────────────────────────────────►│ │ │ │ │ │
Returns Status Data │ │◄──────────────────────────────────────────────┤
│ │ │ │ │ │ │ Requests Data Formatting │ │ For the available sensor
data. │ ├──────────────────────────────────────────────►│ │ │ │ Responds
with formatting │ │◄──────────────────────────────────────────────┤ │ │
│ │ │ │ │ │ │ Requests Sensor Data │
├──────────────────────────────────────────────►│ │ │ │ Sends the Sensor
Data │ │◄──────────────────────────────────────────────┤ │ │ │ │ │ │ │ │
│ │ │ │ │ ┌─────────────────────────────┐ │ │ END OF EXAMPLE
TRANSMISSION │ │ └─────────────────────────────┘



= -\> \# Project Sensors Overview \<-
#label("project-sensors-overview--")
┌────────────────────────────────────────────────────────┐ │ │ │ Current
Sensors Overview │
└────────────────────────────────────────────────────────┘

┌────────────┐ I2C Bus ┌────────────────────────┐ │STM32F103C8
├─────────────────────────────►│ AHT20(temp & humidity) │ └────────────┘
└────────────────────────┘

┌────────────┐ I2C Bus ┌────────────────────────────┐ │STM32F103C8
├─────────────────────────────►│ MPU9250(Accel Gyro compass)│
└────────────┘ └────────────────────────────┘ \

┌────────────┐ SPI or USART ┌────────────────────────────┐ │STM32F103C8
├─────────────────────────────►│ GNSS7(GPS Data) │ └────────────┘
└────────────────────────────┘

┌────────────┐ SPI ┌────────────────────────────┐ │STM32F103C8
├─────────────────────────────►│ MAX6675(Thermocouple K) │
└────────────┘ └────────────────────────────┘



= -\> \# Project Code & Repos \<-
#label("project-code-repos--")
\_ ┌────────────────────────────────────────┐ │ │ │ Code Base
Explanation │ │ │ └────────────────────────────────────────┘

┌──────────────────┐ The pi can server is rust software to handle the
coms │ Pi4\_can\_server │ between the pi and the sensor modules on the
can bus. └──────────────────┘ \_ ┌───────────────┐ │ pda\_ui │ The UI
repo holds the Rust rocket web server and user └───────────────┘
interface; designed to serve as a webpage application.

┌──────────────────┐ A Repo for the hardware designs and schematics. It
│ pda\_hardware │ contains the needed electronic schematics and
component └──────────────────┘ symbols/footprints for PCB manufacturing.

┌─────────────────────┐ Holds multiple branches of firmware for our
current │ stm32\_sensor\_module │ selection of sensors. It handles the
data processing └─────────────────────┘ as well as the can bus
interfacing.

┌─────────────────┐ A separate sensor library I wrote for the temp &
humidity │sensor\_lib\_aht20 │ sensor. The existing library had issues
that could lock up └─────────────────┘ into an infinite loop so we
needed a new one.



= -\> \# Development \<-
#label("development--")
\_ ┌───────────────────────────────────────────────┐ │ │ │ Firmware
Development Cycle │ │ │
└───────────────────────────────────────────────┘

1. Decide on new feature. 2. Setup tests where possible without
hardware. 3. Write code to pass tests. 4. Repeat until hardware
required.

6. Build hardware using breadboarding(manual wiring in test rig) 7.
Cross-Compile rust code into hex/bin files for micro-controller. 8.
Debug and test with Logic-Analyzers and Oscilloscopes. 9. Repeat for
every new piece of hardware.



= -\> \# Technical Challenges \<-
#label("technical-challenges--")
-  DataSheets Lie sometimes –\> GH issue \#11 on AHT20
-  Bad solder joints can hide in plain sight.
-  Rust is relatively new.
-  Tooling is also different than C.
-  Building code for components you don’t have.



= -\> \# Solutions \<-
#label("solutions--")
-  Mocking of Unavailable hardware.
-  Writing Unit tests & running them on development machines.
-  Using memory safe language(apparently not totally safe)\*
-  Lots of diagnostic tooling(Logic-Analyzer & Oscilloscopes)



= -\> \# Live Demo \<-
#label("live-demo--")
-  Demo of Sensor data readings.
-  Demo of CAN communications.
-  Walk-through of schematic designs.


