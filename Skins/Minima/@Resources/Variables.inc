; ============================================================
;  Minima - user settings.
;  Edit freely. When packaged with "Variable files" enabled,
;  your edits survive skin updates.
;  NOTE: comments must be on their own line (no inline comments).
; ============================================================
[Variables]

; Drive shown in the STORAGE row
Drive=C:

; ----- SIZE -----
; Written automatically when you scroll or use the right-click menu.
; You can also edit it by hand (0.6 to 2.5), then Refresh the skin.
Scale=1

; ----- HWiNFO -----
; Registry key HWiNFO writes flagged sensors to
HwRegKey=Software\HWiNFO64\VSB

; Number of Label/Sensor/Value slots defined in Minima.ini (default 10)
HwSlots=10

; Reading labels exactly as shown in the HWiNFO Sensors window.
; Separate alternatives with | - the first one found wins.
HwCpuTempLabel=CPU Package|Core Max
HwGpuLoadLabel=GPU Core Load|GPU Total Usage|GPU D3D Usage|GPU Utilization
HwGpuTempLabel=GPU Temperature|GPU Core Temperature

; Sensor-name filters that tell the two GPUs apart.
; Any of these substrings (case-insensitive) in the sensor name matches.
HwIGpuSensor=iGPU|Intel UHD|Intel Iris|Intel Xe|Intel HD
HwDGpuSensor=dGPU|NVIDIA

; The dGPU counts as "in use" when it is awake and at or above this load (%)
GpuThreshold=5

; Fonts (fall back to a system font automatically if not installed)
FontTitle=Anurati
FontBody=Quicksand

; Colors - Mond-style monochrome (hex RRGGBB or RRGGBBAA)
ColText=FFFFFF
ColSoft=EAEAEA
ColMuted=B8B8B8
ColDim=858585
ColTrack=FFFFFF26
ColAccent=FF6A00

; Panel behind the skin, R,G,B,A.
; Alpha 1 = invisible but still draggable. Try 16,16,16,170 for a dark panel.
ColBg=0,0,0,1

; ----- LAYOUT (all values scale with Scale) -----
; Base numbers are the 1.0x sizes. Change the number before *, not Scale.
; If you change W or P, also update SkinW (= W + 2*P).
; SkinH = Y4 + OffBar + BarH + P.
TitleSize=(30*#Scale#)
FsLabel=(9*#Scale#)
FsBig=(32*#Scale#)
FsPct=(13*#Scale#)
FsSide=(12*#Scale#)

W=(300*#Scale#)
P=(24*#Scale#)
SkinW=(348*#Scale#)
SkinH=(386*#Scale#)

Y1=(80*#Scale#)
Y2=(154*#Scale#)
Y3=(228*#Scale#)
Y4=(302*#Scale#)

OffBig=(13*#Scale#)
OffPct=(28*#Scale#)
OffSide=(29*#Scale#)
OffBar=(58*#Scale#)
BarH=(2*#Scale#)
PctGap=(2*#Scale#)

DotSize=(5*#Scale#)
DotGap=(5*#Scale#)
DotNudge=(3*#Scale#)
