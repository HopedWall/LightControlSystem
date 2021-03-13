# LightControlSystem

A traffic light control system implemented in VHDL. For detailed information about architectural solution read [doc](https://github.com/HopedWall/LightControlSystem/blob/master/doc/Gruppo2_VincenziPorto.pdf).

This traffic light works in three operative conditions:

- **NOMINAL**: red light is on for 5 seconds; green light on for 5/12 or 15 seconds (depend of MOD) and yellow for 2 seconds overlaid with green .
- **STANDBY**: yellow light flashes, for 1 second on and 2 seocond off.
- **MAINTENANCE**: all lights are off. During this phase is possible to set **modality** (MOD) of green light that will be active by next **NOMINAL** phase.
    - Possible MOD are: **MOD5** (default, green on for 5 seconds), **MOD12** (green on for 12 seconds) and **MOD15** (green on for 15 seconds).

Finally, there are also other two signals:

    - **ENABLE**: if high the traffic light is active and operate in previous operative conditions. If low the traffic light is off and does not respod to external input.
    - **RESET:**: active low; if 1->0 transition occurs the traffic light return to **MOD5**.


