# Full DF Using Four Antenna Spacial Duplexing and Frequency Falloff Characteristics 

# Given

A four antenna array can create a baring of a signal due to the phase shift of a received signal providing a direction of the signal but does not contain enough falloff to create a range (this is accomplished using a PLL, measuring the phase differential and determining a polar direction)

4x4 MIMO hardware with beam-forming is now commodity hardware and can provide a polar direction from a point

Wi-Fi will broadcast at a beacon at a value of the US power output of 250mw

Wi-Fi will use the same power output of a dual band AP

The proportional fall-off of the signal from the inverse square law in a vacuum holds, and is predictably affected by non-vacuum medium

The fall off of a higher energy signal like a 5.7GHz signal is higher in a predictable way then the fall off of a 2.4GHz signal

It is typically trivial to correlate the MAC addresses of the same AP broadcasting both 5.7GHz and 2.4GHz signals thanks to both OUI and sequential MAC assignment

The proportional fall off of the energy difference can provide effective ranging

One or two calibration points can provide a mapping of proportional falloff to linear distance

Single point DF using four antennas and commodity hardware is possible

Q.E.D.

