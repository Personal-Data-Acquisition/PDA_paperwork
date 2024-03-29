= -\> \# Code Review \<-
#label("code-review--")

#show raw: set text(size: 4pt)
```
                                            ████████╗███████╗ █████╗ ███╗   ███╗     ██████╗
                                            ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║    ██╔════╝
                                               ██║   █████╗  ███████║██╔████╔██║    ███████╗
                                               ██║   ██╔══╝  ██╔══██║██║╚██╔╝██║    ██╔═══██╗
                                               ██║   ███████╗██║  ██║██║ ╚═╝ ██║    ╚██████╔╝
                                               ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝     ╚═════╝

                      ██╗           ██████╗  █████╗ ████████╗ █████╗     ██╗      ██████╗  ██████╗  ██████╗ ███████╗██████╗            ██╗
                     ██╔╝           ██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗    ██║     ██╔═══██╗██╔════╝ ██╔════╝ ██╔════╝██╔══██╗           ╚██╗
                    ██╔╝█████╗█████╗██║  ██║███████║   ██║   ███████║    ██║     ██║   ██║██║  ███╗██║  ███╗█████╗  ██████╔╝█████╗█████╗╚██╗
                    ╚██╗╚════╝╚════╝██║  ██║██╔══██║   ██║   ██╔══██║    ██║     ██║   ██║██║   ██║██║   ██║██╔══╝  ██╔══██╗╚════╝╚════╝██╔╝
                     ╚██╗           ██████╔╝██║  ██║   ██║   ██║  ██║    ███████╗╚██████╔╝╚██████╔╝╚██████╔╝███████╗██║  ██║           ██╔╝
                      ╚═╝           ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝    ╚══════╝ ╚═════╝  ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝           ╚═╝
```


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

#show raw: set text(size: 4pt)
```
                                                       ┌───────────────────────┐
                                                       │ Single Board Computer │
                                                       │     (Raspberry Pi4)   │
                                                       │                       │
                                                       │                       │
                                                       │                       │
                                                       │                       │
                                                       └┬─────────────────────┬┘
                                                        ├─────────────────────┤
                                                        │  2CH CAN Interface  │
                                                        │                     │
                                                        └─┬─────┬─────┬─────┬─┘
                                                          │     │     │     │
                                                          │CAN0 │     │CAN1 │
                                                          │     │     │     │
                                                          └──┬──┘     └──┬──┘
                                                             │           │
                                                             │           │
                                                             │           │
                                                             │           │
                                                             │           │
                  ────▲──┬──────────────────────▲──┬─────────┘           └▲──┬─────────────────────▲──┬──────────────
                      │  │                      │  │                      │  │                     │  │
                      │  │                      │  │                      │  │                     │  │
                    ┌─┴──▼───┬┬───────┐      ┌──┴──▼──┬┬───────┐       ┌──┴──▼──┬┬───────┐      ┌──┴──▼──┬┬───────┐
                    │  CAN   ││DC->DC │◄─┐   │  CAN   ││DC->DC │◄──┐   │  CAN   ││DC->DC │◄──┐  │  CAN   ││DC->DC │◄──┐
                    │ Module ││ PSU   │  │   │ Module ││ PSU   │   │   │ Module ││ PSU   │   │  │ Module ││ PSU   │   │
                   ┌┴────────┴┴───────┴┐ │  ┌┴────────┴┴───────┴┐  │  ┌┴────────┴┴───────┴┐  │ ┌┴────────┴┴───────┴┐  │
                   │    STM32F103C8    │ │  │    STM32F103C8    │  │  │    STM32F103C8    │  │ │    STM32F103C8    │  │
                   │  Micro-Controller │ │  │  Micro-Controller │  │  │  Micro-Controller │  │ │  Micro-Controller │  │
                   │                   │ │  │                   │  │  │                   │  │ │                   │  │
                   └┬─────────────────┬┘ │  └┬─────────────────┬┘  │  └┬─────────────────┬┘  │ └┬─────────────────┬┘  │
                    │     SENSOR      │  │   │     SENSOR      │   │   │     SENSOR      │   │  │     SENSOR      │   │
                    │  (SPI/I2C/UART) │  │   │  (SPI/I2C/UART) │   │   │  (SPI/I2C/UART) │   │  │  (SPI/I2C/UART) │   │
                    └─────────────────┘  │   └─────────────────┘   │   └─────────────────┘   │  └─────────────────┘   │
                                         │                         │                         │                        │
                                         │                         │                         │                        │
┌────────────────┐                       │                         │                         │                        │
│                │                       │                         │                         │                        │
│   DC POWER     ├───────────────────────┴─────────────────────────┴─────────────────────────┴────────────────────────┘
│     RAIL       │
└────────────────┘
```



= -\> \# Sensor Modules Overview \<-
#label("sensor-modules-overview--")

