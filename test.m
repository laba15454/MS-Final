omega1=0:50000;
omega1=omega1/1000;
omega1=omega1+(glassPitch-25);
omega1=omega1./glassPitch;
y=1./(abs(1-(omega1).^2)+0.001);
plot(omega1,y);