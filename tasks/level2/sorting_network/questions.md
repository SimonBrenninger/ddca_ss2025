- Why does your sorting network supposedly sort the first inputs?

    TODO
- Why does your sorting network fail to successfully sort the second inputs?

    TODO
- What is your design's `Fmax`? Explain how you got this value.

    21.31 MHz
    Quartus -> Tasks -> Timing Analysis -> Timing Analyser -> Tasks -> Report Fmax Summary
- What is your design's `Critical-Path`? Explain how you got this information.

    clock path -> uart_streamer -> sorting network -> uart_streamer:
    Timing Analyser -> Tasks -> Report Setup Summary -> right click on pll clk -> Report Timing