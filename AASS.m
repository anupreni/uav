clc;
%SETUP
W=3.52;      %All-up weight of UAV in lbf
N_motors=4;  %Number of motors
n=0.85;      %Average efficiency of motors
RPM=8000;    %Estimated setup RPM

%BATTERY
V=11;        %Selected motor voltage in volts
C=5200;      %Battery cell capacity in mAh

%PROPELLER
D = 10;          %Propeller diameter in inches
Pitch=4.7;       %Propeller pitch in inches
A=0.25*3.14*D^2; %Propeller sweep area in square inches
Aft=A*0.0069;    %Propeller sweep area in square feet

%FULL THROTLE
i=1;
for P_in=0.01:0.01:0.1  
    PL= (P_in*n)/Aft;               %Power loading equation
    TL = 8.6859*power(PL,-0.3107);  %Thrust loading equation
    Lift = TL*(P_in*n);             %Lift per Motor
    LiftTotal = Lift *N_motors;     %Total lift of the UAV
    PinWatt=P_in*745.7;             %Power input to motor in Watts
    disp(PinWatt);
    disp(LiftTotal);
    x(i)=PinWatt;
    y(i)=LiftTotal;
        if LiftTotal > 2*W
            break
        end
    i=i+1;
end
plot(x,y,'Marker','o') ;
xlswrite('1.xls',x);
xlswrite('2.xls',y);

            
Imotor = PinWatt/V;         %Current of motor
Itot = Imotor*N_motors;     %Total UAV current
PoutWatt =PinWatt*n ;       %Power relation involving motor efficiency 
KVreq = RPM /V;             %Required KV of motor
NomKVreq = KVreq/n;         %Nominal KV (labeled) of motorwhich accounts for efficiency
ESCreq = Imotor*1.2;        %Required ESC current for motor

%HOVER
j=1;
for PH_in=0.01:0.01:0.1
    PL_H = (PH_in*n)/Aft;              %Power loading equation for hover
    TL_H = 8.6859*power(PL_H,-0.3107); %Thrust loading equation for hover
    Lift_H = TL_H *(PH_in*n);          %Lift per motor at hover
    Lift_HTotal = Lift_H*N_motors;     %Total lift of the UAV at hover
    PH_inWatt = PH_in*745.7;           %Power input to motor at hover in Watts
    disp(PH_inWatt);
    disp(Lift_HTotal);
        if Lift_HTotal>W
            break
        end
    j=j+1;
end
I_Hmotor = PH_inWatt/V;           %Current of motor at hover
I_Htot = I_Hmotor * N_motors;     %Total hover UAV current
PH_outWatt = PH_inWatt*n;         %Power relation involving motor efficiency

%ENDURANCE
thover = (60 *(C/1000))/I_Htot;        %Hover endurance time based on the battery capacity and motor current with margin of error
tfullthrottle = (60*(C/1000))/Itot;    %Full throttle endurance time based on the battery capacity and motor current with margin of error
taverage =(thover + tfullthrottle)/2;  %Average endurance time;
