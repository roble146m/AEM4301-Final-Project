function [rsc,vsc,finalDate] = hohmannJupiter(initialDate)
%function [rsc,vsc,finalDate] = spacecraft(initialDate)

% Simulates a Hohmann transfer to Jupiter
% Set initial date in app to 12/20/2024
% According to the theorertical calculations, launchDay will be 12.
%% Initialize
    
    muE = 398600;
    muS=1.327e11;          %Gravitational parameter for Sun
    aE = 149.6e6;
    aJ = 778.6e6;
    deltaVsc = sqrt((2*muS/aE) - (2*muS/(aE+aJ))) - sqrt(muS/aE); % = 8.7933

    %maxDays= (pi/sqrt(muS))*sqrt(((ae+aj)/2)^3)/(3600*24); % Number of days to follow the spaceraft = t12
                         % for Earth-Venus transfer

    maxDays = 998;
    nj = 2*pi/(11.86*365); % angular velocity (rad/day)
    phi0 = pi - nj*maxDays % lead anlge (rad)
    phideg = phi0*180/pi % Lead angle in degrees

    rsc=zeros(maxDays,3); % Position vector array for spacecraft
    vsc=zeros(maxDays,3); % Velocity vector array for spacecraft

    finalDate=initialDate+days(maxDays); %date when sc stops appearing in simulation
    
    launchDay=12; % # of days to launch from Start Date

    tinit=datetime(initialDate); %initial date in date format
%% Stay on Earth until day of launch use Curtis function

    for dayCount=1:launchDay
    t=tinit+days(dayCount-1); % index dayCount=1 corresponds to initial time.
    [y,m,d]=ymd(t);           % year month day format of current time

    % Use planet_elements_and_sv_coplanar to find current position and
    % velocity of Earth

    [~, r, v, ~] =planet_elements_and_sv_coplanar ...
    (1.327e11, 3, y, m, d, 0, 0, 0); % Launch at midnight

    % Update the position and velocity vectors
    rsc(dayCount,:)=[r(1),r(2),0];
    vsc(dayCount,:)=[v(1), v(2),0];
    end
 
%% Launch Maneuver
    t=tinit+days(launchDay);
    [y,m,d]=ymd(t);
    [~, R, V, ~] =planet_elements_and_sv_coplanar ...
    (1.327e11, 3, y, m, d, 0, 0, 0); %Earth on launch day

    %Per the theoretical calculations, the velocity of the spacecraft after
    %launch should be 2.5 km/s less than that of Earths and in the same
    %direction.
    % For jupiter, it's about 8.7933

    Vsc = V + 8.9*V/norm(V) 
    
   % Calculate the orbital elements for spacecraft
   [h,a,e,w,E0]=scElements(R,Vsc);

    % new orbit for spacecraft
   [rsc,vsc]=propagate(h,a,e,w,E0,launchDay+1,maxDays,rsc,vsc);

   %This worked pretty well. We can still adjust the launch day for closer
   %interception.
 
   %% Final Parameters: 
    % deltaVsc = 8.9
    % Launch Date: Oct. 11, 2026
