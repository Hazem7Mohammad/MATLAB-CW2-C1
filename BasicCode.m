clear
a = arduino('COM5', 'Uno', 'Libraries', 'Servo');
s = servo(a, 'D3', 'MinPulseDuration', 700*10^-6, 'MaxPulseDuration', 2300*10^-6);

pos = 0.5;
writePosition(s, pos);
pause(2);

rightPin = 'A0';
midPin = 'A1';
leftPin = 'A2';

ii = 0;
LightR = zeros(1e4,1);
LightM = zeros(1e4,1);
LightL = zeros(1e4,1);
t = zeros(1e4,1);

%%
tic
while toc < 10   
   ii = ii + 1;

   rightLevel = readVoltage(a,rightPin);
   midLevel = readVoltage(a,midPin);
   leftLevel = readVoltage(a,leftPin);
   fprintf('Right light level is %d watt\n', rightLevel);
   fprintf('Middle light level is %d watt\n', midLevel);
   fprintf('Left light level is %d watt\n', leftLevel);
   if (leftLevel > midLevel) &&  (leftLevel>rightLevel)
       pos=pos+0.01;
        if pos > 0.8 
            pos=0.8;
        end
       writePosition(s,pos);
   end
   if (rightLevel > midLevel) &&  (rightLevel>leftLevel)
       pos=pos-0.01;
       if pos < 0.2 
            pos=0.2;
       end
       writePosition(s,pos);
   end
   if (midLevel > rightLevel) &&  (midLevel>leftLevel)
       writePosition(s,pos);
   end
   drawnow
   LightR(ii) = rightLevel;
   LightM(ii) = midLevel;
   LightL(ii) = leftLevel;
   t(ii) = toc;
end
LightR = LightR(1:ii);
LightM = LightM(1:ii);
LightL = LightL(1:ii);
t = t(1:ii);
% Plot light versus time
figure
plot(t,LightR,'-o')
hold on
plot(t,LightM,'-o')
hold on
plot(t,LightL,'-o')
hold off
xlabel('Elapsed time (sec)')
ylabel('Light (L)')
title('20 Seconds of Light Data')
set(gca,'xlim',[t(1) t(ii)])