#show raw: set text(size: 4pt)
```
                            SN65HVD230                                                                      Mini360
                         CAN Transceiver, Able to                                                 A DC to DC Boost/Buck converter.
                      Send and receive data at 1Mbps                                            The module can accept 12v DC power
                      Over a pair of wires while                                              │into the 3.3v DC that is required by
                      offering protection from  │                                             │the micro controller, can module and
                      electrical faults & noise │               ┌────────┬┬───────┐           │the sensors attached to it.
                      for reliable data transfer└────────────►  │  CAN   ││DC->DC │ ◄─────────┘
                                                                │ Module ││ PSU   │
                                                               ┌┴────────┴┴───────┴┐
                            Sensor Interface                   │    STM32F103C8    │
                                                               │  Micro-Controller │ ◄────────┐        STM32F103C8
                    Sensors have a variety of ways             │                   │          │
                    to connect physically to a micro-          └┬─────────────────┬┘          │ A micro-controller based on the
                    controller. The most common ones            │     SENSOR      │           │ARM cpu architecture built to be
                    are I2C, SPI(Serial Peripheral              │  (SPI/I2C/UART) │           │used in embedded systems where
                    Interface) and UART(Universal               └─────────────────┘            size and power consumption are
                    Asynchronous Receive and Transmit)                    ▲                     often concerns.
                                             ─────────────────────────────┘
```



= -\> \# Sensor data flow \<-
#label("sensor-data-flow--")

#show raw: set text(size: 4pt)
```
                                        ┌───────────────┐                              ┌────────────────┐
                                        │   SBC(RPi4)   │                              │  Senor Module  │
                                        └───────┬───────┘     Sends Request for        └────────┬───────┘
                                                │           Sensor Module Status                │
                                                ├──────────────────────────────────────────────►│
                                                │                                               │
                                                │                                               │
                                                │             Returns Status Data               │
                                                │◄──────────────────────────────────────────────┤
                                                │                                               │
                                                │                                               │
                                                │                                               │
                                                │             Requests Data Formatting          │
                                                │             For the available sensor data.     │
                                                ├──────────────────────────────────────────────►│
                                                │                                               │
                                                │             Responds with formatting          │
                                                │◄──────────────────────────────────────────────┤
                                                │                                               │
                                                │                                               │
                                                │                                               │
                                                │                                               │
                                                │             Requests Sensor Data              │
                                                ├──────────────────────────────────────────────►│
                                                │                                               │
                                                │              Sends the Sensor Data            │
                                                │◄──────────────────────────────────────────────┤
                                                │                                               │
                                                │                                               │
                                                │                                               │
                                                │                                               │
                                                │                                               │
                                                │                                               │
                                                │         ┌─────────────────────────────┐       │
                                                          │ END OF EXAMPLE TRANSMISSION │       │
                                                          └─────────────────────────────┘
```



= -\> \# Project Sensors Overview \<-
#label("project-sensors-overview--")

#show raw: set text(size: 4pt)
```
  ┌────────────────────────────────────────────────────────┐
  │                                                        │
  │                 Current Sensors Overview               │
  └────────────────────────────────────────────────────────┘


┌────────────┐          I2C Bus             ┌────────────────────────┐
│STM32F103C8 ├─────────────────────────────►│ AHT20(temp & humidity) │
└────────────┘                              └────────────────────────┘
<br>

┌────────────┐          I2C Bus             ┌────────────────────────────┐
│STM32F103C8 ├─────────────────────────────►│ MPU9250(Accel Gyro compass)│
└────────────┘                              └────────────────────────────┘                                                                          
<br>

┌────────────┐       SPI or USART           ┌────────────────────────────┐
│STM32F103C8 ├─────────────────────────────►│ GNSS7(GPS Data)            │
└────────────┘                              └────────────────────────────┘
<br>

┌────────────┐       SPI                    ┌────────────────────────────┐
│STM32F103C8 ├─────────────────────────────►│ MAX6675(Thermocouple K)    │
└────────────┘                              └────────────────────────────┘
```



= -\> \# Project Code & Repos \<-
#label("project-code-repos--")

#show raw: set text(size: 4pt)
```
                      ┌────────────────────────────────────────┐
                      │                                        │
                      │          Code Base Explanation         │
                      │                                        │
                      └────────────────────────────────────────┘


   ┌──────────────────┐            The pi can server is rust software to handle the coms
   │  Pi4_can_server  │            between the pi and the sensor modules on the can bus.
   └──────────────────┘
    ┌───────────────┐
    │     pda_ui    │              The UI repo holds the Rust rocket web server and user
    └───────────────┘              interface; designed to serve as a webpage application.

  ┌──────────────────┐             A Repo for the hardware designs and schematics. It
  │   pda_hardware   │             contains the needed electronic schematics and component
  └──────────────────┘             symbols/footprints for PCB manufacturing.

┌─────────────────────┐            Holds multiple branches of firmware for our current
│ stm32_sensor_module │            selection of sensors. It handles the data processing
└─────────────────────┘            as well as the can bus interfacing.

┌─────────────────┐              A separate sensor library I wrote for the temp & humidity
│sensor_lib_aht20 │              sensor. The existing library had issues that could lock up
└─────────────────┘              into an infinite loop so we needed a new one.
```



= -\> \# Development \<-
#label("development--")

#show raw: set text(size: 4pt)
```
         ┌───────────────────────────────────────────────┐
         │                                               │
         │          Firmware Development Cycle           │
         │                                               │
         └───────────────────────────────────────────────┘
```

+  Decide on new feature.

+  Setup tests where possible without hardware.

+  Write code to pass tests.

+  Repeat until hardware required.

+  Build hardware using breadboarding(manual wiring in test rig)

+  Cross-Compile rust code into hex/bin files for micro-controller.

+  Debug and test with Logic-Analyzers and Oscilloscopes.

+  Repeat for every new piece of hardware.



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


